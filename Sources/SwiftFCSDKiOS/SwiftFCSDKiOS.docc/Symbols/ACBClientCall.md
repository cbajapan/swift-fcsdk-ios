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

    /// We create a Metal renderer `UIView` intended for local video usage
    /// - Parameters:
    ///   - scaleMode: Video content mode scale type
    ///   - shouldScaleWithOrientation: Determines if the video should scale when the device orientation changes
    /// - Returns: AVSampleBufferDisplayLayer backed UIView
    @MainActor @objc final public func remoteBufferView(scaleMode: FCSDKiOS.VideoScaleMode = .horizontal, shouldScaleWithOrientation: Bool = false) async -> UIView?

    /// The call's ``UIView`` used for displaying local buffer views intended for use in picture in picture/Virtual Background enabled applications
    @MainActor @objc final public func localBufferView() async -> UIView?

    /// We create a Metal renderer `UIView` intended for local video usage
    /// - Parameters:
    ///   - scaleMode: Video content mode scale type
        ///   - shouldScaleWithOrientation: Determines if the video should scale when the   device orientation changes
        /// - Returns: AVCaptureVideoPreviewLayer backed UIView
        @MainActor @objc final public func localBufferView(scaleMode: FCSDKiOS.VideoScaleMode =     .horizontal, shouldScaleWithOrientation: Bool = false) async -> UIView?
    
        /// The client should always remove the `removePreviewView()` when finished using the   previewView.
        @objc final public func removeLocalBufferView() async
    
        /// The AVCaptureSession that the PreviewBufferView provides
        @objc final public func captureSession() async -> AVCaptureSession?
    
        /// Feeds the AVPictureInPictureController into FCSDKiOS in order to receive the    controller's delegate method notifications.
        @MainActor @objc final public func setPipController(_ controller:   AVPictureInPictureController) async
    
        /// Feeds the UIImage from the consuming app into the SDK for Video Processing 
        @objc final public func feedBackgroundImage(_ image: UIImage? = nil, mode:  FCSDKiOS.VirtualBackgroundMode = .image) async
    
        /// Removes the Background Image from the Video Processsing flow 
        @objc final public func removeBackgroundImage() async
    
        /// An Enum that tells FCSDKiOS what mode the Virtual Background should be
        @objc public enum VirtualBackgroundMode: Int, Sendable, Equatable, Hashable,    RawRepresentable {
            case blur
            case image
        }
    
        ///  A boolean value used to tell FCSDK if the client should have remote video when     creating the call
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
        @available(*, deprecated, message: "Please use async version, Future versions of    FCSDKiOS will remove this method.")
        @objc final public func enableLocalAudio(_ isAudioEnabled: Bool)
        @objc final public func enableLocalAudio(_ isAudioEnabled: Bool) async
    
        ///  Determines whether or not the SDK should enable Video.  if our **WebRTCHandler**   has not been intialized yet we set the availabily and then call
        ///  **localVideoStreamEvent()** at a later point in time. The PeerConnection   connection should only be nil if the call has not yet been established.
        /// - Parameter isVideoEnabled:  A Boolean value to determine enabling
        @available(*, deprecated, message: "Please use async version, Future versions of    FCSDKiOS will remove this method.")
        @objc final public func enableLocalVideo(_ isVideoEnabled: Bool)
        @objc final public func enableLocalVideo(_ isVideoEnabled: Bool) async
    
        /// Sends a DTMF message (to the server) given a number (0-9), ABCD, *, # as input.
        /// - Parameters:
        ///   - code: The DTMF code in string format to be sent to the server
        ///   - localPlayback: A Boolean value to indicated whether or not the SDK should play  the local DTMF Audio
        @objc final public func playDTMFCode(_ code: String, localPlayback: Bool = false)
    
        /// This method ends the call entirely. If the call parameter is nil it will end the    call associated with this current ACBClientCall object. However we may want to end  a specific call which can be passed
        /// in the parameter.
        @available(*, deprecated, message: "Please use async version, Future versions of    FCSDKiOS will remove this method.")
        @objc final public func end()
    
        /// This method ends the call entirely. If the call parameter is nil it will end the    call associated with this current ACBClientCall object.
        /// However we may want to end a specific call which can be passed  in the parameter.
        /// When used in Objective-C a callback is available.
        @objc final public func end() async
    }
    
    extension ACBClientCall {
    
        /// You can use this method to tell FCSDK to hold a call.
        @available(*, deprecated, message: "Please use async version, Future versions of    FCSDKiOS will remove this method.")
        @objc final public func hold()
        @objc final public func hold() async 
    
        /// If your call is on ``hold()`` you may use this method to resume the call
        @available(*, deprecated, message: "Please use async version, Future versions of    FCSDKiOS will remove this method.")
        @objc final public func resume()
        @objc final public func resume() async
    }
    
    extension ACBClientCall {
        ///  This is our method used to answer an incoming call. When a user calls our end  point FCSDK will notify us of an incoming call, at that point we must answer the    call with this method.e     must answer the call with this     /// - Parameters:
        ///   - audioDir: The Direction we want to answer with. See... `ACBMediaDirection`
        ///   - videoDir:  The Direction we want to answer with. See... `ACBMediaDirection`
        @available(*, deprecated, message: "Please use async version, Future versions of    FCSDKiOS will remove this method.")
        @objc final public func answer(withAudio audioDir: FCSDKiOS.ACBMediaDirection, andVideo     videoDir: FCSDKiOS.ACBMediaDirection)
            
        ///  This is our method used to answer an incoming call asynchronously. When a user     calls our end point FCSDK will notify us of an incoming call, at that point we must     answer the call     with this method.
        /// - Parameters:
        ///   - audioDir: The Direction we want to answer with. See... `ACBMediaDirection`
        ///   - videoDir:  The Direction we want to answer with. See... `ACBMediaDirection`
        @objc final public func answer(withAudio audioDir: FCSDKiOS.ACBMediaDirection, andVideo     videoDir: FCSDKiOS.ACBMediaDirection) async
    }
    
        /// VideoScaleMode is an enumeration that allows you to decide to scale video in your   container view according to its tallest point, widest point, fill the media into    the container if the media does not already fill its entire container or feed raw   unscaled media into your video view.
        @objc public enum VideoScaleMode : Int, Sendable {
            case vertical
            case horizontal
            case fill
            case none
    }
```
