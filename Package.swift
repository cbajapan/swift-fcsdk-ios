// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-fcsdk-ios",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "FCSDKiOS",
            type: .static,
            targets: ["SwiftFCSDKiOS"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftFCSDKiOS",
            dependencies: [
                "FCSDKiOS",
                "WebRTC"
            ]),
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.3.6-beta4.xcframework.zip", checksum: "5ae64f1a2675c2e72e9be7260d51012071ab4a84be5c84c1ceee1113266ec532"),
        .binaryTarget(name: "WebRTC", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/WebRTC-m130.xcframework.zip", checksum: "b6ba196509dc0a2217f7a940beb1236e29c2f4f7a5cbd51dfdd892ccae0c9f41")
    ]
)
