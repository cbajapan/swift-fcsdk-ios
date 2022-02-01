# AED
The application initially accesses the API via a single object called ACBUC, from which other objects can be retrieved. ACBUC has an attribute named aed, which is the starting point for all **Application Event Distribution** operations.
## Overview

To create an AED application, you need to:

1.   Create an instance of ACBTopicDelegate and implement the callback methods.

2.   Access the aed attribute to create or connect to an ACBTopic, supplying the delegate from the previous step.

3.   Call methods on the topic object to change data on the topic.

4.   Disconnect from the topic when you no longer want to receive AED notifications.


## Creating and Connecting to a Topic

The application can create a topic using the createTopicWithName:delegate: method on the AED object:
```swift
let topic: ACBTopic = acbuc?.aed?.createTopic(withName: topic.name, delegate: self.aedService)
```
or the createTopicWithName:expiryTime:delegate: method:
```swift
let topic: ACBTopic = acbuc?.aed?.createTopic(withName: self.topicName, expiryTime: expiry, delegate: self.aedService)
```
The name of the topic is an String, and the expiryTime parameter is a time in minutes. A topic created with an expiry time will be automatically removed from the server after the topic has been inactive for that time. When created without an expiry time, the topic exists indefinitely, and the application must delete it explicitly (see the **Disconnecting from a Topic** section). The delegate is an object conforming to the ACBTopicDelegate protocol.

Either of these creates a client-side representation of a topic and automatically connects to it. If the topic already exists on the server, it connects to that topic; if the topic does not already exist, it creates it.

### didConnectWithData

After connecting to the topic, the delegate will receive a didConnectWithData callback. (In the case of failure, it will receive a didNotConnectWithMessage callback with a message parameter (an String).) The didConnectWithData callback has a single data parameter containing all the data currently associated with the topic.

The data parameter is an AedData Struct that is available for you to use. This struct contains all the properties needed for you to send Aed to the server, both in Swift and Objective-C. The application can iterate through the data items to display them to the newly connected user:
```swift
func topic(_ topic: ACBTopic, didConnectWithData data: AedData) {
    Task {
        await MainActor.run {
            topicList.append(topic)
            currentTopic = topic
            let topicExpiry = data.timeout ?? 0
            
            var expiryClause: String = ""
            if topicExpiry > 0 {
                expiryClause = "expires in \(String(describing: topicExpiry)) mins"
            }
            else{
                expiryClause = "no expiry"
            }
            
            var msg = "Topic '\(currentTopic?.name ?? "")' connected succesfully (\(expiryClause))."
            self.consoleMessage = msg
            msg = "Current topic is '\(currentTopic?.name ?? "")'. Topic Data:"
            self.consoleMessage = msg
        }
    }
    guard let topicData = data.topicData else { return }
    
    for data in topicData{
        print("Key:'\(data.key ?? "")' Value:'\(data.value ?? "")'")
    }
}
```
## Disconnecting from a Topic

You can either disconnect from the topic without destroying it:
```swift
    topic.disconnect(withDeleteFlag: true)
```
or delete the topic from the server, which will also disconnect any other subscribers:
```swift
    topic.disconnect(withDeleteFlag: false)
```
When you delete the topic by calling disconnect(withDeleteFlag: true), you will receive a didDeleteWithMessage callback, followed by a topicDidDelete callback.

### topicDidDelete

All clients connected to the topic receive a topicDidDelete callback when the topic is deleted from the server, either as a result of any client deleting it, or as a result of the topic expiring on the server (see the **Creating and Connecting to a Topic** section for details of topic expiry). Once a topic has been deleted, the client should not call any of that topic's methods (which will fail in any case), and should consider itself unsubscribed from that topic. If a topic with the same name is subsequently created, it is a new topic, and the client will not be automatically subscribed to it.

## Publishing Data to a Topic

Once the application has connected to a topic, it can publish data on it. Data consists of name-value pairs:
```swift
    currentTopic?.submitData(withKey: self.key, value: self.value)
```
Having submitted the data, the delegate receives either a didSubmitWithKey or (in the case of failure) a didNotSubmitWithKey callback. Both callbacks contain the key and value which were submitted (successfully or unsuccessfully). The didNotSubmitWithKey callback also contains a message parameter giving more details of the failure The didSubmitWithKey callback also contains a version parameter; this is an incrementing value which enables the application to check if the data it has just sent is the latest on the server.

In the case of a successful submission, the delegate also receives a didUpdateWithKey callback.

### didUpdateWithKey

A client receives a didUpdateWithKey callback when any client connected to the topic makes a change to a data item on that topic. The callback contains the key, value, and version parameters detailed previously (value contains the new value), and an additional deleted parameter, which will be `true` if the data item has been deleted from the server (see **Deleting Data from a Topic**).

## Deleting Data from a Topic

The client can delete the data item from the topic by calling:
```swift
    currentTopic?.deleteData(withKey: self.key)
```
The delegate receives either a didDeleteDataSuccessfullyWithKey callback (containing the key and version) or a didNotDeleteDataWithKey callback (containing a message indicating the cause of failure).

All clients subscribed to the topic will also receive a didUpdateWithKey callback, with the deleted parameter set to TRUE.

## Sending a Message to a Topic

A client application can send a message to a topic and have that message sent to all current subscribers:
```swift
    currentTopic?.sendAedMessage(self.messageText)
```
If it is successful, the delegate receives a didSendMessageSuccessfullyWithMessage callback followed by a didReceiveMessage callback, both containing the message in the message parameter; if it is not successful, the delegate receives a didNotSendMessage callback, containing an originalMessage and a message parameter.

### didReceiveMessage

The delegate will receive a didReceiveMessage callback whenever any connected client (including itself) sends a message to the topic. The only parameter is the message parameter (containing the text of the sent message).
