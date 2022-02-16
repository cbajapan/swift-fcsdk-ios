# Video Calls

In the complex world of Video Calls our goal is to make it as simple as possible. So in this article we will show you the building blocks of how to create video calls.

## Video Call Flow
* Setup UI
* Set Video Quality
* Give Audio/Video Permissions
* Make Call
* Answer Call

## ACBClientCall

ACBClientCall is the Call Object for Video/Audio Calls. 

### RemoteView
We need to make sure our UI is setup properly for our Video to stream. ACBClientCall has a property that we need to set called remoteView that is used for remote video.

```swift
// RemoteView Property
var remoteView: UIView

// We can then set the ACBClientCall Object's remoteView's remoteView to our remoteView
self.acbCall?.remoteView = self.remoteView
```

## ACBClientPhone

ACBClientPhone is the Communication Object For Video/Audio Calls.

### PreviewView
We need to make sure our UI is setup properly for our Video to stream. ACBClientPhone has a property that we need to set called previewView that is used for local video.

### Create a property called   
```swift
// Preview Property
var previewView: UIView

// We can then set the uc Object's phone previewView to our previewView
uc.phone.previewView = previewView
```

## Audio/Video

ACBClientPhone also has properties on it that we can use to set resolution and framerate. For Instance after we set our previewView we can specify those needed properties.

```swift
uc.phone.preferredCaptureResolution = .autoResolution
uc.phone.preferredCaptureFrameRate = 30
```
We also need to request Camera and Audio Permissions. We can easily do that using FCSDK's permissions method. AppSettings are defined by the consumer. There is an example of how to create this class in the Sample App.

```swift
func requestMicrophoneAndCameraPermissionFromAppSettings() {
    let requestMic = AppSettings.perferredAudioDirection() == .sendOnly || AppSettings.perferredAudioDirection() == .sendAndReceive
    let requestCam = AppSettings.perferredVideoDirection() == .sendOnly || AppSettings.perferredVideoDirection() == .sendAndReceive
//Static method
    ACBClientPhone.requestMicrophoneAndCameraPermission(requestMic, video: requestCam)
}
```

When Creating a call we also want to specify if we will enable Audio/Video. We have 2 methods available in order to specify these functionalities

```swift
self.acbCall?.enableLocalAudio(true)
self.acbCall?.enableLocalVideo(true)
```

With those calls briefly explained, we can now share the Call and Answer methods

## Make a Call

```swift
let outboundCall = uc.phone.createCall(
    toAddress: self.fcsdkCall?.handle,
    withAudio: AppSettings.perferredAudioDirection(),
    video: AppSettings.perferredVideoDirection(),
    delegate: self
)
```
A complete outgoing call block could look something like this
```swift
func startCall(previewView: UIView) async throws {
    await MainActor.run {
        self.hasStartedConnecting = true
        self.connectingDate = Date()
    }
guard let uc = self.fcsdkCall?.acbuc else { throw OurErrors.nilACBUC }
uc.phone.delegate = self
//We Pass the view up to the SDK
uc.phone.previewView = previewView
}

func initializeFCSDKCall() async throws -> ACBClientCall? {
    guard let uc = self.fcsdkCall?.acbuc else { throw OurErrors.nilACBUC }
    let outboundCall = uc.phone.createCall(
        toAddress: self.fcsdkCall?.handle ?? "",
        withAudio: AppSettings.perferredAudioDirection(),
        video: AppSettings.perferredVideoDirection(),
        delegate: self
    )
    
        self.fcsdkCall?.call = outboundCall
        self.fcsdkCall?.call?.enableLocalAudio(true)
        self.fcsdkCall?.call?.enableLocalVideo(true)

    await MainActor.run {
        self.fcsdkCall?.call?.remoteView = self.fcsdkCall?.remoteView
    }
    return self.fcsdkCall?.call
}
```
## Making the call from CallKit
If you have followed our example app. You will notice that we are using callkit. This is not an indepth guide on CallKit, however you may call the above 2 methods in your callkit flow like so.
```swift
//Start Call
func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
    self.logger.info("Start call action")
    Task {
        var acbCall: ACBClientCall?
        do {
            let callUpdate = CXCallUpdate()
            callUpdate.supportsDTMF = true
            callUpdate.hasVideo = fcsdkCallService.hasVideo
            callUpdate.supportsHolding = false
            
            guard let outgoingFCSDKCall = self.fcsdkCallService.fcsdkCall else { return }
            guard let preview = outgoingFCSDKCall.previewView else { return }
            await self.fcsdkCallService.startCall(previewView: preview)
            acbCall = try await self.fcsdkCallService.initializeFCSDKCall()
            outgoingFCSDKCall.call = acbCall
            
            provider.reportCall(with: outgoingFCSDKCall.id, updated: callUpdate)
            
            await self.fcsdkCallService.hasStartedConnectingDidChange(provider: provider,
                                                                      id: outgoingFCSDKCall.id,
                                                                      date: self.fcsdkCallService.connectingDate ?? Date())
            await self.fcsdkCallService.hasConnectedDidChange(provider: provider,
                                                              id: outgoingFCSDKCall.id,
                                                              date: self.fcsdkCallService.connectDate ?? Date())
            await self.fcsdkCallService.addCall(call: outgoingFCSDKCall)
            //We need to set the delegate initially because if the user is on another call we need to get notified through the delegate and end the call
            self.fcsdkCallService.fcsdkCall?.call?.delegate = self.fcsdkCallService
            action.fulfill()
        } catch {
            self.logger.error("\(error)")
            action.fail()
        }
    }
}
```
There is a lot going on here, but what you can notice is that when CallKit recevies the notification to start a call we call 
```swift 
await startCall(previewView: preview)
```
And then
```swift
await initializeFCSDKCall()
```
Asynchronously. Go ahead a play around with the call flow to get your desired behavior using our sample app as a guide.

