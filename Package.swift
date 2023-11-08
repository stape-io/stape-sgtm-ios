// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StapeSDK",    
    platforms: [
        .macOS(.v10_14), .iOS(.v14), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "StapeSDK",
            targets: ["StapeSDK"]),
    ],
    targets: [
        .target(
            name: "StapeSDK",
            path: "StapeSDK/StapeSDK"
    ]
)
