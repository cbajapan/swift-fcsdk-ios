// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-fcsdk-ios",
    platforms: [.iOS(.v13), .macOS(.v11)],
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
                "CBARealTime"
            ]),
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.1.0.xcframework.zip", checksum: "e27eb181e0b7029341c6bf23315a3f074a2787f558cdcdbfbc70690d51634ccc"),
        .binaryTarget(name: "CBARealTime", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/CBARealTime-m105-1.0.0.xcframework.zip", checksum: "0972ae7dc69b1b531b518d2be406a0c405ea9e0925c51e098f407fb51d58199b")
    ]
)
