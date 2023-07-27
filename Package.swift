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
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.2.5.xcframework.zip", checksum: "d9e5c98d0586d061b07196949921a7a73b1ceb88a393bc8334afefd451c5f254"),
        .binaryTarget(name: "WebRTC", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/WebRTC-m110.xcframework.zip", checksum: "2750cf1087b2441d67208ca2b0905578b4ad1797a68d2d2758d0f075500f0011")
    ]
)
