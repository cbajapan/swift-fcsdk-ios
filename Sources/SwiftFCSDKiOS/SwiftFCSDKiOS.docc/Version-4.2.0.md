# Version 4.2.0

This article describes changes in version 4.2.0 of FCSDKiOS

## Overview
Version 4.2.0 reaches a new milestone in terms of Video Calls. We now support Picture in Picture and Virtual Background. The following Topics are the changes that we have made.

### Local Buffer View
This method is designed to create a metal rendered `UIView` for your local video during a video call, when needed. This method must be used if you desire to use our **Virtual Background** feature.
When a call is finished the **SDK** consumer is required to clean up the call by calling the `removeLocalBufferView` method. 
```swift
@available(iOS 15, *)
@MainActor @objc final public func localBufferView() async -> UIView?
```

```swift
@available(iOS 15, *)
@objc final public func removeLocalBufferView() async
```

### Remote Buffer View
This method is designed to create a metal rendered `UIView` for your remote video during a video call, when needed. This method must be used if you desire to use our **Picture in Picture** feature.
When a call is finished the **SDK** consumer is required to clean up the call by calling the `removeBufferView` method. 
```swift
@available(iOS 15, *)
@MainActor @objc final public func remoteBufferView() async -> UIView?
```

```swift
@available(iOS 15, *)
@objc final public func removeBufferView() async
```

### AVCaptureSession
In order to check if your devices support Multitasking Camera Access, when a **LocalBufferView** is created we can get the **AVCaptureSession** from the **LocalBufferView**. If your device is supported by Apple, you can use the new **AVPictureInPictureVideoCallViewController** provided by Apple. Otherwise you will need to continue using **AVPictureInPictureController** and request permission from Apple for the proper entitlement. This method only works if you are using **LocalBufferView** for your Local Video UIView.
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
Each **ACBClientCall** object has a `setPipController` method that is required for Picture in Picture. This method informs the **SDK** who the **AVPictureInPictureController** is and allows us to receive its delegate methods. This is required for us to handle the **RemoteBufferView** accordingly when tha app activates Picture in Picture.
```swift
@available(iOS 15, *)
@MainActor @objc final public func setPipController(_ controller: AVPictureInPictureController) async
```

### Feeding a Background Image
In order to use the **Virtual Background** feature the **SDK** consumer is required to feed the **SDK** a UIImage that the **SDK** can use as the virtual background. It is **STRONGLY** encouraged for performance reasons to feed an image that is as small as possible. The SDK consumer is responsible for setting up any UI that stores and presents images for selection. Typically you will want to take the resolution into consideration that the image will be displayed onto.(i.e. the callees video screen). If the consumer does not handle feeding FCSDKiOS an appropriate image size then **FCSDKiOS** will automatically resize the background image to an acceptable size of *CGSize(width: 1280, height: 720)*. If you wish to blur the background instead of using an image you can select **.blur** from the **VirtualBackgroundMode** enum without including a **UIImage** in the image property parameter.

```swift
@available(iOS 15, *)
@objc final public func feedBackgroundImage(_ image: UIImage? = nil, mode: FCSDKiOS.VirtualBackgroundMode = .image) async
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
