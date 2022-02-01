# VoIP calls and CallKit

VoIP calls or Voice over IP.

## Overview

Here we will discuss the process of setting up an application with VoIP enabled and how CallKit can be used with it.

## Setup
VoIP apps need permissions to be VoIP apps on iOS. We have 3 main tasks to accomplish. 
1. Enable Voice over IP Background mode
![Enable VoIP](image_8.png)
2. Create a VoIP Certificate on developer.apple.com and install it into your Keychain
3. Enable PushKit Capabilities
![Enable PushKit](image_9.png)

## Certificates
The first thing you are going to want to do is...
1. Go to your Apple Developer account and navigate to Certificates, Identifiers, Profiles.
2. Press **Certificates +**
3. Scroll to services
4. Create the VoIP Service
![Enable Voip Service](image_10.png)
Before you can complete the service creation you will need to request a certificate from a certificate authority. Go ahead and save it to disk.
![Enable Voip Service](image_11.png)
Apple is going to ask for the certificate when you set up the VoIP Service afterward you can download the certificate and double click on it to have Keychain Access install it.

## CallKit

You can choose to use CallKit in your VoIP app. It has quite a bit of setup. So what we are going to do is outline how CallKit works with FCSDK and VoIP. CallKit acts as a mediator between the Client and the Server. It wants to play with both sides so it can show off Apple's native call UI giving you a native calling experience.

### Making Calls
The basic flow for making calls is we create a call Object, we send it to CallKit to add to the array of calls for CallKit to be aware of, we then pass the call Object off to FCSDK and FCSDK sends it to the server.

### Receiving Calls
The basic flow for receiving a call is, the server send the call to the Client, the client then notifies CallKit so that CallKit can display the native UI. Once we interact with the native UI, CallKit will tell FCSDK about the call which we then will establish the call.

Seems simple but there are quite a few pieces in motion and when we add more complexity to the call flow like notfiying calls when the phone is locked it become complex. The PushKit Section will talk about receiving calls when the phone is locked. But for the rest of this section we will show you a very basic example.

Let's create a call object
```swift
final class FCSDKCall: NSObject {

    var handle: String
    var hasVideo: Bool
    var previewView: UIView? = nil
    var remoteView: UIView? = nil
    var uuid: UUID
    var acbuc: ACBUC? = nil
    var call: ACBClientCall? = nil
    
    
    init(
        handle: String,
        hasVideo: Bool,
        previewView: UIView? = nil,
        remoteView: UIView? = nil,
        uuid: UUID,
        acbuc: ACBUC? = nil,
        call: ACBClientCall? = nil
    ) {
        self.handle = handle
        self.hasVideo = hasVideo
        self.previewView = previewView
        self.remoteView = remoteView
        self.uuid = uuid
        self.acbuc = acbuc
        self.call = call
    }
}
```
This object we will be used for making our call and answering calls. Please see the article about making calls entitled <doc:VideoCalls> for an explaination. Here we will show you what to do in the CallKit world of things. Let's create a CallKitManager.


```swift
class CallKitManager: NSObject, ObservableObject {
    
    let callController = CXCallController()
    var calls = [FCSDKCall]()
    
    
    func startCall(_ call: FCSDKCall) async {
        await self.makeCall(uuid: call.uuid, handle: call.handle, hasVideo: call.hasVideo)
    }

    func makeCall(uuid: UUID, handle: String, hasVideo: Bool = false) async {
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        startCallAction.isVideo = hasVideo
        let transaction = CXTransaction()
        transaction.addAction(startCallAction)
        await requestTransaction(transaction)
    }


    func finishEnd(call: FCSDKCall) async {
        let endCallAction = CXEndCallAction(call: call.uuid)
        let transaction = CXTransaction()
        transaction.addAction(endCallAction)
        await requestTransaction(transaction)
    }

    private func requestTransaction(_ transaction: CXTransaction) async {
        do {
            try await callController.request(transaction)
        } catch {
            print("Error requesting transaction:", error)
        }
    }
}

```
Here we have a class that Initializes our **CXCallController()**. Whenever we create a transaction by adding an Action we tell the callController to pass it down the CallKit Pipe. We also create the action with needed details for our call such as the callID and the phone number(also know as our handle). All of this information is extremely important for our **ProviderDelegate**, this is another class that we will create. We can illustrate how CallKit works this way. CXCallController is like a delivery man. The delivery man is walking down a hallway. When the delivery man gets to the start call door it will give that door the start call transaction. Let's look at the class that shows this in action.

```swift
final class ProviderDelegate: NSObject, CXProviderDelegate {
    
    internal let provider: CXProvider?
    internal let callKitManager: CallKitManager
    internal var incomingCall: FCSDKCall?
    internal var outgoingFCSDKCall: FCSDKCall?
    
    init(
        callKitManager: CallKitManager
    ) {
        self.callKitManager = callKitManager
        self.provider = CXProvider(configuration: type(of: self).providerConfiguration)
        self.provider?.setDelegate(self, queue: .global())
    }

func reportIncomingCall(fcsdkCall: FCSDKCall) {
    Task {
        do {
            try await provider?.reportNewIncomingCall(with: fcsdkCall.uuid, update: update)
            await self.callKitManager.addCall(call: fcsdkCall)
        } catch {
            print("There was an error in \(#function) - Error: \(error.localizedDescription)")
        }
    }
}

//Answer Call after we get notified that we have an incoming call in the push controller
func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    Task {
        do {
            try await self.fcsdkCallService.answerFCSDKCall()
        } catch {
            print("\(OurErrors.nilACBUC.rawValue)")
        }
        action.fulfill()
    }
}

//Start Call
func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
    print("start call action")
    Task {
        await self.fcsdkCallService.presentCommunicationSheet()
        var acbCall: ACBClientCall?
        do {
            self.outgoingFCSDKCall = self.fcsdkCallService.fcsdkCall
            guard let outgoingFCSDKCall = outgoingFCSDKCall else { return }
            guard let preview = outgoingFCSDKCall.previewView else { return }
            try await self.fcsdkCallService.initializeCall(previewView: preview)
            acbCall = try await self.fcsdkCallService.startFCSDKCall()
            outgoingFCSDKCall.call = acbCall

            provider.reportCall(with: outgoingFCSDKCall.uuid, updated: callUpdate)
            
        } catch {
            print("\(OurErrors.nilACBUC.rawValue)")
        }
        guard let oc = outgoingFCSDKCall else { return }
        await self.callKitManager.addCall(call: oc)
        action.fulfill()
    }
}


//End Call
func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    Task {
        await self.fcsdkCallService.endFCSDKCall()
        await callKitManager.removeAllCalls()
        action.fulfill()
    }
}
}

```

This is just a partial example of the flow. To see a working example please study the sample app.
### Review
1. We must create a call Object for our application to use.
2. Pass the call object we receive or create to CallKit.
3. Tell the CallKitManager to create a transaction request
4. Respond appropriately to the desired transaction

Thats it... Our basic CallKit flow for working CallKit into your FCSDK Apps.

## PushKit
**Please note the FCSDK Sample app does not incorporate PushKit into it's CallKit flow.**

PushKit is what we need to use in order to push notification to our app when our app is in the background. When your app is register for PushKit Notifications while your app is in the background or locked Apple Push Notifications(APN) will be sent via your server.

`You Must` 

**A.** register your app on your Apple Developer account

and

**B.** Configure your server to support Push Notifications 
