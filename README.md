# FCSDKiOS

## System Minimum Requirements ##
* Xcode 13
* Monterey 12.1
* swift-tools-version:5.5
* iOS 12

## Binaries
| **Platform / arch** | arm64  | x86_x64 |
|---------------------|--------|---------|
| **iOS (device)**    |   ✅   |   N/A   |
| **iOS (simulator)** |   ✅   |    ✅   |


#### Please Follow this repository for the lateset SDK notifications.


## Documentation

We are happy to introduce *DocC* documenation for FCSDK_iOS. Simply build the documentaion with **Command + Control + Shift + D** in your app and have all the documentation that you need right in Xcode.

## Getting Started
**Please Read our DocC Documentation for more information**

[Getting Started](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/GettingStarted.md 'Learn Markdown')

[Authentication](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/Authentication.md 'Learn Markdown')

[Creating a Session](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/CreatingSession.md 'Learn Markdown')

[Video Calls](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/VideoCalls.md 'Learn Markdown')

[FCSDKUI](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/FCSDKUI.md 'Learn Markdown')

[VoIP Calls and CallKit](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/VoIPCallsAndCallKit.md 'Learn Markdown')

[AED](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/AED.md 'AED Article')

[FCSDK Extras](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/FCSDKExtras.md 'FCSDK Extras')

[Migrating from the Legacy SDK](https://github.com/cbajapan/fcsdk-ios/blob/main/Sources/FCSDK-iOS/FCSDKiOS.docc/MigratingFromLegacySDK.md 'Learn Markdown')

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

You can import the SDK in your project file like so for
Swift
```swift
import FCSDKiOS
````
Objective-C
```swift
@import FCSDKiOS;
```

