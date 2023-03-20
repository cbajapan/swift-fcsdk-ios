# Version 4.2.0

This article describes changes in version 4.2.0 of FCSDKiOS

## Overview
Version 4.2.0 reaches a new milestone in terms of Video Calls. We now support Picture in Picture and Virtual Background. The following Topics are the changes that we have made.

### Preview Buffer View
This method is designed to create a metal rendered `UIView` for your local video during a video call. This method must be used if you desire to use our **Virtual Background** feature.
When a call is finished the **SDK** consumer is required to clean up the call by calling the `removePreviewView` method. 
```swift
@available(iOS 15, *)
@MainActor @objc final public func previewBufferView() async -> UIView?
```

```swift
@available(iOS 15, *)
@objc final public func removePreviewView() async
```

### Sample Buffer View
This method is designed to create a metal rendered `UIView` for your remote video during a video call. This method must be used if you desire to use our **Picture in Picture** feature.
When a call is finished the **SDK** consumer is required to clean up the call by calling the `removeBufferView` method. 
```swift
@available(iOS 15, *)
@MainActor @objc final public func sampleBufferView() async -> UIView?
```

```swift
@available(iOS 15, *)
@objc final public func removeSampleView() async
```

### AVCaptureSession
In order to check if your devices support Multitasking Camera Access, when a **PreviewBufferView** is created we can get the **AVCaptureSession** from the **PreviewBufferView**. If your devices are supported by Apple, you can use the new **AVPictureInPictureVideoCallViewController** provided by Apple. Otherwise you will need to continue using **AVPictureInPictureController** and request permission from Apple for the proper entitlement. This method only works if you are using **PreviewBufferView** for your Local Video UIView.
```swift
@available(iOS 15, *)
@objc final public func captureSession() async -> AVCaptureSession?
```

An example in checking for the method is as follows:
```swift
if captureSession.isMultitaskingCameraAccessSupported {
    // Use AVPictureInPictureVideoCallViewController
} else {
    // Use AVPictureInPictureController
}
```

### Set PiP Controller
Each **ACBClientCall** object has a `setPipController` method that is required for Picture in Picture. This method informs the **SDK** who the **AVPictureInPictureController** is and allows us to receive its delegate methods. This is required for us to handle the **SampleBufferView** accordingly when tha app activates Picture in Picture.
```swift
@available(iOS 15, *)
@MainActor @objc final public func setPipController(_ controller: AVPictureInPictureController) async
```

### Feed Background Image
In order to use the **Virtual Background** feature the **SDK** consumer is required to feed the **SDK** a UIImage that the **SDK** can use as the virtual background. It is **STRONGLY** encouraged for performance reasons to feed an image that is as small as possible. This will save your application from excessive memory and cpu usage. If you fail to feed the SDK a smaller **UIImage** we will automatically adjust the size to an acceptable limit. If you wish to blur the background instead of using an image, you can select **.blur** from the **VirtualBackgroundMode** enum. You are still required to feed an image. Virtual Backgrounds can also be blurred. If you have set a virtual background and only want to blur your real background, you must first remove the virtual background using the method `removeBackgroundImage()`. 

```swift
@available(iOS 15, *)
@objc final public func feedBackgroundImage(_ image: UIImage, mode: FCSDKiOS.VirtualBackgroundMode = .image) async
```

```swift
@available(iOS 15, *)
@objc final public func removeBackgroundImage() async
```

### Virtual Background Mode
When feeding your background image you can set what mode it should be. There are 2 modes `.image` or `.blur`  
```swift
@objc public enum VirtualBackgroundMode : Int, Sendable, Equatable, Hashable, RawRepresentable {
case blur
case image
}
```

### WebSocket Connection Timeout
We have opened up the ability to set the WebSocket connection timeout on the **Constants** object.
```swift
@objc public static var WEBSOCKET_CONNECTION_TIMEOUT: Float
```
