# ACBClientPhone

Please see <doc:VideoCalls> for an explanation of how to use ACBClientCall

## Overview

```swift
/// ``ACBClientPhone`` is an object that does all of the phone related work. You can expected inbound and outbound call flows to originate from this class.
/// It is important to note that ``ACBClientPhone`` is lazily initialize once per ``ACBUC`` registration.
@objc final public class ACBClientPhone : NSObject {

    /// If true, the preview view is mirrored when using a front-facing camera (see .setCamera()). Does not affect video sent to callee.
    @objc final public var mirrorFrontFacingCameraPreview: Bool

    /// An array of calls that are currently in progress.
    @objc final public var currentCalls: [FCSDKiOS.ACBClientCall] { get }

    /// The phone delegate.
    @objc weak final public var delegate: FCSDKiOS.ACBClientPhoneDelegate?

    /// Manages audio session
    @objc final public var audioDeviceManager: FCSDKiOS.ACBAudioDeviceManager { get }

    /// The preferred capture resolution. If no preferred resolution is specified, the best SD resolution that the device is capable of will be chosen.
    @objc final public var preferredCaptureResolution: FCSDKiOS.ACBVideoCapture

    /// The preferred capture frame rate. If no preferred frame rate is specified, the best frame rate that the device is capable of will be chosen.
    @objc final public var preferredCaptureFrameRate: Int

    /// This computed property is used to set the App's preview view for video calls using `ACBView`.
    @MainActor @objc final public var previewView: UIView?

    /// This computed property is used to set the App's remote view for video calls using `ACBView`.
    @MainActor @objc final public var remoteView: UIView?

    /// This method can be used to request permissions to use the microphone and camera.
    /// - Parameters:
    ///   - audio: A boolean to indicate whether or not to request audio permissions
    ///   - video: A boolean to indicate whether or not to request video permissions
    @objc final public class func requestMicrophoneAndCameraPermission(_ audio: Bool, video: Bool) async

    /// Sets the camera to be used based off the ``ACBClientCall``'s camera.
    /// - Parameter camera: Camera postion i.e (.front, .back)
    @available(*, deprecated, message: "Please use async version, Future versions of FCSDKiOS will remove this method.")
    @objc final public func setCamera(_ camera: AVCaptureDevice.Position)
    @objc final public func setCamera(_ camera: AVCaptureDevice.Position) async

    /// Used to capture recommended settings
    /// - Returns: The device Info's recommended capture settings
    @available(*, deprecated, message: "Please use async version, Future versions of FCSDKiOS will remove this method.")
    @objc final public func recommendedCaptureSettings() -> [FCSDKiOS.ACBVideoCaptureSetting]?
    @objc final public func recommendedCaptureSettings() -> [FCSDKiOS.ACBVideoCaptureSetting]? async
}

extension ACBClientPhone {

    /// This method is the entry point in creating Outgoing FCSDK Calls. Call this method to start an FCSDK Outbound call.
    /// - Parameters:
    ///   - remoteAddress: The address in string format you want to call
    ///   - audioDirection: The ``ACBMediaDirection`` for the audio on the call
    ///   - videoDirection: The ``ACBMediaDirection`` for the video on the call
    ///   - delegate: The ``ACBClientCallDelegate``
    /// - Returns: The ``ACBClientCall``
    @available(*, deprecated, message: "use createCall() async instead")
    @objc final public func createCall(toAddress remoteAddress: String, withAudio audioDirection: FCSDKiOS.ACBMediaDirection, video videoDirection: FCSDKiOS.ACBMediaDirection, delegate: FCSDKiOS.ACBClientCallDelegate?) -> FCSDKiOS.ACBClientCall?

    @objc final public func createCall(toAddress remoteAddress: String, withAudio audioDirection: FCSDKiOS.ACBMediaDirection, video videoDirection: FCSDKiOS.ACBMediaDirection, delegate: FCSDKiOS.ACBClientCallDelegate?) async -> FCSDKiOS.ACBClientCall?
}
```
