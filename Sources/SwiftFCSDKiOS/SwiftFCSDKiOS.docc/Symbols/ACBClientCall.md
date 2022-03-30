# ACBClientCall

Please see <doc:VideoCalls> for an explanation of how to use ACBClientCall

## Overview

```swift
/// `ACBClientCall` is the entry point for all call related methods in FCSDK. However this is limited to when incoming calls are made. For information on when outgoing calls are made please see ``ACBClientPhone``.
@objc final public class ACBClientCall : NSObject {

    /// Indicates whether or not the call has audio
    @objc final public var hasRemoteAudio: Bool { get }

    /// The call's Identifier
    @objc final public var callId: String

    /// The call's ``UIView`` used for displaying remote views
    @objc final public var remoteView: UIView?

    /// The call's ``UIView`` used for displaying remote buffer views intended for use in picture in picture enabled applications
    @objc final public func remoteBufferView() async -> UIView?

    /// The client should always remove the `remoteBufferView()` when finished using the bufferView.
    @objc final public func removeBufferView() async

    ///  A boolean value used to tell FCSDK if the client should have remote video when creating the call
    @objc final public var hasRemoteVideo: Bool { get }

    /// The remote address intended to call
    @objc final public var remoteAddress: String? { get }

    /// The remote display name for the call
    @objc final public var remoteDisplayName: String? { get }

    /// The calls delegate used to pass information intended for client useage
    @objc weak final public var delegate: FCSDKiOS.ACBClientCallDelegate?

    /// The status of our SDK. ``ACBClientCallStatus``
    @objc final public var status: FCSDKiOS.ACBClientCallStatus { get }

    ///  Determines whether or not the SDK should enable Audio
    /// - Parameter isAudioEnabled: A Boolean value to determine enabling
    @objc final public func enableLocalAudio(_ isAudioEnabled: Bool)

    ///  Determines whether or not the SDK should enable Video.  if our **WebRTCHandler** has not been intialized yet we set the availabily and then call
    ///  **localVideoStreamEvent()** at a later point in time. The PeerConnection connection should only be nil if the call has not yet been established.
    /// - Parameter isVideoEnabled:  A Boolean value to determine enabling
    @objc final public func enableLocalVideo(_ isVideoEnabled: Bool)

    /// Sends a DTMF message (to the server) given a number (0-9), ABCD, *, # as input.
    /// - Parameters:
    ///   - code: The DTMF code in string format to be sent to the server
    ///   - localPlayback: A Boolean value to indicated whether or not the SDK should play the local DTMF Audio
    @objc final public func playDTMFCode(_ code: String, localPlayback: Bool = false)

    /// This method ends the call entirely. If the call parameter is nil it will end the call associated with this current ACBClientCall object. However we may want to end a specific call which can be passed
    /// in the parameter.
    @objc final public func end()

    /// This method ends the call entirely. If the call parameter is nil it will end the call associated with this current ACBClientCall object.
    /// However we may want to end a specific call which can be passed  in the parameter.
    /// When used in Objective-C a callback is available.
    @objc final public func end() async
}

extension ACBClientCall {

    /// You can use this method to tell FCSDK to hold a call.
    @objc final public func hold()

    /// If your call is on ``hold()`` you may use this method to resume the call
    @objc final public func resume()
}

extension ACBClientCall {

    ///  This is or method used to answer an incoming call. When a user calls our end point FCSDK will notify us of an incoming call, at that point we must answer the call with this method.
    /// - Parameters:
    ///   - audioDir: The Direction we want to answer with. See... `ACBMediaDirection`
    ///   - videoDir:  The Direction we want to answer with. See... `ACBMediaDirection`
    @objc final public func answer(withAudio audioDir: FCSDKiOS.ACBMediaDirection, andVideo videoDir: FCSDKiOS.ACBMediaDirection)
}
```
