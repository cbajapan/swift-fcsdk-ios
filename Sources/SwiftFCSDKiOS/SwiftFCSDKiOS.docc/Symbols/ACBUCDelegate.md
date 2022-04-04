# ACBUCDelegate

These are the methods available to you that you will need to use to be notified of FCSDK's behavior. 

## Overview

```swift
/**
 The delegate for the ACBUC instance. The delegate deals with session establishment notifications and high-level error scenarios.
 */
@objc public protocol ACBUCDelegate : NSObjectProtocol {

    /** A notification to indicate that the session has been initialised successfully.
     - Parameters:
     - uc: uc The UC.
     */
    @objc func ucDidStartSession(_ uc: FCSDKiOS.ACBUC)

    /** A notification to indicate that initialisation of the session failed.
     - Parameters:
     - uc: uc The UC.
     */
    @objc func ucDidFail(toStartSession uc: FCSDKiOS.ACBUC)

    /**  A notification to indicate that the server has experienced a system failure.
     - Parameters:
     - uc: uc The UC.
     */
    @objc func ucDidReceiveSystemFailure(_ uc: FCSDKiOS.ACBUC)

    /** A notification to indicate that there are problems with the network connection, the session
     has been lost, and all reconnection attempts have failed. See `uc(uc: ACBUC?, willRetryConnectionNumber attemptNumber: Int, in delay: TimerInterval)`
     for details.
     The app should log in again and re-establish a new session, or direct the user to do so.
     - Parameters:
     - uc: uc The UC.
     */
    @objc func ucDidLoseConnection(_ uc: FCSDKiOS.ACBUC)

    /**  A notification to indicate that there are problems with the network connection and that an attempt
     will be made to re-establish the session.
     
     In the event of connection problems, several attempts to reconnect will be made, and each attempt will
     be preceded by this notification. If after all of these attempts the session still cannot
     be re-established, the delegate will receive the ``ucDidLoseConnection(_:)`` callback and the attempts
     will stop. If one of the retries is successful then the delegate will receive the
     ``ucDidReestablishConnection(_:)`` callback.
     
     The delegate can decide to stop this retry process at any point by calling `stopSession()`.
     - Parameters:
     - attemptNumber: - 1 indicates the first reconnection attempt, 2 the second attempt, etc.
     - delay: - the next reconnection attempt will be made after this delay.
     */
    @objc optional func uc(_ uc: FCSDKiOS.ACBUC, willRetryConnectionNumber attemptNumber: UInt, in delay: TimeInterval)

    /**
     A notification to indicate that a reconnection attempt has succeeded.
     See `uc(uc: ACBUC?, willRetryConnectionNumber attemptNumber: Int, in delay: TimerInterval)` for details.
     - Parameters:
     - uc: uc The UC.
     */
    @objc optional func ucDidReestablishConnection(_ uc: FCSDKiOS.ACBUC)
}
```
