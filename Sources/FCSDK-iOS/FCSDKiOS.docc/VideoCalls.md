# Video Calls

In the complex world of Video Calls our goal is to make it as simple as possible. So in this article we will not give you an example of how to build an app, but we will show you the building blocks of how to generate Video Calls.

## Video Call Flow
* Setup UI
* Set Video Quality
* Give Audio/Video Permissions
* Make Call

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

// We can then set the acbuc Object's clientPhone previewView to our previewView
try? self.acbuc.clientPhone.setPreviewView(self.previewView)
```
#### Note: SamplePreviewVideoCallView subclasses ACBView which inturn is a UIView. This is provided in the SDK for you to use in rendering your view.

## Audio/Video

ACBClientPhone also has properties on it that we can use to set resolution and framerate. For Instance after we set our previewView we can specify those needed properties.

```swift
acbuc.clientPhone.preferredCaptureResolution = .autoResolution
acbuc.clientPhone.preferredCaptureFrameRate = 30
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
let outboundCall = acbuc.clientPhone.createCall(
    toAddress: "1002",
    withAudio: AppSettings.perferredAudioDirection(),
    video: AppSettings.perferredVideoDirection(),
    delegate: self
)
```
A complete outgoing call block could look something like this
```swift
func initializeCall(previewView: ACBView) async throws {
    acbuc.clientPhone.delegate = self
    try? acbuc.clientPhone.setPreviewView(previewView)
    acbuc.clientPhone.preferredCaptureResolution = .autoResolution
    acbuc.clientPhone.preferredCaptureFrameRate = 30

    guard let uc = self.fcsdkCall?.acbuc else { throw OurErrors.nilACBUC }
    let outboundCall = uc.clientPhone.createCall(
        toAddress: "1002",
        withAudio: AppSettings.perferredAudioDirection(),
        video: AppSettings.perferredVideoDirection(),
        delegate: self
    )
    
    self.outboundCall.remoteView = self.remoteView
    self.outboundCall.enableLocalAudio(true)
    self.outboundCall.enableLocalVideo(true)
}
```
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

    self.playRingtone()

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

    var acbuc: ACBUC?

    init() {
        self.acbuc?.clientPhone.delegate = self
    }
}
```

We also have a protocol for ACBClientCall. The purpose of his delegate is to receive information about the call, like the call status and other information. Each time we recieve an update we can react to the state change appropriately. Here is what the protocol conformation looks like.

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


