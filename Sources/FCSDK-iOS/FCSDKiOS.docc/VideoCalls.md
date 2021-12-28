# Video Calls

In the complex world of Video Calls our goal is to make it as simple as possible. So in this article we will not give you an example of how to build an app, but we will show you the building blocks of how to generate Video Calls.

## Video Call Flow
* Setup UI
* Set Video Quality
* Give Audio/Video Permissions
* Make Call
* Answer Call

## ACBClientCall

ACBClientCall is the Call Object for Video/Audio Calls. 

### RemoteView
We need to make sure our UI is setup properly for our Video to stream. ACBClientPhone has a property that we need to set called remoteView that is used for remote video.

```swift
// RemoteView Property
var remoteView: SampleBufferVideoCallView

// We can then set the ACBClientCall Object's remoteView's remoteView to our remoteView
self.acbCall?.remoteView = self.remoteView
```
#### Note: SampleBufferVideoCallView subclasses ACBView which inturn is a UIView. This is provided in the SDK for you to use in rendering your view.

## ACBClientPhone

ACBClientPhone is the Communication Object For Video/Audio Calls.

### PreviewView
We need to make sure our UI is setup properly for our Video to stream. ACBClientCall has a property that we need to set called previewView that is used for local video.

### Create a property called   
```swift
// Preview Property
var previewView: SamplePreviewVideoCallView

// We can then set the uc Object's phone previewView to our previewView
uc.phone.previewView = previewView
```
#### Note: SamplePreviewVideoCallView subclasses ACBView which inturn is a UIView. This is provided in the SDK for you to use in rendering your view.

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

With those calls briefy explained, we can now share the Call and Answer methods

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
func initializeCall(previewView: SamplePreviewVideoCallView) async throws {
    await MainActor.run {
        self.hasStartedConnecting = true
        self.connectingDate = Date()
    }
    guard let uc = self.fcsdkCall?.uc else { throw OurErrors.nilACBUC }
    uc.phone.delegate = self
    uc.phone.previewView = previewView
}

func startFCSDKCall() async throws -> ACBClientCall? {
    guard let uc = self.fcsdkCall?.uc else { throw OurErrors.nilACBUC }
    let outboundCall = uc.phone.createCall(
        toAddress: self.fcsdkCall?.handle,
        withAudio: AppSettings.perferredAudioDirection(),
        video: AppSettings.perferredVideoDirection(),
        delegate: self
    )
    
    self.fcsdkCall?.call = outboundCall

    await MainActor.run {
        self.fcsdkCall?.call?.remoteView = self.fcsdkCall?.remoteView
        self.fcsdkCall?.call?.enableLocalAudio(true)
        self.fcsdkCall?.call?.enableLocalVideo(true)
    }
    return self.fcsdkCall?.call
}
```
## Making the call from CallKit
If you have followed our example app. You will notice that we are using callkit. This is not an indepth guide on CallKit, however you may call the above 2 methods in your callkit flow like so.
```swift
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
            let callUpdate = CXCallUpdate()
            callUpdate.supportsDTMF = true
            callUpdate.hasVideo = fcsdkCallService.hasVideo
            callUpdate.supportsHolding = true
            provider.reportCall(with: outgoingFCSDKCall.uuid, updated: callUpdate)
            
        } catch {
            print("\(OurErrors.nilACBUC.rawValue)")
        }
        
        await self.fcsdkCallService.hasStartedConnectingDidChange(provider: provider, id: outgoingFCSDKCall?.uuid ?? UUID(), date: self.fcsdkCallService.connectingDate ?? Date())
        await self.fcsdkCallService.hasConnectedDidChange(provider: provider, id: outgoingFCSDKCall?.uuid ?? UUID(), date:self.fcsdkCallService.connectDate ?? Date())
        
        guard let oc = outgoingFCSDKCall else { return }
        await self.callKitManager.addCall(call: oc)
        action.fulfill()
    }
}
```
There is a lot going on here, but what you can notice is that when CallKit recevies the notification to start a call we call 
```swift 
await initializeCall(previewView: preview)
```
And then
```swift
await startFCSDKCall()
```
Asynchronously. Go ahead a play around with the call flow to get your desired behavior using our sample app as a guide.

## Answer a Call

```swift
do {
    try self.acbCall?.answer(withAudio: AppSettings.perferredAudioDirection(), andVideo: AppSettings.perferredVideoDirection())
} catch {
    print(error)
}
```

Answering calls is triggered by a protocol that is called ACBClientPhoneDelegate that we need to conform to.

```swift
extension YourClass: ACBClientPhoneDelegate  {
    //Receive calls with ACBClientSDK
    func phoneDidReceive(_ phone: ACBClientPhone?, call: ACBClientCall?) {

    // We need to temporarily assign ourselves as the call's delegate so that we get notified if it ends before we answer it.
    call?.delegate = self

    //Set the remote view
    call.remoteView = self.remoteView

do {
    try self.acbCall?.answer(withAudio: AppSettings.perferredAudioDirection(), andVideo: AppSettings.perferredVideoDirection())
} catch {
    print(error)
}
}
    
