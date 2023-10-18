# Migrating from the legacy SDK

This article is to guide you through the changes in FCSDKiOS 

## Overview

Starting in FCSDKiOS 4.0.0 we have migrated to a native Swift code base. We have modernized the SDK and have changed a few things. Whether you are using Swift or Objective-C we plan to make this as smooth of a transition as possible.

### Version Changes

<doc:Version-4.2.0>

<doc:Version-4.1.0>

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

**FCSDKiOS** is a Swift Concurrency based SDK. The SDK is built around the concept of **Tasks**, **Actors**, and other **Swift Concurrency** features. Whenever you are interacting with the UI in your application while interacting with the call flow, you will need to make sure you are running your code on the main thread. For example when we make a call using FCSDKiOS in the sample app, we are interacting with our apps UI during the call flow, therefore we need to make those calls on the main thread. You can run code on the main thread like so. 

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
- We also have async versions of methods you may decided to use. If you choose to await on a method your call to that method must be wrapped in a **Task** or the call must be **async**. If you write an async method any FCSDK calls you use will automatically detect that they should use the async version of that call. If you want to side step this logic simply use a Task to wrap the async call instead of writing an async method. For example...

```swift
    func someMethod() async {
// Valid
    await uc.startSession()

// Invalid, Swift Concurreny will force the await version
    startSession()
}
```

or

```swift
    func someMethod() {
// Valid
Task {
        await startSession()
}
// Valid
        startSession()
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

#### Changes in FCSDKiOS while using Swift as a client

```swift
// FCSDKiOS 4.0.0 API
    self.acbuc = ACBUC.uc(withConfiguration: "", delegate: self)
// Legacy API
    self.acbuc = ACBUC.init(configuration: "", delegate: self)

// FCSDKiOS 4.0.0 API
    func topic(_ topic: ACBTopic, didUpdateWithKey key: String, value: String, version: Int, deleted: Bool) {}
// Legacy API
    func topic(_ topic: ACBTopic, didUpdateWithKey key: String, value: String, version: Int32, deleted: Bool) {}

// FCSDKiOS 4.0.0 API
    func topic(_ topic: ACBTopic, didSubmitWithKey key: String, value: String, version: Int) {}
// Legacy API
    func topic(_ topic: ACBTopic, didSubmitWithKey key: String, value: String, version: Int32) {}

// FCSDKiOS 4.0.0 API
    func topic(_ topic: ACBTopic, didConnectWithData data: AedData) {}
// Legacy API
    func topic(_ topic: ACBTopic, didConnectWithData data: [AnyHashable : Any])

// FCSDKiOS 4.0.0 API
    func call(_ call: ACBClientCall, didReportInboundQualityChange inboundQuality: Int) {}
// Legacy API
    func call(_ call: ACBClientCall, didReportInboundQualityChange inboundQuality: UInt) {}

// FCSDKiOS 4.0.0 API
    func call(_ call: ACBClientCall?, didReceiveCallRecordingPermissionFailure message: String)
// Legacy API
    func call(_ call: ACBClientCall, didReceiveCallRecordingPermissionFailure message: String)

// FCSDKiOS 4.0.0 API
    func uc(_ uc: ACBUC, willRetryConnectionNumber attemptNumber: Int, in delay: TimeInterval) {}
// Legacy API
    func uc(_ uc: ACBUC, willRetryConnectionNumber attemptNumber: UInt, in delay: TimeInterval) {}
```

#### Changes in FCSDKiOS while using Objective-C as a client

```objective-c
// FCSDKiOS 4.0.0 API
- (void)phone:(ACBClientPhone * _Nonnull)phone didReceive:(ACBClientCall * _Nonnull)call {}
// Legacy API
- (void) phone:(ACBClientPhone*)phone didReceiveCall:(ACBClientCall*)call {}

// FCSDKiOS 4.0.0 API
- (void)call:(ACBClientCall * _Nonnull)call didChange:(enum ACBClientCallStatus)status {}
// Legacy API
- (void) call:(ACBClientCall*)call didChangeStatus:(ACBClientCallStatus)status {}

// FCSDKiOS 4.0.0 API
- (void )call:(ACBClientCall *)call didReportInboundQualityChange:(NSInteger)inboundQuality {}
// Legacy API
- (void) call:call didReportInboundQualityChange:(NSUInteger)inboundQuality {}

// FCSDKiOS 4.0.0 API
- (void)topic:(ACBTopic *)topic didUpdateWithKey:(NSString *)key value:(NSString *)value version:(NSInteger)version deleted:(BOOL)deleted {}
// Legacy API
- (void)topic:(ACBTopic *)topic didUpdateWithKey:(NSString *)key value:(NSString *)value version:(int)version deleted:(BOOL)deleted {

// FCSDKiOS 4.0.0 API
- (void)topic:(ACBTopic *)topic didSubmitWithKey:(NSString *)key value:(NSString *)value version:(NSInteger)version {}
// Legacy API
- (void)topic:(ACBTopic *)topic didSubmitWithKey:(NSString *)key value:(NSString *)value version:(int)version {

// FCSDKiOS 4.0.0 API
- (void)topic:(ACBTopic *)topic didConnectWithData:(AedData *)data {}
// Legacy API
- (void)topic:(ACBTopic *)topic didConnectWithData:(NSDictionary *)data {}

// FCSDKiOS 4.0.0 API
- (void )call:(ACBClientCall *)call didReportInboundQualityChange:(NSInteger)inboundQuality {}
// Legacy API
- (void) call:call didReportInboundQualityChange:(NSUInteger)inboundQuality {}

// FCSDKiOS 4.0.0 API
    [disconnectedTopic disconnect:deleteTopic];
// Legacy API
    [disconnectedTopic disconnectWithDeleteFlag:deleteTopic];

// Deprecated in Legacy API
    [ACBClientPhone requestMicrophoneAndCameraPermission: requestMic video: requestCam];
// Use New Async API
    [ACBClientPhone requestMicrophoneAndCameraPermission:requestMic video:requestCam completionHandler:^{}];
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
```objective-c
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
```objective-c
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
```objective-c
TopicData *topicData = [[TopicData alloc] initWithKey:@"Key" value:@"Value"];
NSMutableArray *dataArray = [[NSMutableArray alloc] init];
[dataArray addObject:topicData];
AedData *data = [[AedData alloc] initWithType:@"Some Type" name:@"Some Name" topicData:dataArray message:@"Some Message" _timeout:0];
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
