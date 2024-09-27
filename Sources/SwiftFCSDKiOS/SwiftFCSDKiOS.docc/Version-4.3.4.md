# Version 4.3.4

This article describes changes in version 4.3.4 of FCSDKiOS.

## Overview

Version 4.3.4 has the following changes:

### Introduction to Swift 6 and a Swift Concurrent Safe Environment

From the inception of FCSDKiOS 4.0.0, Swift Concurrency has been the backbone and theme of the build in order to provide its consumers with a high-quality, high-performance, data race-safe SDK. With the official release of Swift 6 and iOS 18, we have reached a milestone in achieving this. The challenge has been moving from the old way of doing things to the new way with minimal changes to the public-facing interface while maintaining Objective-C compatibility. 

With that being said, we have deprecated some APIs and are requiring SDK consumers to adopt the new APIs, while leaving the old deprecated APIs available for the time being. The following list of APIs includes the new deprecations.


```swift
// ACBClientCallDelegate Deprecated Methods
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func callDidReceiveMediaChangeRequest(_ call: ACBClientCall)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(_ call: ACBClientCall, didChange status: ACBClientCallStatus)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(_ call: ACBClientCall, didReceiveCallFailureWithError error: Error)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(_ call: ACBClientCall, didReceiveDialFailureWithError error: Error)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(_ call: ACBClientCall, didReceiveSessionInterruption message: String)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(_ call: ACBClientCall?, didReceiveCallRecordingPermissionFailure message: String)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(_ call: ACBClientCall, didChangeRemoteDisplayName name: String)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func callDidAddLocalMediaStream(_ call: ACBClientCall)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func callDidAddRemoteMediaStream(_ call: ACBClientCall)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func callWillReceiveMediaChangeRequest(_ call: ACBClientCall)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(_ call: ACBClientCall, didReportInboundQualityChange inboundQuality: Int)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(
    _ call: ACBClientCall,
    didReceiveSSRCsForAudio audioSSRCs: [String],
    andVideo videoSSRCs: [String]
)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func call(
    call: ACBClientCall,
    didReceive responseStatus: ACBClientCallProvisionalResponse,
    withReason reason: String
)

// ACBClientPhoneDelegate Deprecated Methods
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func phone(_ phone: ACBClientPhone, didReceive call: ACBClientCall)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func phone(_ phone: ACBClientPhone, didChangeSettings settings: ACBVideoCaptureSetting, forCamera camera: AVCaptureDevice.Position)

// ACBUCDelegate Deprecated Methods
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func ucDidStartSession(_ uc: ACBUC)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func ucDidFail(toStartSession uc: ACBUC)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func ucDidReceiveSystemFailure(_ uc: ACBUC)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func ucDidLoseConnection(_ uc: ACBUC)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func uc(_ uc: ACBUC, willRetryConnectionNumber attemptNumber: Int, in delay: TimeInterval)
@available(*, deprecated, message: "Please use async version of this protocol method. This synchronous version will be removed in future versions of FCSDKiOS")
@objc optional func ucDidReestablishConnection(_ uc: ACBUC)

// Constants Deprecated Properties
@available(*, deprecated, message: "Please set websocket connection timeout on the start session method parameter")
@objc static public var WEBSOCKET_CONNECTION_TIMEOUT: Float = 7.0

// ACBUC Deprecated Methods
@available(*, deprecated, message: "Please handle network loss at the application level as per our documentation")
@objc public func startSession(triggerReconnect onNetworkLoss: Bool = false, timeout: Float = 7.0) async {}
@available(*, deprecated, message: "Please handle network loss at the application level as per our documentation")
@objc public func startSession(triggerReconnect onNetworkLoss: Bool = false) async {}
@available(*, deprecated, message: "Please use start session with websocket timeout as a parameter")
@objc public func startSession() {}
@available(*, deprecated, message: "Please use async start session with websocket timeout as a parameter")
@objc public func startSession() async {}
```

You will now notice that when you adopt version 4.3.4, our delegate methods will require you to use the new async methods in Swift or completion handlers in Objective-C. Please use them; we cannot ensure quality operations with the deprecated methods.

**IMPORTANT**
- _If you need to break free from the async protocol method in our delegate methods, simply run your code in a new unstructured task in Swift, or call the completion handler as soon as you need to break free from the asynchronous behavior._

### Network Connectivity

We continue to encourage you to allow Network.framework to handle network connectivity issues. If a network goes down, the SDK knows when a connection is viable, when a better network is discovered, and when there is or is not internet access. All the SDK consumer really needs to do is inform the SDK upon the initial connection that a connection to the internet is possible. After that, the SDK will handle path connections for you as it experiences changes to the network.

We do not encourage forcing a reconnection attempt. Why? Because this behavior is resource-intensive and does not make sense when no connection to the internet is possible. The only time a reconnection attempt should happen is if there is a possibility of connecting to the internet, but we have lost the connection to the server. This situation only occurs if the server goes down for some reason. In that case, the SDK will try to reconnect.

For all other use cases, Network.framework notifies the SDK about network conditions, and the SDK always provides a connection with the best possible quality. Ignoring this behavior risks unexpected or undefined WebSocket connection behavior. The ability to force WebSocket connections is a deprecated initialization of the SDK and is discouraged for users to adopt.

