# ACBUCObject

These are the methods available to you that you will need to use in order to create an FCSDK application.

## Overview
```swift
@objc final public class ACBUC : NSObject {

    /// This is the delegate used to interact with the methods related to ``ACBUC``
    @objc weak final public var delegate: FCSDKiOS.ACBUCDelegate?

    /// This is the ``ACBClientAED`` Object
    @objc final public var aed: FCSDKiOS.ACBClientAED { get }

    /// This property allows applications to use cookies
    @objc final public var useCookies: Bool

    /// This property gives the up to date websocket connection status
    @objc final public var connection: Bool

    /// This method is used to override the LoggingSystem and writes the logs to a file for Debugging. **We want to only initialize the LoggingSystem Bootstrap once**
    @objc final public class func logToFile(_ logLevel: FCSDKiOS.LoggingLevel = .debug)

    /// The static method to initialize the ``ACBUC`` object
    /// - Parameters:
    ///   - withConfiguration: The Configuration string
    ///   - delegate: The ``ACBUCDelegate``
    /// - Returns: The ``ACBUC`` Object
    @available(*, deprecated, message: "Will be removed in future versions of FCSDKiOS, use the Async version instead.")
    @objc final public class func uc(withConfiguration: String, delegate: FCSDKiOS.ACBUCDelegate?) -> FCSDKiOS.ACBUC

    /// The static method to initialize the ``ACBUC`` object
    /// - Parameters:
    ///   - withConfiguration: The Configuration string
    ///   - delegate: The ``ACBUCDelegate``
    /// - Returns: The ``ACBUC`` Object
    @objc final public class func uc(withConfiguration: String, delegate: FCSDKiOS.ACBUCDelegate?) async -> FCSDKiOS.ACBUC

    /// The static method to initialize the ``ACBUC`` object
    /// - Parameters:
    ///   - withConfiguration: The Configuration string
    ///   - stunServers: An array of Stun Servers
    ///   - delegate: The ``ACBUCDelegate``
    /// - Returns: The ``ACBUC`` Object
    @objc final public class func uc(withConfiguration: String, stunServers: [String] = [], delegate: FCSDKiOS.ACBUCDelegate?) async -> FCSDKiOS.ACBUC

    /// The static method to initialize the ``ACBUC`` object
    /// - Parameters:
    ///   - withConfiguration: The Configuration string
    ///   - stunServers: An array of Stun Servers
    ///   - delegate: The ``ACBUCDelegate``
    ///   - options: Additional ``ACBUCOptions``
    /// - Returns: The ``ACBUC`` Object
    @objc final public class func uc(withConfiguration: String, stunServers: [String] = [], delegate: FCSDKiOS.ACBUCDelegate?, options: FCSDKiOS.ACBUCOptions) async -> FCSDKiOS.ACBUC

    @objc final public var phone: FCSDKiOS.ACBClientPhone

    /// Starts the call session async without a callback
    @objc final public func startSession()

    ///Starts the a call session. A callback is available on completion in Objective-C
    @objc final public func startSession() async

    /// Stops a server session
    @objc final public func stopSession()

    /// Stops a server session.  A callback is available on completion in Objective-C
    @objc final public func stopSession() async

    /// Use this method to notify FCSDK that the application has a network connection
    /// - Parameter networkSatisfied: A boolean value determining whether or not the application has a network connection
    @objc final public func setNetworkReachable(_ networkSatisfied: Bool)

    /// Use this method to notify FCSDK that the application has a network connection.  A callback is available on completion in Objective-C
    /// - Parameter networkSatisfied: A boolean value determining whether or not the application has a network connection
    @objc final public func setNetworkReachable(_ networkSatisfied: Bool) async

    /// This method tells FCSDK the rule determined to allow any certificate
    /// - Parameter accept: A boolean value determining whether or not the server accepts any certificate
    @objc final public func acceptAnyCertificate(_ accept: Bool)
}
```
