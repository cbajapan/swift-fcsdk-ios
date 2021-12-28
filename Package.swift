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
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.0.0-rc.1.1.xcframework.zip", checksum: "dfac85a9109d2510fb5b9e9fb965652599aedabc5624d82477a9c1c62bac8563"),
        .binaryTarget(name: "CBARealTime", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/CBARealTime-m95-1.0.0.xcframework.zip", checksum: "c3a026003fd9f084cadc6519fe9fa2cec845d1477432b203407179690976078e")
    ]
    
)
