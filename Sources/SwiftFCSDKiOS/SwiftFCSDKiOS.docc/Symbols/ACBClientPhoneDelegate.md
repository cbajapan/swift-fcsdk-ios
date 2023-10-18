# ACBClientPhoneDelegate

ACBClientPhoneDelegate is used to receive notifications on the ACBClientPhone Object. Incoming calls are generated on the phone object. For more implementation details please see <doc:VideoCalls>.

## Overview

```swift
    @objc public protocol ACBClientPhoneDelegate : NSObjectProtocol {

    /// A notification to indicate an incoming call.
    @objc optional func phone(_ phone: FCSDKiOS.ACBClientPhone, didReceive call: FCSDKiOS.ACBClientCall)

    @objc optional func phone(_ phone: FCSDKiOS.ACBClientPhone, received call: FCSDKiOS.ACBClientCall) async throws

    /// A notification that video is being captured at a specified resolution and frame-rate. Depending on the capabilities of the device, these settings may be different from the preferred resolution and frame rate set on the phone.
    @objc optional func phone(_ phone: FCSDKiOS.ACBClientPhone, didChangeSettings settings: FCSDKiOS.ACBVideoCaptureSetting, forCamera camera: AVCaptureDevice.Position)

    @objc optional func phone(_ phone: FCSDKiOS.ACBClientPhone, didChangeSettings settings: FCSDKiOS.ACBVideoCaptureSetting, for camera: AVCaptureDevice.Position) async throws
}
```
