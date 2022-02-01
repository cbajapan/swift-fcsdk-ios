# Create a ACBUC Session

Here we will create our FCSDK Session in order to start using the SDK.

### ACBUC is the entry point for FCSDK clients. One very important factor is that after we authenticate our User, the server sends back a SessionID in the response. We need this SessionID in order to create our Session Object (ACBUC Object). So, without further ado, let's do that. 

Inside of our Login Request Method, where we receive the response, we want to do something with that response.

## Handle Response Object

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
 func createSession(sessionid: String, networkStatus: Bool) async {

// Initialize the ACBUC Object with our SessionID and set the Delegate
     self.acbuc = ACBUC.uc(withConfiguration: sessionid, delegate: self)

// Tell the object if the network is reachable or not
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
    func stopSession() async {
        self.acbuc?.stopSession()
    }
}
```