## Answer a Call

```swift
    self.acbCall?.answer(withAudio: AppSettings.perferredAudioDirection(), andVideo: AppSettings.perferredVideoDirection())
```

Answering calls is triggered by a protocol that is called ACBClientPhoneDelegate that we need to conform to.

```swift
extension YourClass: ACBClientPhoneDelegate  {
    //Receive calls with ACBClientSDK
    func phone(_ phone: ACBClientPhone, didReceiveCall call: ACBClientCall) {

    // We need to temporarily assign ourselves as the call's delegate so that we get notified if it ends before we answer it.
    call?.delegate = self

    //Set the remote view
    call.remoteView = self.remoteView

    call.answer(withAudio: AppSettings.perferredAudioDirection(), andVideo: AppSettings.perferredVideoDirection())
}
    
    func phone(_ phone: ACBClientPhone?, didChange settings: ACBVideoCaptureSetting?, forCamera camera: AVCaptureDevice.Position) {
    }
}

```

Wherever we use ACBClientPhoneDelegate we will need to set the delegate to that class. So in this case we could call the delegate in YourClass.

```swift

class YourClass {

    var uc: uc?

    init() {
        self.uc?.phone.delegate = self
    }
}
```

We also have a protocol for ACBClientCall. The purpose of this delegate is to receive information about the call, like the call status and other information. Each time we recieve an update we can react to the state change appropriately. Here is what the protocol conformation looks like.

```swift
extension YourClass: ACBClientCallDelegate {
    
    func call(_ call: ACBClientCall?, didChange status: ACBClientCallStatus) {
        switch status {
        case .setup, alerting, ringing, mediaPending, inCall, timedOut, busy, notFound, error, ended:
        // Do Stuff
            break
        }
    }
    
    func call(_ call: ACBClientCall?, didReceiveSessionInterruption message: String?) {
        if message == "Session interrupted" {
          //Do stuff like onHold logic
        }
    }
    
    func call(_ call: ACBClientCall?, didReceiveCallFailureWithError error: Error?) {
         // Reflect in UI
    }
    
    func call(_ call: ACBClientCall?, didReceiveDialFailureWithError error: Error?) {
        // Reflect in UI
    }
    
    func call(_ call: ACBClientCall?, didReceiveCallRecordingPermissionFailure message: String?) {
        // Reflect in UI
    }
    
    func call(_ call: ACBClientCall?, didReceiveSSRCsForAudio audioSSRCs: [AnyHashable]?, andVideo videoSSRCs: [AnyHashable]?) {
        guard let audio = audioSSRCs else {return}
        guard let video = videoSSRCs else {return}
        print("Received SSRC information for AUDIO \(audio) and VIDEO \(video)")
    }
    
    func call(_ call: ACBClientCall?, didReportInboundQualityChange inboundQuality: Int) {
        // Reflect in UI
        print("Call Quality: \(inboundQuality)")
    }
    
    func callDidReceiveMediaChangeRequest(_ call: ACBClientCall?) {
    }
}
```

Now that you understand the basics of what needs to happen when answering a call we can show you what a real answer flow can look like.

```swift
//Receive calls with FCSDK
func phone(_ phone: ACBClientPhone, didReceiveCall call: ACBClientCall) {
    Task {
        guard let uc = self.acbuc else { return }
        
        // We need to temporarily assign ourselves as the call's delegate so that we get notified if it ends before we answer it.
        call?.delegate = self
            // we need to pass this to the call manager
            await MainActor.run {
                let receivedCall = FCSDKCall(
                    handle: call?.remoteAddress ?? "",
                    hasVideo: self.fcsdkCall?.hasVideo ?? false,
                    previewView: nil,
                    remoteView: nil,
                    uuid: UUID(),
                    acbuc: uc,
                    call: call!
                )
                
                self.fcsdkCall = receivedCall
                self.fcsdkCall?.call?.delegate = call?.delegate
            }
            guard let call = self.fcsdkCall else {return}
            await self.appDelegate?.displayIncomingCall(fcsdkCall: call)
    }
}
```
We set some variables for our app so that we can pass them up to SwiftUI in order to do some behavior in our UI. As you remember our sample app uses CallKit and our last line of code is telling the AppDelegate to do something with CallKit. Let's see exactly what that is.

