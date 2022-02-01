# Migrating from the legacy SDK

This article is to guide you through the changes in FCSDKiOS 

## Overview

Starting in FCSDKiOS 4.0.0 we have migrated to a native Swift code base. We have modernized the SDK and have changed a few things. Whether you are using Swift or Objective-C we plan to make this as smooth of a transition as possible.

### Imports

- The SDK is called FCSDKiOS, previously you would import ACBClientSDK from FCSDKiOS. We have aligned the SDK name with the module you import. So, now rather than importing ACBClientSDK into your project you simply import FCSDKiOS. The examples are shown bellow.

Swift
```swift
import FCSDKiOS
````
Objective-C
```swift
@import FCSDKiOS
```

### Threading

- We have created a new threading model built from tools by Apple. This threading model makes the best use of the voice and video concurrency flow. With that being said, whenever you are interacting with the UI in your application while interacting with the call flow, you will need to make sure you are running your code on the main thread. For example when we make a call using FCSDKiOS in the sample app, we are interacting with our apps UI during the call flow, therefore we need to make those calls on the main thread. You can run code on the main thread like so.
Async/Await
```swift
func startCall() async throws {
// Run on the main thread
    await MainActor.run {
        self.hasStartedConnecting = true
    }
}
```
DispatchQueue
```swift
func startCall() throws {
// Run on the main thread
    DispatchQueue.main.async {
        self.hasStartedConnecting = true
    }
}
```
Objective-C DispatchQueue
```swift
- (void) startCall {
    dispatch_async(dispatch_get_main_queue(), ^{
     [self.hasStartedConnecting = true];
});
}
```

### Method changes

- The following list is a list of methods that have changes and should be noted in your application.
* `end()`

We have created an optional parameter in the **end()** method for ending **ACBClientCall**s. This method is on the **ACBClientCall** object. The method looks like this in swift.
```swift 
@objc public func end(_ call: ACBClientCall? = nil) {
}
```
We now have more flexibilty in ending our call, we can specify the call and if we decide to pass nothing into the parameter then it will end the current call object. This proves to be usefull if our array of ACBClientCalls exceeds the currentCall. In theory this should never happen so we are asking you to conform to this method as in the example bellow.

Swift
```swift
call?.end()
```
Objective-C
```swift
[self.call end:nil];
```
### Property Name Changes

- The following list is a list of properties that have changes and should be noted in your application.

* videoView

VideoView is now called remoteView. Changes can be made like so

Swift
```swift 
self.currentCall?.call?.remoteView = self.currentCall?.remoteView
```
Objective-C
```swift
self.call.remoteView = self.remoteVideoView;
```
As you can see the changes are identical in both Swift and Objective-C

* sdk version

We now are using a Constants file to store constant things

Swift
```swift 
Constants.SDK_VERSION_NUMBER
```
Objective-C
```swift
Constants.SDK_VERSION_NUMBER;
```
### 
