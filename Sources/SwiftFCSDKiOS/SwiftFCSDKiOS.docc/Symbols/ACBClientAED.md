# ACBClientAED

ACBClientAED allows users to create ACBTopics. Please see <doc:AED> for information on implementing.

## Overview

```swift
    /// This class represents the interface for creating AED Objects
    @objc final public class ACBClientAED : NSObject {
    
        /// This method is what allows an ``ACBTopic`` to be created without an expiry time
        /// - Parameters:
        ///   - topicName: The name of a topic you would like to create
        ///   - delegate: The ``ACBTopicDelegate``
        /// - Returns: The ``ACBTopic`` you created
        @objc final public func createTopic(withName topicName: String, delegate:   FCSDKiOS.ACBTopicDelegate?) -> FCSDKiOS.ACBTopic?
    
        /// This method is what allows an ``ACBTopic`` to be created
        /// - Parameters:
        ///   - topicName: The name of a topic you would like to create
        ///   - expiryTime: The lengh of time as in `Int`
        ///   - delegate: The ``ACBTopicDelegate``
        /// - Returns: The ``ACBTopic`` you created
        @objc final public func createTopic(withName topicName: String, expiryTime: Int,    delegate: FCSDKiOS.ACBTopicDelegate?) -> FCSDKiOS.ACBTopic?
    }
```
