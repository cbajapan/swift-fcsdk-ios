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
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.0.0-rc.1.xcframework.zip", checksum: "1c2ccf0a5058d149792b3fb4c598ca3147f7e87718e753c465d3c799aeb4173c"),
        .binaryTarget(name: "CBARealTime", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/CBARealTime-m90.xcframework.zip", checksum: "f414904459259437ab1bbb457d670940d3277f8e71a1d36e9f0b8758910ee754")
    ]
    
)
