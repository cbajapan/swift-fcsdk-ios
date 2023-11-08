# Swift FCSDK iOS

## System Minimum Requirements ##
* Xcode 14
* Ventura 13.0
* swift-tools-version: 5.7
* iOS 14

## Binaries
| **Platform / arch** | arm64  | x86_x64 |
|---------------------|--------|---------|
| **iOS (device)**    |   ✅   |   N/A   |
| **iOS (simulator)** |   ✅   |    ✅   |

**Important Notice**

While our SDK may work on older operating systems, we only support the system minimum requirements. The system minimum requirements indicate what is available on the current latest release. Each release is cut at a commit of our SDK. That commit may support other system minimum version requirements. We do not make changes to older versions. We improve and support on top of the latest version released.


Applications developed with FCSDKiOS are compatible on operating systems running iOS 14 and later. Due to our operating system availability, restrictions on devices that support iOS 14 and greater can be used.

You may see different specs located in the `Package.swift` file or the `FCSDKiOS.podspec`. This does not mean we support a lower operating system. This is allowed in order to allow applications to import our SDK, but not use it at compile or run time with the appropriate checks in the applications code base. Some applications may wish to support older operating systems and only use FCSDKiOS if the application running it is an approved operating system.

If you are having issues on an unsupported operating system, please either upgrade you application's minimum verion or exclude the SDK on the said version.

#### Please follow this repository for the latest SDK notifications.


## Documentation

We are happy to introduce *DocC* documentation for SwiftFCSDKiOS. Simply build the documentation with **Command + Control + Shift + D** in your app and have all the documentation that you need right in Xcode.

## Version Changes
[Version 4.2.6 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.6.md 'Version 4.2.6')

[Version 4.2.5 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.5.md 'Version 4.2.5')

[Version 4.2.4 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.4.md 'Version 4.2.4')

[Version 4.2.3 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.3.md 'Version 4.2.3')

[Version 4.2.2 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.2.md 'Version 4.2.2')

[Version 4.2.1 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.1.md 'Version 4.2.1')

[Version 4.2.0 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.0.md 'Version 4.2.0')

[Version 4.1.0 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.1.0.md 'Version 4.1.0')

## Getting Started
**Please read our DocC Documentation for more information**

[Getting Started](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/GettingStarted.md 'Getting Started')

[Authentication](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Authentication.md 'Authentication')

[Creating a Session](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/CreatingSession.md 'Creating Session')

[Video Calls](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/VideoCalls.md 'Video Calls')

[FCSDKUI](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/FCSDKUI.md 'FCSDK UI')

[VoIP Calls and CallKit](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/VoIPCallsAndCallKit.md 'VoIP Calls And CallKit')

[AED](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/AED.md 'AED Article')

[FCSDK Extras](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/FCSDKExtras.md 'FCSDK Extras')

[Migrating from the Legacy SDK](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/MigratingFromLegacySDK.md 'Learn Markdown')

## Swift Package Manager ##

    1. In your Xcode Project, select File > Swift Packages > Add Package Dependency.
    2. Follow the prompts using the URL for this repository
    3. Choose which version you would like to check out (i.e. 4.0.0-beta.1.0)
    4. Make sure the binary is linked in your Xcode Project via the target ``Target -> Build Phases -> Linked Binary``.

 If you want to depend on FCSDKiOS in your own project using SPM, it's as simple as adding a `dependencies` clause to your `Package.swift`:


```swift
dependencies: [
    .package(url: "https://github.com/cbajapan/swift-fcsdk-ios.git", from: "4.0.0")
]
```

There may be some struggles updating **FCSDKiOS** versions or resolving the package due to Xcode and SPM caching the Package at times, this is normal behavior in iOS development with BinaryTargets in a SwiftPackage. Here is a list of trouble shooting steps you may follow.

Under File -> Packages. you will find 3 options
    * Reset Package Cache
    * Resolve Package Versions
    * Update To Latest Package Versions
    
It is always a good idea to -
    1. Clean the build folder
    2. *Resolve Package Versions*
    3. If that fails, then *Reset Package Cache*

While Updating the version if you run into similar issues try and...
    1. Clean the build folder
    2. *Update Package Versions*
    
If you still have issues then -
    1. Remove the package from the dependencies
    2. Clean the build folder
    3. Close Xcode
    4. Delete Derived Data for the project
    5. Open Xcode
    6. Re-add FCSDKiOS
    
**It is important to note that if your project has a compiler error stating that it cannot find the Module, then you should make sure that the package is linked in the App's Target's Build Phases section.**


## CocoaPods ##

Starting in version 4.2.0 of FCSDKiOS we are supporting CocoaPods as a delivery mechanism.

In order to use our CocoaPod, please follow the following instructions.

1. Navigate to your project 
2. Run `pod init`
3. Run `open -a Xcode Podfile`
4. Edit the Podfile as indicated below

```
source 'https://github.com/cbajapan/swift-fcsdk-ios'

target 'CBAFusion' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CBAFusion
pod 'FCSDKiOS', '~> 4.2.0'
pod 'WebRTC', '~> 110.0.0'
end
```
5. Close the Podfile
6. Run `pod install`
7. You will now use the **.xcworkspace** instead of **.xcodeproj** as a project source.

**NOTE:** If you have trouble installing or updating the CocoaPod, you may have an issue with the local pod repo.

*If that is the case, please try running the following Pod Commands*

```
sudo rm -rf ~/.cocoapods/repos/cbajapan-swift-fcsdk-ios
pod setup
pod install
```

Afterwards, you can run the install or update command again

```
pod install
```

## Import the SDK into your project ##
Swift
```swift
import FCSDKiOS
````
Objective-C
```swift
@import FCSDKiOS;
```