Inside of AppDelegate we have this method
```swift
func displayIncomingCall(fcsdkCall: FCSDKCall) async {
    providerDelegate?.reportIncomingCall(fcsdkCall: fcsdkCall)
}
```

A very simple method that reaches out to the provider delegate and reports the Incoming call. When this happens CallKit will go to work giving us the native CallKit functionality that we all want and then answers the call when we press the answer button.

```swift
func reportIncomingCall(fcsdkCall: FCSDKCall) {
    Task {
        await callKitManager.removeAllCalls()
        
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: fcsdkCall.handle)
        update.hasVideo = fcsdkCall.hasVideo
        update.supportsDTMF = true
        update.supportsHolding = true
        
        do {
            try await provider?.reportNewIncomingCall(with: fcsdkCall.uuid, update: update)
            await self.fcsdkCallService.presentCommunicationSheet()
            await self.callKitManager.addCall(call: fcsdkCall)
        } catch {
            if error.localizedDescription == "The operation couldn’t be completed. (com.apple.CallKit.error.incomingcall error 3.)" {
                await MainActor.run {
                    self.fcsdkCallService.doNotDisturb = true
                }
            }
            print("There was an error in \(#function) - Error: \(error.localizedDescription)")
        }
    }
}
```
After the call has been reported we answer the call
```swift 
//Answer Call after we get notified that we have an incoming call in the push controller
func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    print("answer call action")
    Task {
        do {
            try await self.fcsdkCallService.answerFCSDKCall()
        } catch {
            print("\(OurErrors.nilACBUC.rawValue)")
        }
        action.fulfill()
    }
}
```
Which then in turn calls the answerFCSDKCall method and presents our call to us.
```swift 
func answerFCSDKCall() async throws {
    await MainActor.run {
        self.hasConnected = true
        self.connectDate = Date()
        self.presentCommunication = true
    }

    self.fcsdkCall?.call?.remoteView = self.fcsdkCall?.remoteView

    guard let view = self.fcsdkCall?.previewView else { throw OurErrors.nilPreviewView }
    guard let uc = self.acbuc else { throw OurErrors.nilACBUC }
    //We Pass the view up to the SDK
    uc.phone.previewView = view
    self.fcsdkCall?.call?.answer(withAudio: AppSettings.perferredAudioDirection(), andVideo: AppSettings.perferredVideoDirection())
}
```
So if your delegates are set properly, your preview and remote views are set properly, your call flow conforms to the behavior expected by FCSDK, and if you have conformed to ACBClientPhoneDelegate and ACBClientCallDelegate then you should have Voice and Video Calls that work great. But just to clarify let's review.

## Review
There are 5 steps to making Voice and Video work.
* Setup UI
* Set Video Quality
* Give Audio/Video Permissions
* Make Call
* Answer Call

    1. Whether using UIKit or Swift UI we need to make sure that we have our views properly anchored and made available to FCSDK. Please see the Article entitled <doc:FCSDKUI> for more information on that topic.
    2. We can choose the Video Quality we want for our application
    3. We must give our app permissions to use the Camera and Microphone
    4. We need to set up a service object that we can make our calls from. This can be done in a view controller, but for architectural purposes it is a good idea to do this in it's own object. We want to make sure we conform to the call object's delegate, set our views, and then we can make our call on the `uc` object as shown below.
    5. In our Call Service object we can also conform to ACBClientPhoneDelegate in order to receive calls. Once you have conformed to the protocol you can create a call object and answer the call as shown below.
```swift
//Make a call
        uc.phone.createCall(
            toAddress: self.fcsdkCall?.handle,
            withAudio: AppSettings.perferredAudioDirection(),
            video: AppSettings.perferredVideoDirection(),
            delegate: self
        )
```

```swift
// We can answer calls according to our needs starting from this method.
func phoneDidReceive(_ phone: ACBClientPhone?, call: ACBClientCall?) {
    Task {
        guard let uc = self.acbuc else { return }
        
        // We need to temporarily assign ourselves as the call's delegate so that we get notified if it ends before we answer it.
        call?.delegate = self
            // we need to pass this to the call manager
            await MainActor.run {
                let receivedCall = FCSDKCall(
                    handle: call?.remoteAddress ?? "",
                    hasVideo: self.fcsdkCall?.hasVideo ?? false,
                    previewView: nil,
                    remoteView: nil,
                    uuid: UUID(),
                    acbuc: uc,
                    call: call!
                )
                
                self.fcsdkCall = receivedCall
                self.fcsdkCall?.call?.delegate = call?.delegate
            }
            guard let call = self.fcsdkCall else {return}

// This call to our **displayIncomingCall** method sets in motion the answer call flow.
            await self.appDelegate?.displayIncomingCall(fcsdkCall: call)
    }
}
```
#### Also it is to be noted that you will want to conform to *ACBClientCallDelegate* in order to receive call status updates as mentioned earlier.
