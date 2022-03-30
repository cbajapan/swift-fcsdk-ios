# Authentication

This article will discuss the Authentication flow for FCSDKiOS.

## Overview

Authentication is the entry point of an FCSDKiOS app. Previously, in the Legacy versions of FCSDKiOS(ACBClientSDK), we would start an Auth process by importing `ACBClientSDK`. Starting in FCSDKiOS 4.0.0 we have clarified what you import with what the SDK is called. For unification and clarity, you will now import FCSDKiOS with `import FCSDKiOS`. Great! Now that we have discussed that, we can talk now about Authentication.  

## Authenticating a User and it's Session

For authenticating a user, we want to use URLSession. Previously, we had used NSURLConnection. You will be happy to know and hear that we are now using URLSession in our Sample app. An Authentication process has six parts to it.
* URLRequest
* HTTPCookies
* URLSessionConfiguration
* URLSession
* HTTPURLResponse
* URLSessionDelegate

## Network Manager

Now this may sound like a lot, but it is fairly simple and straightforward. The code block below will explain more.

```swift
class NetworkManager: NSObject, ObservableObject, URLSessionDelegate {


/// Async Network Wrapper
/// - Parameters:
///   - type: Type that conforms to Codable.
///   - urlString: The URLString to your Server.
///   - httpMethod: The HTTP Method Type.
///   - httpBody: The Body to send in a request.
///   - headerField: A header field you can choose to add.
///   - headerValue: The header field's value.
func asyncCodableNetworkWrapper<T: Codable>(
    type: T.Type,
    urlString: String,
    httpMethod: String,
    httpBody: Data? = nil,
    headerField: String = "",
    headerValue: String = ""
) async throws -> (Data, URLResponse) {

// Add your URL String
    guard let url = URL(string: urlString) else { throw OurErrors.nilURL }
    var request = URLRequest(url: url)

// Set HTTPMethod
    request.httpMethod = httpMethod
    
// Send body if we are a POST or PUT
    if httpMethod == "POST" || httpMethod == "PUT" {
        request.httpBody = httpBody
    }
    
// Set the JSON Header type.
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
// Pass cookies if we want cookies
    let allCookies = HTTPCookieStorage.shared.cookies
    for cookie in allCookies ?? [] {
        HTTPCookieStorage.shared.deleteCookie(cookie)
    }
// Start up our URLSession
    let session = URLSession(configuration: self.configuration, delegate: self, delegateQueue: .main)
    let (data, response) = try await session.data(for: request)

// Make sure we invalidate the session or memory leaks will occur
    session.finishTasksAndInvalidate()

    //If we have some json issue self.logger.info out the string to see the problem
#if DEBUG
    data.printJSON()
#endif
    return (data, response)
}
```
## Network Repository

Great! Now that you have made it this far, we can use our NetworkWrapper and give it the needed data. Let's create a Network Repository. With this repository, we can call the method in our service that we will create shorty.

```swift
class NetworkRepository: NSObject {

let networkManager = NetworkManager()

/// - Parameters:
///   - loginReq: This is a model that we will feed to our request that contains all the needed data for the auth process.
func asyncLogin(loginReq: Login, reqObject: LoginRequest) async throws -> (Data, URLResponse) {

// Decide if we are https or not
let scheme = loginReq.secureSwitch ? "https" : "http"

// Set our URL
let url = "\(scheme)://\(loginReq.server):\(loginReq.port)/some-end-point"

// Encode our LoginRequest Object
let body = try? JSONEncoder().encode(loginReq.requestLoginObject())

//Make Network Request and handle the response
return try await networkManager.asyncCodableNetworkWrapper(type: LoginResponse.self, urlString: url, httpMethod: "POST", httpBody: body)
}
}
```
## Model Layer

This is an Object with the needed properties that we will pass during our auth flow. We will use the MVVM pattern for this example.

```swift
struct Login: Codable {
    var username: String
    var password: String
    var server: String
    var port: String
    var secureSwitch: Bool
    var useCookies: Bool
    var acceptUntrustedCertificates: Bool
}

```
## URLSessionDelegate

We have one more thing to do in our Network Manager before our setup is done and we can make the Network Request. We need to conform to `URLSessionDelegate` for the Server Authentication process. So, inside of Network Manager, add this code. In simple terms, the server will give us an authentication challenge that we need to respond to. So that is excactly what we will do. Your server may be set up slightly different, so you may need to adjust accordingly.

