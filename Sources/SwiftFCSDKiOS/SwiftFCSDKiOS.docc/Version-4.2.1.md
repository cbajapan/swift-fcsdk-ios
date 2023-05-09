# Version 4.2.1

This article describes changes in version 4.2.1 of FCSDKiOS

## Overview

Version 4.2.1 has several bug fixes and performance improvements. Below is a list of bug fixes.

### CBA Swift FCSDK minimum iOS Version support
FCSDKiOS has a minimum version of iOS 13. However, we now allow you to consume our SDK when your projects have a minimum version of iOS 11. You must use the appropriate runtime and compile time checks when using the SDK. This is easily achieved with the following code:

*Run Time*
```swift
@available(iOS 13.0, *)
//Your Run Time Method
```

```swift
if #available(iOS 14.0, *) {
    //Your Run Time Code
}
```

*Compile Time*
```swift
#if canImport(_Concurrency)
// Your Compile Time Code
#endif
```

*Please take note that in some Xcode projects issues have occured if your application is running on iOS 11 and 12 where the project will crash on the initilization of the SDK. In this case you need to make sure the build setting entitled **Always Embed Swift Standard Libraries** is set to **Yes** .*

### Fixed *setDefaultAudio()* not working
When `setDefaultAudio()` was called, it did not properly use the set value when audio hardware routes changed. We now have fixed this issue.

### Status Media changed to media pending after agent answered
We fixed an issue involving the call state changing at a certain point in the call flow's stream of events when receiving an inbound call.

### Fixed an issue where *setCamera()* was not functioning properly
We fixed an issue where setting the camera always was toggling instead of the indicated camera position.


