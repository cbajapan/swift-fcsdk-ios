// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-fcsdk-ios",
    products: [
        .library(
            name: "SwiftFCSDKiOS",
            type: .static,
            targets: ["SwiftFCSDKiOS"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftFCSDKiOS",
            dependencies: [
                "FCSDKiOS",
                "CBARealTime"
            ]),
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.0.0-rc.1.2.10.xcframework.zip", checksum: "a9bb46ecd7be832a4a2e8a7e8d4d0b03514dfd76c52a73d591de0af4e9ed2b6a"),
        .binaryTarget(name: "CBARealTime", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/CBARealTime-m95-1.0.1.xcframework.zip", checksum: "b40b7d5b08dbe11f18d60779ffb0cd6576e8e45069d22d81b016a23db88a9633")
    ]
    
)
