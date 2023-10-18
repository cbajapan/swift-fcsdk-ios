# ACBClientCallDelegate

Please see <doc:VideoCalls> for an explanation of how to use ACBClientCallDelegate

## Overview

```swift
    @objc public protocol ACBClientCallDelegate : NSObjectProtocol {
    
        /// Here we can receive the media change request from the delegate
        @objc optional func callDidReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall)
    
        @objc optional func didReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall) async
    
        /// Here we can be notified of `ACBClientCallStatus` changes
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didChange status:  FCSDKiOS.ACBClientCallStatus)
    
        @objc optional func didChange(_ status: FCSDKiOS.ACBClientCallStatus, call:     FCSDKiOS.ACBClientCall) async
    
        /// Here we can be notified on call failure
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReceiveCallFailureWithError     error: Error)
    
        @objc optional func didReceiveCallFailure(with error: Error, call:  FCSDKiOS.ACBClientCall) async
    
        /// Here we receive the call failure notice
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReceiveDialFailureWithError     error: Error)
    
        @objc optional func didReceiveDialFailure(with error: Error, call:  FCSDKiOS.ACBClientCall) async
    
        /// Here we receive the session interruption notice
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReceiveSessionInterruption  message: String)
    
        @objc optional func didReceiveSessionInterruption(_ message: String, call:  FCSDKiOS.ACBClientCall) async
    
        /// Here we receive the recording permission failure notice
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall?,   didReceiveCallRecordingPermissionFailure message: String)
    
        @objc optional func didReceiveCallRecordingPermissionFailure(_ message: String, call:   FCSDKiOS.ACBClientCall?) async
    
        /// Here we received the did change the remote display name notice
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didChangeRemoteDisplayName     name: String)
    
        @objc optional func didChangeRemoteDisplayName(_ name: String, with call:   FCSDKiOS.ACBClientCall) async
    
        /// Here we are notfied when a call did add a local media stream
        @objc optional func callDidAddLocalMediaStream(_ call: FCSDKiOS.ACBClientCall)
    
        @objc optional func didAddLocalMediaStream(_ call: FCSDKiOS.ACBClientCall) async
    
        /// Here we are notfied when a call did add a remote media stream
        @objc optional func callDidAddRemoteMediaStream(_ call: FCSDKiOS.ACBClientCall)
    
        @objc optional func didAddRemoteMediaStream(_ call: FCSDKiOS.ACBClientCall) async
    
        /// Here we are notified when we will receive media change requests
        @objc optional func callWillReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall)
    
        @objc optional func willReceiveMediaChangeRequest(_ call: FCSDKiOS.ACBClientCall) async
    
        /// Here we will receive a notification when the inbound call quality will change
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReportInboundQualityChange  inboundQuality: Int)
    
        @objc optional func didReportInboundQualityChange(_ inboundQuality: Int, with call:     FCSDKiOS.ACBClientCall) async
    
        /// Here we are notfied when receiving SSRCs
        @objc optional func call(_ call: FCSDKiOS.ACBClientCall, didReceiveSSRCsForAudio    audioSSRCs: [String], andVideo videoSSRCs: [String])
    
        @objc optional func didReceiveSSRCs(for audioSSRCs: [String], andVideo videoSSRCs:  [String], call: FCSDKiOS.ACBClientCall) async
    
        /// Here we are receive the provisional response
        @objc optional func call(call: FCSDKiOS.ACBClientCall, didReceive responseStatus:   FCSDKiOS.ACBClientCallProvisionalResponse, withReason reason: String)
    
        @objc optional func responseStatus(didReceive responseStatus:   FCSDKiOS.ACBClientCallProvisionalResponse, withReason reason: String, call:     FCSDKiOS.ACBClientCall) async
    }
```
