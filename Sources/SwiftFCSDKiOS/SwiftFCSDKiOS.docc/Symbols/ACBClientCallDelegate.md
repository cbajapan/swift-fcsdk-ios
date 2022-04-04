# ACBClientCallDelegate

Please see <doc:VideoCalls> for an explanation of how to use ACBClientCallDelegate

## Overview

```swift
@objc public protocol ACBClientCallDelegate : NSObjectProtocol {

    /// Here we can receive the media change request from the delegate
    @objc func callDidReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall)

    /// Here we can be notified of `ACBClientCallStatus` changes
    @objc func call(_ call: FCSDKiOS.ACBClientCall, didChange status: FCSDKiOS.ACBClientCallStatus)

    /// Here we can be notified on call failure
    @objc func call(_ call: FCSDKiOS.ACBClientCall, didReceiveCallFailureWithError error: Error)

    /// Here we receive the call failure notice
    @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReceiveDialFailureWithError error: Error)

    /// Here we receive the session interruption notice
    @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReceiveSessionInterruption message: String)

    /// Here we receive the recording permission failure notice
    @objc optional func call(_ call: FCSDKiOS.ACBClientCall?, didReceiveCallRecordingPermissionFailure message: String)

    /// Here we received the did change the remote display name notice
    @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didChangeRemoteDisplayName name: String)

    /// Here we are notfied when a call did add a local media stream
    @objc optional func callDidAddLocalMediaStream(_ call: FCSDKiOS.ACBClientCall)

    /// Here we are notfied when a call did add a remote media stream
    @objc optional func callDidAddRemoteMediaStream(_ call: FCSDKiOS.ACBClientCall)

    /// Here we are notified when we will receive media change requests
    @objc optional func callWillReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall)

    /// Here we will receive a notification when the inbound call quality will change
    @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReportInboundQualityChange inboundQuality: Int)

    /// Here we are notfied when receiving SSRCs
    @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReceiveSSRCsForAudio audioSSRCs: [AnyHashable]?, andVideo videoSSRCs: [AnyHashable]?)

    /// Here we are receive the provisional response
    @objc optional func call(call: FCSDKiOS.ACBClientCall, didReceive responseStatus: FCSDKiOS.ACBClientCallProvisionalResponse, withReason reason: String?)
}
```
