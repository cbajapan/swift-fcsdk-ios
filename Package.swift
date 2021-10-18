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
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.0.0-beta.1.0.xcframework.zip", checksum: "cb43d54cca7399b0d91e516c3aaa26e1072b21232cc6e1dd5ded4ec524c87b86"),
        .binaryTarget(name: "CBARealTime", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/CBARealTime-m90.xcframework.zip", checksum: "f414904459259437ab1bbb457d670940d3277f8e71a1d36e9f0b8758910ee754")
    ]
    
)
