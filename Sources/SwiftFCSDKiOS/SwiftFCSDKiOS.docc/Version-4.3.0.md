# Version 4.3.0

This article describes changes in version 4.3.0 of FCSDKiOS

## Overview

Version 4.3.0 has reached a new milestone in moving to a **Swift Concurrency Complete Checking** environment. We have also improved the performance and speed of video rendering. 4.3.0 also introduced some new Public API's and also has deprecated/removed some old ways of doing things in a less safe **Swift Concurrency** environment.

### The enabling of Audio and Video DSCP values.

These 3 methods have been introduced into the UC object of FCSDKiOS. Notice that in Swift they are parameters with default values meaning that they if you choose to use them, they may be initialized with the desired RTCPriority values. In Objective-C default parameters are not supported so, we left the previous 3 APIs for UC initialization in order to not break your projects and still allow DSCP Prioritization. 

```swift
    @objc public class func uc(
        withConfiguration: String,
        audioDSCPPriority: CBARTCPriority = .none,
        videoDSCPPriority: CBARTCPriority = .none,
        delegate: ACBUCDelegate?
    ) async -> ACBUC {}
    
    @objc public class func uc(
        withConfiguration: String,
        stunServers: [String] = [],
        audioDSCPPriority: CBARTCPriority = .none,
        videoDSCPPriority: CBARTCPriority = .none,
        delegate: ACBUCDelegate?
    ) async -> ACBUC {}
    
     @objc public class func uc(
        withConfiguration: String,
        stunServers: [String] = [],
        audioDSCPPriority: CBARTCPriority = .none,
        videoDSCPPriority: CBARTCPriority = .none,
        delegate: ACBUCDelegate?,
        options: ACBUCOptions
    ) async -> ACBUC {}
```

### What is DSCP Prioritization?

**DSCP stands for Differentiated Services Code Point. It is a field in the IP header that is used to classify and manage network traffic to provide quality of service (QoS) in computer networks.**

To begin let's have a discussion on **P2P** Connections. During a *Peer-to-Peer* connection information about the other user is discovered this allows the callee and caller to transmit information to each other using the **User Datagram Protocol**. **WebRTC** uses **UDP** to transmit **RTP Packets** to the intended target. For certain *Networking* situation a user may decide that they need to mark **RTP** Packets with an *Assured Forwarding Network Priority*. When the user sets a preferred priority we are **requesting** for **WebRTC** to mark the aforementioned headers with the preferred priority in order for the network to know what to do with each packet's **Quality of Service**. It is important to note that *Network Configuration* needs to be taken into consideration in order to ensure that the **Internet Protocol** actually forwards the **QoS** Header. It is up to the engineering team to ensure their networking environment is properly set up.

### Setting WebSocket Connection Timeout

As we move toward a Swift 6 concurrency safe environment we are asking developers to please move to our new APIs. This includes the setting of the **WebSocket Connection Timeout** on the `startSession()` method instead of setting it on the `Constants` Object. Please notice the following APIs.

```swift
     /// Starts the call session async without a callback
     /// - Parameter timeout: WebSocket Connection Timeout
     @objc public func startSession(timeout: Float = 7.0) {}
    
    /// Starts the async call session. A callback is available on completion in Objective-C
    /// - Parameter timeout: WebSocket Connection Timeout
    @objc public func startSession(timeout: Float = 7.0) async {}
```

### Removal Of Deprecated Code

Please notice the *removed* deprecated code and introduce the new methods into your projects. Below you will notice the deprecated method and the available method. You need to use the available method in your projects now.

#### Setting the camera position
```swift
    @available(*, deprecated, message: "Please use async version, This method will be removed in FCSDKiOS 4.3.0")
    @objc public func setCamera(_ position: AVCaptureDevice.Position) {}
    
    @MainActor
    @objc public func setCamera(_ position: AVCaptureDevice.Position) async {} 
```

#### Getting the recommended video capture settings from the Phone Object
```swift
    @available(*, deprecated, message: "Please use the ACBClientPhone object to get the recommended capture settings, This class will be removed in FCSDKiOS 4.3.0")
    public final class ACBDevice: @unchecked Sendable {
        @MainActor
        @objc public func recommendedCaptureSettings() -> [ACBVideoCaptureSetting] {}
    }
    
    // Phone Object
    @available(*, deprecated, message: "Please use async version, This method will be removed in FCSDKiOS 4.3.0")
    @objc public func recommendedCaptureSettings() -> [ACBVideoCaptureSetting]? {}
    
    //Please use this method
    @objc public func recommendedCaptureSettings() async -> [ACBVideoCaptureSetting]? {}
```

