# Version 4.1.0

This article descibes changes in version 4.1.0 of FCSDKiOS

## Overview

Version 4.1.0 reaches a new milestone in getting closer to full usage of Swift Concurrency in order to ensure High Level Data race prevention. If there is an available async method we are asking you to please use them for the best support of FCSDKiOS. Please notice the following new recommended changes.


**We now strongly encourage you to asynchronously create the ACBUC object.**

Swift
```swift
let uc = await ACBUC.uc(withConfiguration: sessionId, delegate: self)
```

Objective-C
```objective-c
[ACBUC ucWithConfiguration:sessionId delegate:self completionHandler:^(ACBUC * uc) {
// Set up uc object
}];
```

**The ACBUCDelegate, ACBClientCallDelegate and ACBClientPhoneDelegate now offer asynchronous versions of the provided methods. We encourage you to adopt them when you can.**

Swift
```swift 
//ACBUCDelegate
@objc optional func didStartSession(_ uc: FCSDKiOS.ACBUC) async
@objc optional func didFail(toStartSession uc: FCSDKiOS.ACBUC) async
@objc optional func didReceiveSystemFailure(_ uc: FCSDKiOS.ACBUC) async
@objc optional func didLoseConnection(_ uc: FCSDKiOS.ACBUC) async
@objc optional func uc(_ uc: FCSDKiOS.ACBUC, willRetryConnection attemptNumber: Int, in delay: TimeInterval) async
@objc optional func didReestablishConnection(_ uc: FCSDKiOS.ACBUC) async

//ACBClientCallDelegate
@objc optional func didReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall) async
@objc optional func didChange(_ status: FCSDKiOS.ACBClientCallStatus, call: FCSDKiOS.ACBClientCall) async
@objc optional func didReceiveCallFailure(with error: Error, call: FCSDKiOS.ACBClientCall) async
@objc optional func didReceiveDialFailure(with error: Error, call: FCSDKiOS.ACBClientCall) async
@objc optional func didReceiveSessionInterruption(_ message: String, call: FCSDKiOS.ACBClientCall) async
@objc optional func didReceiveCallRecordingPermissionFailure(_ message: String, call: FCSDKiOS.ACBClientCall?) async
@objc optional func didChangeRemoteDisplayName(_ name: String, with call: FCSDKiOS.ACBClientCall) async
@objc optional func didAddLocalMediaStream(_ call: FCSDKiOS.ACBClientCall) async
@objc optional func didAddRemoteMediaStream(_ call: FCSDKiOS.ACBClientCall) async
@objc optional func willReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall) async
@objc optional func didReportInboundQualityChange(_ inboundQuality: Int, with call: FCSDKiOS.ACBClientCall) async
@objc optional func didReceiveSSRCs(for audioSSRCs: [String], andVideo videoSSRCs: [String], call: FCSDKiOS.ACBClientCall) async
@objc optional func responseStatus(didReceive responseStatus: FCSDKiOS.ACBClientCallProvisionalResponse, withReason reason: String, call: FCSDKiOS.ACBClientCall) async

//ACBClientPhoneDelegate
@objc optional func phone(_ phone: FCSDKiOS.ACBClientPhone, received call: FCSDKiOS.ACBClientCall) async throws
@objc optional func phone(_ phone: FCSDKiOS.ACBClientPhone, didChangeSettings settings: FCSDKiOS.ACBVideoCaptureSetting, for camera: AVCaptureDevice.Position) async throws
```

Objective-C
```objective-c
//ACBUCDelegate
- (void)didStartSession:(ACBUC * _Nonnull)uc completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didFailToStartSession:(ACBUC * _Nonnull)uc completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReceiveSystemFailure:(ACBUC * _Nonnull)uc completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didLoseConnection:(ACBUC * _Nonnull)uc completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)uc:(ACBUC * _Nonnull)uc willRetryConnection:(NSInteger)attemptNumber in:(NSTimeInterval)delay completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReestablishConnection:(ACBUC * _Nonnull)uc completionHandler:(void (^ _Nonnull)(void))completionHandler;

//ACBClientCallDelegate
- (void)didReceiveMediaChangeRequest:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didChange:(enum ACBClientCallStatus)status call:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReceiveCallFailureWith:(NSError * _Nonnull)error call:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReceiveDialFailureWith:(NSError * _Nonnull)error call:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReceiveSessionInterruption:(NSString * _Nonnull)message call:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReceiveCallRecordingPermissionFailure:(NSString * _Nonnull)message call:(ACBClientCall * _Nullable)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didChangeRemoteDisplayName:(NSString * _Nonnull)name with:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didAddLocalMediaStream:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didAddRemoteMediaStream:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)willReceiveMediaChangeRequest:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReportInboundQualityChange:(NSInteger)inboundQuality with:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)didReceiveSSRCsFor:(NSArray<NSString *> * _Nonnull)audioSSRCs andVideo:(NSArray<NSString *> * _Nonnull)videoSSRCs call:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;
- (void)responseStatusWithDidReceive:(enum ACBClientCallProvisionalResponse)responseStatus withReason:(NSString * _Nonnull)reason call:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(void))completionHandler;

//ACBClientPhoneDelegate
- (void)phone:(ACBClientPhone * _Nonnull)phone received:(ACBClientCall * _Nonnull)call completionHandler:(void (^ _Nonnull)(NSError * _Nullable))completionHandler;
- (void)phone:(ACBClientPhone * _Nonnull)phone didChangeSettings:(ACBVideoCaptureSetting * _Nonnull)settings for:(enum AVCaptureDevicePosition)camera completionHandler:(void (^ _Nonnull)(NSError * _Nullable))completionHandler;
```

**For users that use CallKit as a way of answering or making calls a user may have experience Audio Session activation issues. We now have provided a method to ensure session activation**

When you receive a call you will want to set up manual audio for CallKit, then inside of your call provider Delegate you will want to call the 2 ACBAudioDevideManager class methods to active the call audio session for CallKit.

Swift
```swift
//ACBClientPhoneDelegate Method
ACBAudioDeviceManager.useManualAudioForCallKit()
ACBAudioDeviceManager.activeCallKitAudioSession(audioSession)
ACBAudioDeviceManager.deactiveCallKitAudioSession(audioSession)
```

Objective-C
```objective-c
[ACBAudioDeviceManager useManualAudioForCallKit];
[ACBAudioDeviceManager activeCallKitAudioSession:audioSession];
[ACBAudioDeviceManager deactiveCallKitAudioSession:audioSession];
```

**The 2 properties on the ACBClientCall object _remoteDisplayName_ and _remoteAddress_ are no longer optional**

Swift
```swift
@objc final public var remoteAddress: String { get }
@MainActor @objc final public var remoteDisplayName: String { get }
```

Objective-C
```objective-c
@property (nonatomic, readonly, copy) NSString * _Nonnull remoteAddress;
@property (nonatomic, readonly, copy) NSString * _Nonnull remoteDisplayName;
```
