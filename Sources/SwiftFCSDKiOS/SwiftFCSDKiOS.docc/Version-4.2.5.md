# Version 4.2.5

This article describes changes in version 4.2.5 of FCSDKiOS

## Overview

Version 4.2.5 has several bug fixes and performance improvements. Below is a list of bug fixes.

### We fixed an issue where setting the ACBClientCallDelegate may not have been set.

### Ensuring that when a new view is fed to the SDK's remote and local views they are created properly.

### Fixed an issue where iOS 13 users may not have been connecting to the socket.

### Fixed an issue where initial `localBufferView`s may have been flickering.

### The `localBufferView` will now appear when the call state transitions to `.inCall`.

### Fixed an issue where applications may have crashed after a duration of 10 minutes. 

### Introduced and Deprecated methods that should be called from an Async Context in order to protect synchronization of state.

## Below is a list of methods where the synchronous methods were deprecated and we request you to use the listed async versions below

```swift
await call.enableLocalVideo(false)
await call.enableLocalAudio(false)
await call.hold()
await call.resume()
await call.end()
await acbuc.phone.setCamera(.front)
_ = await acbuc.phone.recommendedCaptureSettings()
```

```objective-c
[_call enableLocalVideo:videoState completionHandler:^{}];
[_call enableLocalAudio:audioState completionHandler:^{}];
[_call holdWithCompletionHandler:^{}];
[_call resumeWithCompletionHandler:^{}];
[_call endWithCompletionHandler:^{}];
[self.uc.phone setCamera: self.currentCamera completionHandler:^{}];
[self->uc.phone recommendedCaptureSettingsWithCompletionHandler:^(NSArray<ACBVideoCaptureSetting*>* recCaptureSettings) {}];
```

## We also added some additional parameters for video scaling on our buffer views. Please note the following behaviors.

**VideoScaleMode**

*`.horizontal`*

The horizontal scale mode is designed to scale the content with its aspect ratio to the widest point. This means if your view is too short in relationship with the aspect ratio, then it will clip the height of the content. If the view is too tall, then you will see black space on the top and bottom of the view's content. 

*`.vertical`*

The vertical scale mode is designed to scale the content with its aspect ratio to the tallest point. This means if your view is too narrow in relationship with the aspect ratio, then it will clip the width of the content. If the view is too wide, then you will see black space on the left and right of the view's content. 

*`.fill`*

The fill scale mode is designed to scale the content to fill the view's container with its aspect ratio. This means the view will clip both height and width of the content in order to fill the view. 

*`.none`*

The none scale mode feeds the raw data into the view without any scaling.

**`shouldScaleWithOrientation`**

This boolean property is intended for use when the scale mode is set to *.vertical* or *.horizontal*. For instance you may want to start out a call in `.vertical` mode for both `localBufferView` and `remoteBufferView`, however when a device rotates, you may then want to scale to the opposite longest point *i.e.* `.horizontal` mode. Setting this parameter to true will give you this behavior.

**Here are what these properties look like in use**

```swift
remoteBufferView(
    scaleMode: .horizontal,
    shouldScaleWithOrientation: false
)

localBufferView(
    scaleMode: .horizontal,
    shouldScaleWithOrientation: false
)

```

These APIs provide you with a truly customizable approach in your applications. 
