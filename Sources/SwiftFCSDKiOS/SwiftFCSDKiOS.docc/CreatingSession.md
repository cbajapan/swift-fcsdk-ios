# Create a ACBUC Session

Here we will create our FCSDK Session in order to start using the SDK. ACBUC is the entry point for FCSDK clients. One very important factor is that after we authenticate our User, the server sends back a SessionID in the response. We need this SessionID in order to create our Session Object (ACBUC Object). First we will show you the properties and methods available to you and then we will show you how you can use them.

#### The ACBUC Object
These properties and methods are what is publicly available to you for creating an application.

<doc:ACBUCObject>

#### The ACBUCDelegate
You will need to conform to ACBUCDelegate in order to be notified of FCSDK behavior.

<doc:ACBUCDelegate>

#### ACBUCOptions 
These are ACBUCOptions. For most applications you do not need to be concerned with applying options.

<doc:ACBUCOptions>


## Handle Response Object

Now that you have been able to review the technology needed to create an FCSDK application, we can start creating a session. Inside of our Login Request Method, where we receive the response, we want to do something with that response.

```swift
class AuthenticationService: NSObject, ObservableObject {

// Add these 3 properties to the file
@Published var sessionID = ""
@Published var connectedToSocket = false
@Published var acbuc: ACBUC?
    
    override init(){}

func loginUser(networkStatus: Bool) async {

// We Create our credentials and then made our call

let (data, response) = try? await repository.asyncLogin(loginReq: loginCredentials, reqObject: requestLoginObject())
let payload = try JSONDecoder().decode(LoginResponse.self, from: data)

// Now let's do stuff with our response

// Set SessionID with our SessionID we get back in the payload
self.sessionID = payload?.sessionid ?? ""
// Create the Session
await self.createSession(sessionid: payload?.sessionid ?? "", networkStatus: networkStatus)
// Set the connected to Socket status
self.connectedToSocket = self.acbuc?.connection != nil

}
```


## Create Session

```swift

/// Create the Session
/// - Parameters:
///   - sessionid: The SessionID we get back from the Server.
///   - networkStatus: The Network status from our Network Monitor.
 func createSession(sessionid: String, networkStatus: Bool) {

// Initialize the ACBUC Object with our SessionID and set the Delegate
     self.acbuc = ACBUC.uc(withConfiguration: sessionid, delegate: self)

// Tell the object if the network is reachable or not. 
// This is needed in order to successfully register a session and set the ACBUCDelegate.
     self.acbuc?.setNetworkReachable(networkStatus)

// Tell the object if we accept any certificate from the server
     let acceptUntrustedCertificates = UserDefaults.standard.bool(forKey: "Secure")
     self.acbuc?.acceptAnyCertificate(acceptUntrustedCertificates)

// Tell the object if we are going to use cookies
     let useCookies = UserDefaults.standard.bool(forKey: "Cookies")
     self.acbuc?.useCookies = useCookies

// Start the Session
     self.acbuc?.startSession()
}
```

## Stop Session
``` swift

/// Stop the Session
    func stopSession() {
        self.acbuc?.stopSession()
    }
}
```

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
