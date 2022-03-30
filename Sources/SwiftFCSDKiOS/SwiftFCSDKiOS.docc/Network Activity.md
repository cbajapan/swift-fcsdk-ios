# Network Activity

This article talks about how FCSDK reacts toward the internet of things.

## Overview

It is strongly encouraged to move away from the old Reachability API that Apple provided for you in your applications and use the newer API called Network Framework. With that being said our Sample app give an idea of how to use this framework.  When creating a ACBUC Session we must remember to call the **setNetworkReachable(true)** method right after we create our ACBUC object. This tells FCSDK that there is an internet connection and that we can proceed making calls. If we do not monitor our network connection and tell FCSDK about it then you will experience unexpected behavior in using FCSDK.

## Note

You may want to consider reactively monitoring your network changes in order for FCSDK to always know when you have an internet connection, rather than only when a ACBUC Object is created.

## Responding to Network Issues

As the iOS SDK is network-based, it is essential that the client application is aware of any loss of connection. **Fusion Client SDK** does not dictate how you implement network monitoring; however, the sample application uses the SystemConfiguration framework.

Depending on the nature of the issues with the network, the client application should react differently.

### Reacting to Network Loss

In the event of network connection problems, the SDK automatically tries to re-establish the connection. It will make seven attempts at the following intervals: 0.5s, 1s, 2s, 4s, 4s, 4s, 4s. A call to the willRetryConnectionNumber:in:\] on the ACBUCDelegate precedes each of these attempts. The callback supplies the attempt number (as an Int) and the delay before the next attempt (as an TimeInterval) in its two parameters.

When all reconnection attempts are exhausted, the ACBUCDelegate receives the ucDidLoseConnection callback, and the retries stop. At this point the client application should assume that the session is invalid. The client application should then log out of the server and reconnect via the web app to get a new session, as described in the <doc:CreatingSession> section.

If any of the reconnection attempts are successful, the ACBUCDelegate receives the ucDidReestablishConnection callback.

Note that both the willRetryConnectionNumber and ucDidReestablishConnection are optional, so the application may choose to not implement them. The connection retries are attempted regardless.

The retry intervals, and the number of retries attempted by the SDK are subject to change in future releases. Do not rely on the exact values given above.

### Reacting to Network Changes

If the issues with the network are caused by a temporary loss of connectivity (for example, when moving between two Wi-Fi networks, or from a Wi-Fi network to a cellular data connection), the client application should not log out from the session and log back in (as described in the **Reacting to Network Loss** section), as all session state will be lost.

To avoid this, the client application should register with iOS to receive notification of changes in network reachability. When iOS notifies the client application that the network has changed, the application should pass these details to the ACBUC instance.

When the client application starts, it should check for network reachability. When the network is reachable, the application calls **ACBUC.setNetworkReachable(true)** until this call is made, the application does not attempt to create a session.

If the network reachability drops after a session has been established, the client application needs to call **ACBUC.setNetworkReachable(false)**

If the network reachability changes from a cellular data connection to a Wi-Fi network, or _vice versa_, the client application should call **ACBUC.setNetworkReachable(false)** followed by **ACBUC.setNetworkReachable(true)** to disconnect from the first network and re-register on the second.

### Network Quality Callbacks

The application can implement the didReportInboundQualityChange callback on the ACBClientCallDelegate object to receive callbacks on the quality of the network during a call:

```swift
    func call(_ call: ACBClientCall?, didReportInboundQualityChange inboundQuality: Int) {
        // Reflect in UI
        print("Call Quality: \(inboundQuality)")
    }
```

The inboundQuality parameter is a number between 0 and 100, where 100 indicates perfect quality. The application might choose to show a bar in the UI, the length of the bar indicating the quality of the connection.

The SDK starts collecting metrics as soon as it receives the remote media stream. It does this every 5s, so the first quality callback fires roughly 5s after this remote media stream callback has fired.

The callback then fires whenever a different quality value is calculated; so if the quality is perfect then there will be an initial quality callback with a value of 100 (after 5s), and then no further callback until the quality degrades.

## Available FCSDK Objects
<doc:ACBUCObject>

<doc:ACBUCDelegate>

<doc:ACBUCOptions>

<doc:ACBAudioDevice>

<doc:ACBAudioDeviceManager>

<doc:ACBClientAED>

<doc:ACBClientCall>

<doc:ACBClientCallDelegate>

<doc:ACBClientCallErrorCode>

<doc:ACBClientCallProvisionalResponse>

<doc:ACBClientCallStatus>

<doc:ACBClientPhone>

<doc:ACBMediaDirection>

<doc:ACBTopic>

<doc:ACBVideoCapture>

<doc:AedData>

<doc:TopicData>

<doc:Constants>