    func phone(_ phone: ACBClientPhone?, didChange settings: ACBVideoCaptureSetting?, forCamera camera: AVCaptureDevice.Position) {
    }
}

```

Wherever we use ACBCClientPhoneDelegate we will need to set the delegate to that class. So in this case we could call the delegate in YourClass.

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
        case .setup:
        //Call is in process of being set up
            break
        case .alerting:
        //The call is an incoming one which is alerting 
            break
        case .ringing:
        //An outgoing call is ringing at the remote end
            break
        case .mediaPending:
        //The call is connected, and waiting for media
            break
        case .inCall:
        //The call is fully set up, including media
            break
        case .timedOut:
        //Dialing operation timed out without a response from the dialed number 
            break
        case .busy:
        //Dialed number is busy
            break
        case .notFound:
        //Dialed number is unreachable or does not exist
            break
        case .error:
        //An error has occurred on the call. such the media broker reaching its full capacity, the network terminating the request, or there being no media.
            break
        case .ended:
        //The call has ended
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
func phoneDidReceive(_ phone: ACBClientPhone?, call: ACBClientCall?) {
    Task {
        guard let uc = self.acbuc else { return }
        
        // We need to temporarily assign ourselves as the call's delegate so that we get notified if it ends before we answer it.
        call?.delegate = self
        
        if UserDefaults.standard.bool(forKey: "AutoAnswer") {
            
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
            await self.presentCommunicationSheet()
            
            
        } else {
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
}
```
As you can see here we have an if check that determines if we have auto answer on. We also set some variables for our app to pass up to SwiftUI in order to do some behavior in our UI. As you remember Our sample app uses CallKit and our last line of code is telling the AppDelegate to do something with CallKit. Let's see exactly what that is.

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

    try? await MainActor.run {
        self.hasConnected = true
        self.connectDate = Date()
        self.fcsdkCall?.call?.remoteView = self.fcsdkCall?.remoteView
        guard let view = self.fcsdkCall?.previewView else { throw OurErrors.nilPreviewView }
        guard let uc = self.acbuc else { throw OurErrors.nilACBUC }
        uc.phone.previewView = view
    }
    
    do {
        try self.fcsdkCall?.call?.answer(withAudio: AppSettings.perferredAudioDirection(), andVideo: AppSettings.perferredVideoDirection())
    } catch {
        print("There was an error answering call Error: \(error)")
    }
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
    2. We can choose the Video Quality we want for out application
    3. We must give our app permissions to use the Camera and Microphone
    4. We need to set up a service object that we can make our calls from. This can be done in a view controller, but for archectural purposes it is a good idea to do this in it's own object. We want to make sure we conform to the call object's delegate, set our views, and then we can make our call on the `uc` object as shown bellow.
    5. In our Call Service object we can also conform to ACBClientPhoneDelegate in order to receive calls. Once you have conformed to the protcol you can create a call object and answer the call as shown bellow.
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
//Answer a Call
func phoneDidReceive(_ phone: ACBClientPhone?, call: ACBClientCall?) {
let fcsdkCall = FCSDKCall(
    handle: call?.remoteAddress ?? "",
    hasVideo: self.fcsdkCall?.hasVideo ?? false,
    previewView: nil,
    remoteView: nil,
    uuid: UUID(),
    acbuc: uc,
    call: call!
)
    do {
        fcsdkCall.call?.answer(withAudio: AppSettings.perferredAudioDirection(),
        andVideo: AppSettings.perferredVideoDirection())
    } catch {
        print(error)
    }
}
```
#### Also it is to be noted that you will want to conform to *ACBClientCallDelegate* in order to receive call status updates as mentioned earlier.
