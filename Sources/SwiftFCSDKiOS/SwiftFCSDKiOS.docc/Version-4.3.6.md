# Version 4.3.6

This article describes changes in version 4.3.6 of FCSDKiOS

## Overview

Version 4.3.6 has the following fixes

Performance enhancements

## FCSDKiOS Changelog

#### Summary
Legacy and deprecated delegate methods, as well as the old bridging layer, have been removed.
When integrating via Objective-C, apps must now implement all methods of the public delegate protocols (you may provide empty implementations for callbacks you don't use).
This change ensures a consistent API surface and removes ambiguity introduced by deprecated paths.

Note: This change does not affect Swift integrations.
Swift-based projects already conform to the complete delegate protocols and continue to work without modification.

---

#### Affected Delegate Protocols and Required Methods

**ACBUCDelegate**
- `didStartSession(_ uc: ACBUC) async`
- `didFail(toStartSession uc: ACBUC) async`
- `didReceiveSystemFailure(_ uc: ACBUC) async`
- `didLoseConnection(_ uc: ACBUC) async`
- `uc(_ uc: ACBUC, willRetryConnection attemptNumber: Int, in delay: TimeInterval) async`
- `didReestablishConnection(_ uc: ACBUC) async`

**ACBClientPhoneDelegate**
- `phone(_ phone: ACBClientPhone, received call: ACBClientCall) async`
- `phone(_ phone: ACBClientPhone, didChangeSettings settings: ACBVideoCaptureSetting, for camera: AVCaptureDevice.Position) async`

**ACBClientCallDelegate**
- `didReceiveMediaChangeRequest(_ call: ACBClientCall) async`
- `didChange(_ status: ACBClientCallStatus, call: ACBClientCall) async`
- `didReceiveCallFailure(with error: Error, call: ACBClientCall) async`
- `didReceiveDialFailure(with error: Error, call: ACBClientCall) async`
- `didReceiveSessionInterruption(_ message: String, call: ACBClientCall) async`
- `didReceiveCallRecordingPermissionFailure(_ message: String, call: ACBClientCall?) async`
- `didChangeRemoteDisplayName(_ name: String, with call: ACBClientCall) async`
- `didAddLocalMediaStream(_ call: ACBClientCall) async`
- `didAddRemoteMediaStream(_ call: ACBClientCall) async`
- `willReceiveMediaChangeRequest(_ call: ACBClientCall) async`
- `didReportInboundQualityChange(_ inboundQuality: Int, with call: ACBClientCall) async`
- `didReceiveSSRCs(for audioSSRCs: [String], andVideo videoSSRCs: [String], call: ACBClientCall) async`
- `responseStatus(didReceive responseStatus: ACBClientCallProvisionalResponse, withReason reason: String, call: ACBClientCall) async`

---

#### Renamed methods

**ACBUCDelegate**
- `ucDidStartSession(_:)` → `didStartSession(_:)`
- `ucDidFailToStartSession(_:)` → `didFail(toStartSession:)`
- `ucDidReceiveSystemFailure(_:)` → `didReceiveSystemFailure(_:)`
- `ucDidLoseConnection(_:)` → `didLoseConnection(_:)`
- `uc(uc:willRetryConnectionNumber:in:)` → `uc(_:willRetryConnection:in:)`
- `ucDidReestablishConnection(_:)` → `didReestablishConnection(_:)`

**ACBClientPhoneDelegate**
- `phoneDidReceiveIncomingCall(_:)` / `didReceiveCall(_:)` → `phone(_:received:)`
- `didChangeVideoSettings` / `phoneDidChangeCaptureSettings(_:settings:camera:)` → `phone(_:didChangeSettings:for:)`

**ACBClientCallDelegate**
- `callWillReceiveMediaChangeRequest(_:)` → `willReceiveMediaChangeRequest(_:)`
- `callDidChangeStatus(_:call:)` / `didChangeCallStatus` → `didChange(_:call:)`
- `callDidFail(_:)` / `didReceiveCallError` → `didReceiveCallFailure(with:call:)`
- `callDidReceiveDialFailure(_:)` → `didReceiveDialFailure(with:call:)`
- `callDidReceiveSessionInterruption(_:)` → `didReceiveSessionInterruption(_:call:)`
- `callRecordingPermissionFailure(_:)` → `didReceiveCallRecordingPermissionFailure(_:call:)`
- `callDidChangeRemoteDisplayName(_:)` → `didChangeRemoteDisplayName(_:with:)`
- `callDidAddLocalStream` / `_LocalMedia` → `didAddLocalMediaStream(_:)`
- `callDidAddRemoteStream` / `_RemoteMedia` → `didAddRemoteMediaStream(_:)`
- `callInboundQualityDidChange(_:)` → `didReportInboundQualityChange(_:with:)`
- `callDidReceiveSSRCs(audio:video:)` → `didReceiveSSRCs(for:andVideo:call:)`
- `callDidReceiveProvisionalResponse(_:reason:)` → `responseStatus(didReceive:withReason:call:)`

---

#### Migration Guide (Objective-C)
- Ensure that all ObjC classes conforming to `ACBUCDelegate`, `ACBClientPhoneDelegate`, and `ACBClientCallDelegate` **implement all listed methods**.  
  (Provide empty bodies for callbacks you don't use.)
- Replace any legacy delegate names with the new equivalents shown above.
- Remove any references to deprecated bridging layers and rely solely on the generated Swift-to-Objective-C headers.