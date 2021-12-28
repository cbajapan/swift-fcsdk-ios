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


### We are currently in Beta for this SDK. Therefore, only limited functionality or features may be available upon Betas and Release Candidates. 

#### Please check this repository regularly for beta releases.


## Documentation

We are happy to introduce *DocC* documenation for FCSDK_iOS. Simply build the documentaion with **Command + Control + Shift + D** in your app and have all the documentation that you need right in Xcode.

## Getting Started

## Swift Package Manager ##

    1. In your Xcode Project, select File > Swift Packages > Add Package Dependency.
    2. Follow the prompts using the URL for this repository
    3. Choose which version you would like to checkout(i.e. 4.0.0-beta.1.0)

 If you want to depend on FCSDKiOS in your own project using SPM, it's as simple as adding a `dependencies` clause to your `Package.swift`:


```swift
dependencies: [
    .package(url: "https://github.com/cbajapan/fcsdk-ios.git", from: "4.0.0")
]
```




