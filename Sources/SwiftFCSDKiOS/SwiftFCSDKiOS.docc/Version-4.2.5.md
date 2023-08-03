# Version 4.2.5

This article describes changes in version 4.2.5 of FCSDKiOS

## Overview

Version 4.2.5 has several bug fixes and performance improvements. Below is a list of bug fixes.

### We fixed an issue where setting the ACBClientCallDelegate may not have been setting

### Ensursing that when a new view is fed to the SDK's remote and local views they are created properly.

### Fixed an issue where iOS 13 users may not have been connecting to the socket

### Introduced and Deprecated methods that should be called from an Async Context in order to protect synchronization of state.

## Below is a list of methods where synchronous versions of those methods were deprecated. We request you to use the listed async versions bellow

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
