# Swift FCSDK iOS

## System Minimum Requirements ##
* Xcode 13
* Monterey 12.1
* swift-tools-version:5.5
* iOS 13

## Binaries
| **Platform / arch** | arm64  | x86_x64 |
|---------------------|--------|---------|
| **iOS (device)**    |   ✅   |   N/A   |
| **iOS (simulator)** |   ✅   |    ✅   |


#### Please Follow this repository for the lateset SDK notifications.


## Documentation

We are happy to introduce *DocC* documenation for SwiftFCSDKiOS. Simply build the documentaion with **Command + Control + Shift + D** in your app and have all the documentation that you need right in Xcode.

## Version Changes
[Version 4.2.1 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.1.md 'Version 4.2.1')

[Version 4.2.0 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.2.0.md 'Version 4.2.0')

[Version 4.1.0 ](https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Sources/SwiftFCSDKiOS/SwiftFCSDKiOS.docc/Version-4.1.0.md 'Version 4.1.0')

## Getting Started
**Please Read our DocC Documentation for more information**

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
    3. Choose which version you would like to checkout(i.e. 4.0.0-beta.1.0)
    4. Make sure the binary is linked in your Xcode Project via the target ``Target -> Build Phases -> Linked Binary``.

 If you want to depend on FCSDKiOS in your own project using SPM, it's as simple as adding a `dependencies` clause to your `Package.swift`:


```swift
dependencies: [
    .package(url: "https://github.com/cbajapan/fcsdk-ios.git", from: "4.0.0")
]
```

## CocoaPods ##

Starting in version 4.2.0 of FCSDKiOS we are supporting CocoaPods as a delivery mechanism.

In order to use our CocoaPod please follow the following instructions.

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
7. You now will use the **.xcworkspace** instead of **.xcodeproj** as a project source.

## Import the SDK into your project ##
Swift
```swift
import FCSDKiOS
````
Objective-C
```swift
@import FCSDKiOS;
```
