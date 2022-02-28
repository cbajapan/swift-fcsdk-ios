# Migrating from the legacy SDK

This article is to guide you through the changes in FCSDKiOS 

## Overview

Starting in FCSDKiOS 4.0.0 we have migrated to a native Swift code base. We have modernized the SDK and have changed a few things. Whether you are using Swift or Objective-C we plan to make this as smooth of a transition as possible.

### Imports

- The SDK is called FCSDKiOS, previously you would import ACBClientSDK from FCSDKiOS. We have aligned the SDK name with the module you import. So, now rather than importing ACBClientSDK into your project you simply import FCSDKiOS. The examples are shown below.

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
     [self.hasStartedConnecting = YES];
});
}
```

### Method changes

- The following list is a list of methods that have changes and should be noted in your application.
 ACBTopicDelegate protocol has 3 methods where the version parameter in the following methods have change from an Objective-C **int** to a Swift **Int** which maps to **NSInteger**
* didSubmitWithKey
* didDeleteDataSuccessfullyWithKey
* didUpdateWithKey
* didChangeStatus
* didReportInboundQualityChange

Bellow are examples of the change in API in Objective-C. Swift users will continues to use an **Int** value.

```swift
- (void)topic:(ACBTopic *)topic didUpdateWithKey:(NSString *)key value:(NSString *)value version:(NSInteger)version deleted:(BOOL)deleted
```
```swift
- (void)topic:(ACBTopic *)topic didDeleteDataSuccessfullyWithKey:(NSString *)key version:(NSInteger)version
```
```swift
- (void)topic:(ACBTopic *)topic didSubmitWithKey:(NSString *)key value:(NSString *)value version:(NSInteger)version
````
```swift
- (void) call:(ACBClientCall*)call didChangeStatus:(ACBClientCallStatus)status
```
```swift
- (void) call:call didReportInboundQualityChange:(NSInteger)inboundQuality
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

We now are using a Constants file to store constant things.

Swift
```swift 
Constants.SDK_VERSION_NUMBER
```
Objective-C
```swift
Constants.SDK_VERSION_NUMBER;
```

### AED

- With FCSDKiOS we are moving away from using NSDictionary. FCSDKiOS uses a class conforming to NSObject as a model layer rather than using Dictionaries. That being said we have created an Object for you to use called **AedData** and it's child object called **TopicData**. This approach simplifies your model layer and makes AED easier to work with. This will primarily be noticeable when conforming to the Delegate. The method **didConnectWithData** will now give you this object to work with once you have connected with the intended data.

- You typically will not need to be concerned about constructing this object, but it may be used to store AED Model related things if you desire.

* An **AedData Object** can be created like so..

Swift

```swift
var arrayData = [TopicData]()
let topicData = TopicData(key: "Some Key", value: "Some Value")
arrayData.append(topicData)
let aed = AedData(
    type: "Some Type",
    name: "Some Name",
    topicData: arrayData,
    message: "Some Message",
    timeout: 0)
```
Objective-C
```swift
TopicData *topicData = [[TopicData alloc] initWithKey:@"Key" value:@"Value"];
NSMutableArray *dataArray = [[NSMutableArray alloc] init];
[dataArray addObject:topicData];
AedData *data = [[AedData alloc] initWithType:@"Some Type" name:@"Some Name" topicData:dataArray message:@"Some Message" _timeout:0];
```
