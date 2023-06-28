// swift-tools-version:5.5
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
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.2.3.xcframework.zip", checksum: "a6b7a2e7518f4d3fb6955ac8af372fa864895ee2e35dbc716a55f75f8c6d3a62"),
        .binaryTarget(name: "WebRTC", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/WebRTC-m110.xcframework.zip", checksum: "2750cf1087b2441d67208ca2b0905578b4ad1797a68d2d2758d0f075500f0011")
    ]
)
