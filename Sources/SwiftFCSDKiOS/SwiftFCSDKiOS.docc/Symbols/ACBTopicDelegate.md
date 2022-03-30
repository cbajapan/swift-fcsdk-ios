# ACBTopicDelegate

The methods available to call via ACBTopic.

## Overview

```swift
@objc public protocol ACBTopicDelegate : NSObjectProtocol {

    /// Connects to a topic with a given data
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didConnectWithData data: FCSDKiOS.AedData)

    /// Delete a message from a topic
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didDeleteWithMessage message: String)

    /// Topic to submit
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didSubmitWithKey key: String, value: String, version: Int)

    /// Topic to delete
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didDeleteDataSuccessfullyWithKey key: String, version: Int)

    /// Gets the topic and then notifies the delegate with the message
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didSendMessageSuccessfullyWithMessage message: String)

    ///  Connection failed with message
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didNotConnectWithMessage message: String)

    /// Did not delete with message
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didNotDeleteWithMessage message: String)

    /// Did not submit key with message
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didNotSubmitWithKey key: String, value: String, message: String)

    /// Did not delete data with message
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didNotDeleteDataWithKey key: String, message: String)

    /// Did not send message with origianl message
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didNotSendMessage originalMessage: String, message: String)

    /// A Topic to delete
    @objc func topicDidDelete(_ topic: FCSDKiOS.ACBTopic?)

    ///  Did update key
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didUpdateWithKey key: String, value: String, version: Int, deleted: Bool)

    /// Did receive message
    @objc func topic(_ topic: FCSDKiOS.ACBTopic, didReceiveMessage message: String)
}
```
