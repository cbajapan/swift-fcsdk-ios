# VirtualBackground

FCSDKiOS offers virtual background support. This feature offers an option to blur your camera capture's background or simply provide a virtual background image.

## Overview

The Virtual Background feature has been robustly built natively for your performance. Below we describe how to set up Virtual Background. 

## Feeding a Background Image
In order to use the **Virtual Background** feature the **SDK** consumer is required to feed the **SDK** a UIImage that the **SDK** can use as the virtual background. It is **STRONGLY** encouraged for performance reasons to feed an image that is as small as possible. The SDK consumer is responsible for setting up any UI that stores and presents images for selection. Typically you will want to take the resolution into consideration that the image will be displayed onto.(i.e. the callees video screen). If the consumer does not handle feeding FCSDKiOS an appropriate image size then **FCSDKiOS** will automatically resize the background image to an acceptable size of *CGSize(width: 1280, height: 720)*. If you wish to blur the background instead of using an image you can select **.blur** from the **VirtualBackgroundMode** enum without including a **UIImage** in the image property parameter.

```swift
@available(iOS 15, *)
@objc final public func feedBackgroundImage(_ image: UIImage? = nil, mode: FCSDKiOS.VirtualBackgroundMode = .image) async
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