#### Creating a call
```swift
     @available(*, deprecated, message: "use createCall() async instead. This method will be removed in FCSDKiOS 4.3.0")
     @objc public func createCall(
        toAddress remoteAddress: String,
        withAudio audioDirection: ACBMediaDirection,
        video videoDirection: ACBMediaDirection,
        delegate: ACBClientCallDelegate
    ) -> ACBClientCall? {}
    
    //Please use one of these available methods
    @objc public func createCall(
        toAddress remoteAddress: String,
        withAudio audioDirection: ACBMediaDirection,
        video videoDirection: ACBMediaDirection,
        delegate: ACBClientCallDelegate
    ) async -> ACBClientCall? {}
```

#### Answering a call
```swift
     @available(*, deprecated, message: "use answer(withAudio:) async instead, Future versions of FCSDKiOS will remove this method")
     @objc public func answer(withAudio audioDir: ACBMediaDirection, andVideo videoDir: ACBMediaDirection) {}

     //Please use this method
     @objc public func answer(withAudio audioDir: ACBMediaDirection, andVideo videoDir: ACBMediaDirection) async {}
```

#### Holding a call
```swift
    @available(*, deprecated, message: "Please use async version, This method will be removed in FCSDKiOS 4.3.0")
    @objc public func hold() {}
    
    //Please use this method
    @objc public func hold() async {}
```

#### Resuming a call
```swift
    @available(*, deprecated, message: "Please use async version, This method will be removed in FCSDKiOS 4.3.0")
    @objc public func resume() {}
    
    //Please use this method
    @objc public func resume() async {}
```

#### Creating a remote buffer view
```swift
     @available(*, deprecated, message: "Please use metal by default method as we render on metal rergardless, This method will be removed in FCSDKiOS 4.3.0")
     @MainActor
     @objc public func remoteBufferView(
        scaleMode: VideoScaleMode = .horizontal,
        shouldScaleWithOrientation: Bool = false,
        shouldRenderOnMetal: Bool = true
    ) async -> UIView? {}
    
     //Please use this method
     @MainActor
     @objc public func remoteBufferView(
        scaleMode: VideoScaleMode = .horizontal,
        shouldScaleWithOrientation: Bool = false
    ) async -> UIView? {}
```

#### Creating a local buffer view
```swift
     @available(*, deprecated, message: "Please use metal by default method as we render on metal rergardless, This method will be removed in FCSDKiOS 4.3.0")
     @MainActor
     @objc public func localBufferView(
        scaleMode: VideoScaleMode = .horizontal,
        shouldScaleWithOrientation: Bool = false,
        shouldRenderOnMetal: Bool = true
    ) async -> UIView? {}
    
    //Please use this method
     @MainActor
     @objc public func localBufferView(
        scaleMode: VideoScaleMode = .horizontal,
        shouldScaleWithOrientation: Bool = false
    ) async -> UIView? {}
```

#### Enabling audio on a call
```swift
     @available(*, deprecated, message: "Please use async version, This method will be removed in FCSDKiOS 4.3.0")
     @objc public func enableLocalAudio(_ isAudioEnabled: Bool) {}
    
     //Please use this method
     @objc public func enableLocalAudio(_ isAudioEnabled: Bool) async {}
```

#### Enabling video on a call
```swift
    @available(*, deprecated, message: "Please use async version, This method will be removed in FCSDKiOS 4.3.0")
    @objc public func enableLocalVideo(_ isVideoEnabled: Bool) {}
    
    //Please use this method
    @objc public func enableLocalVideo(_ isVideoEnabled: Bool) async {}
```

#### Ending a call
```swift
    @available(*, deprecated, message: "Please use async version, This method will be removed in FCSDKiOS 4.3.0")
    @objc public func end() {}
    
    //Please use this method
    @objc public func end() async {}
```

#### Creating a UC Object
```swift
    @available(*, deprecated, message: "Will be removed in future versions of FCSDKiOS, use the Async version instead.")
    @objc public class func uc(
        withConfiguration: String,
        delegate: ACBUCDelegate?
    ) -> ACBUC {}
    
    //Please use one of these available methods
    @objc public class func uc(
        withConfiguration: String,
        delegate: ACBUCDelegate?
    ) async -> ACBUC {}
```


### New Deprecations

The Following is a list of newly deprecated code that will be removed in future versions of FCSDKiOS

```swift 
    @available(*, deprecated, message: "Please use start session with websocket timeout as a parameter")
    /// Starts the call session async without a callback
    @objc public func startSession() {}
    
    @available(*, deprecated, message: "Please use async start session with websocket timeout as a parameter")
    ///Starts the async call session. A callback is available on completion in Objective-C
    @objc public func startSession() async {}
     @available(*, deprecated, message: "Please set websocket connection timeout on the start session method parameter")

    @MainActor
    @objc static public var WEBSOCKET_CONNECTION_TIMEOUT: Float = 7.0
```
