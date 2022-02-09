// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fcsdk-ios",
    products: [
        .library(
            name: "FCSDK-iOS",
            type: .static,
            targets: ["FCSDK-iOS"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FCSDK-iOS",
            dependencies: [
                "FCSDKiOS",
                "CBARealTime"
            ]),
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.0.0-rc.1.2.6.xcframework.zip", checksum: "d7c0c85fb7758b846747b0ce423173135900ffcb32c3f096b0514504aa4e91bc"),
        .binaryTarget(name: "CBARealTime", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/CBARealTime-m95-1.0.1.xcframework.zip", checksum: "b40b7d5b08dbe11f18d60779ffb0cd6576e8e45069d22d81b016a23db88a9633")
    ]
    
)
