# ACBTopic

ACBTopic represents the topic that we created in <doc:ACBClientAED>. On the topic we can perform different functionality. Please see <doc:AED> for information on implementing.

## Overview

```swift
/// This class is used for creating AED Topics
@objc final public class ACBTopic : NSObject {

    /// The delegate for publicly exposing AED Topic methods
    @objc weak final public var delegate: FCSDKiOS.ACBTopicDelegate? { get }

    /// A name for this topic
    @objc final public var name: String { get }

    /// A boolean to determine if we are connected to this topic
    @objc final public var connected: Bool { get }
}

extension ACBTopic {

    /// This method will disconnect this object
    @objc final public func disconnect()

    /// This method will disconnect this object. It is the same call as `disconnect()`, but in Objective-C you can get a completion handler.
    @objc final public func disconnect() async

    /// This method will disconnect/delete the topic
    /// - Parameter deleteTopic: A Boolean that determines to delete or not
    @objc final public func disconnect(withDeleteFlag deleteTopic: Bool)

    /// This method will disconnect/delete the topic. In Objective-C you will get a callback on completion.
    /// - Parameter deleteTopic: A Boolean that determines to delete or not.
    @objc final public func disconnect(_ deleteTopic: Bool) async

    /// This method will create data for the currentTopic
    /// - Parameters:
    ///   - key: The Key for the object
    ///   - value: The Value for the object
    @objc final public func submitData(withKey key: String, value: String)

    /// This method will create data for the currentTopic. In Objective-C you will get a callback on completion.
    /// - Parameters:
    ///   - key: The Key for the object
    ///   - value: The Value for the object
    @objc final public func submitData(_ key: String, value: String) async

    /// This method will delete an data object with its key
    /// - Parameter key: key for the object to delete
    @objc final public func deleteData(withKey key: String)

    /// This method will delete an data object with its key. In Objective-C you will get a callback on completion.
    /// - Parameter key: key for the object to delete
    @objc final public func deleteData(_ key: String) async

    /// This method will create an AED Message
    /// - Parameter aedMessage: A message to send
    @objc final public func sendAedMessage(message aedMessage: String)

    /// This method will create an AED Message. In Objective-C you will get a callback on completion.
    /// - Parameter aedMessage: A message to send
    @objc final public func sendAedMessage(_ aedMessage: String) async
}
```
