# VirtualBackground

FCSDKiOS offers virtual background support. In order to use this feature, you will need to be able to provide a UIImage to FCSDKiOS. The SDK consumer is responsible for setting up any UI that stores and presents images for selection. If the Image is too large, FCSDK will size the image to an acceptable size, but in practice it is encouraged for the SDK consumer to handle this to prevent any undefined behavior. Typically you will want to take the resoltion into consideration that the image will be displayed onto.(i.e. the callees video screen)

## Overview

The Virtual Background feature has been robustly built natively for your performance. Below we describe how to set up Virtual Background. 

## Feed Background Image
In order to use the **Virtual Background** feature the **SDK** consumer is required to feed the **SDK** a UIImage that the **SDK** can use as the virtual background. It is **STRONGLY** encouraged for performance reasons to feed an image that is as small as possible. This will save your application from excessive memory and cpu usage. If you fail to feed the SDK a smaller **UIImage** we will automatically adjust the size to an acceptable limit. If you wish to blur the background instead of using an image you can select **.blur** from the **VirtualBackgroundMode** enum. You are still required to feed an image. Virtual Backgrounds can also be blurred. If you have set a virtual background and only want to blur your real background, you must first remove the virtual background using the method `removeBackgroundImage()`.

```swift
@available(iOS 15, *)
@objc final public func feedBackgroundImage(_ image: UIImage, mode: FCSDKiOS.VirtualBackgroundMode = .image) async
```

```swift
@available(iOS 15, *)
@objc final public func removeBackgroundImage() async
```

## Virtual Background Mode
When feeding your background image you can set what mode it should be. There are 2 modes `.image` or `.blur`  
```swift
@objc public enum VirtualBackgroundMode : Int, Sendable, Equatable, Hashable, RawRepresentable {
case blur
case image
}
```


## Available FCSDK Objects
<doc:ACBUCObject>

<doc:ACBUCDelegate>

<doc:ACBUCOptions>

<doc:ACBAudioDevice>

<doc:ACBAudioDeviceManager>

<doc:ACBClientAED>

<doc:ACBClientCall>

<doc:ACBClientCallDelegate>

<doc:ACBClientCallErrorCode>

<doc:ACBClientCallProvisionalResponse>

<doc:ACBClientCallStatus>

<doc:ACBClientPhone>

<doc:ACBMediaDirection>

<doc:ACBTopic>

<doc:ACBVideoCapture>

<doc:AedData>

<doc:TopicData>

<doc:Constants>