```swift 
func urlSession(
    _
    session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?
    ) -> Void) {
    
    if challenge.protectionSpace.serverTrust == nil {
        completionHandler(.useCredential, nil)
    } else {
        let trust: SecTrust = challenge.protectionSpace.serverTrust!
        let credential = URLCredential(trust: trust)
        completionHandler(.useCredential, credential)
    }
}
```
## Authentication Services

Finally, we can make the auth call. Inside of your Authentication Service(View Model), or perhaps you will make the call from a ViewController depending on your architecture, you can write something like this.

```swift

// ObservableObject
class AuthenticationService: NSObject, ObservableObject {
    
//@Published variables
    @Published var username = UserDefaults.standard.string(forKey: "Username") ?? ""
    @Published var password = KeychainItem.getPassword
    @Published var server = UserDefaults.standard.string(forKey: "Server") ?? ""
    @Published var port = UserDefaults.standard.string(forKey: "Port") ?? ""
    @Published var secureSwitch = UserDefaults.standard.bool(forKey: "Secure")
    @Published var useCookies = UserDefaults.standard.bool(forKey: "Cookies")
    @Published var acceptUntrustedCertificates = UserDefaults.standard.bool(forKey: "Trust")

@MainActor
func loginUser(networkStatus: Bool) async {

let loginCredentials = Login(
    username: username,
    password: password,
    server: server,
    port: port,
    secureSwitch: secureSwitch,
    useCookies: useCookies,
    acceptUntrustedCertificates: acceptUntrustedCertificates
)

    
    UserDefaults.standard.set(username, forKey: "Username")
    KeychainItem.savePassword(password: password)
    UserDefaults.standard.set(server, forKey: "Server")
    UserDefaults.standard.set(port, forKey: "Port")
    UserDefaults.standard.set(secureSwitch, forKey: "Secure")
    UserDefaults.standard.set(useCookies, forKey: "Cookies")
    UserDefaults.standard.set(acceptUntrustedCertificates, forKey: "Trust")
    
    guard let repository = networkRepository.networkRepositoryDelegate else {return}
    let (data, response) = try? await repository.asyncLogin(loginReq: loginCredentials, reqObject: requestLoginObject())

// handle the payload and catch errors optionally
}
}
```

## SwiftUI Example

Here is an example of how you can make this call from a SwiftUI View.

```swift

struct Authentication: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var server = ""
    @State private var port = ""
    @State private var setSecurity = true
    @State private var setCookies = true
    @State private var setTrust = true

// EnvironmentObject are defined on the @main App entry point and are classes created in other files 

// We use Network Monitor in order to determine if we are connected to the Network or Not 
    @EnvironmentObject var monitor: NetworkMonitor

// Our Authentication Service we created earlier, we must initialize this class first in @main App
    @EnvironmentObject private var authenticationService: AuthenticationService

    
    var parentTabIndex: Int
    
    var body: some View {
        NavigationView  {
            Form {
                Section(header: Text("Credentials")) {
                    VStack(alignment: .leading) {
                        Text("User")
                            .bold()
                        TextField("Enter Username...", text: $authenticationService.username)
                        Divider()
                        Text("Password")
                            .bold()
                        SecureField("Enter Password...", text: $authenticationService.password)
                        Text("Server")
                            .bold()
                        TextField("Enter Server Name...", text: $authenticationService.server)
                        Text("Port")
                            .bold()
                        TextField("8443...", text: $authenticationService.port)
                        
                    }
                }
                Section {
                    VStack(alignment: .leading) {
                        Toggle("Security", isOn: $authenticationService.secureSwitch)
                        Toggle("Use Cookies", isOn: $authenticationService.useCookies)
                        Toggle("Trust All Certs.", isOn: $authenticationService.acceptUntrustedCertificates)
                    }
                }
                Button {
                    Task {
                         // The trigger to fire our call
                        await self.login()
                    }
                } label: {
                    Text("Login")
                }
                .buttonStyle(.borderless)
            }
            .navigationBarTitle("Authentication")
        }
    }

    private func login() async {
        await self.authenticationService.loginUser(networkStatus: monitor.networkStatus())
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
