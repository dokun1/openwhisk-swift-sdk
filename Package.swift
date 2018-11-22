// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "openwhisk-swift-sdk",
    products: [
        .library(
            name: "openwhisk-swift-sdk",
            targets: ["openwhisk-swift-sdk"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/CircuitBreaker.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/IBM-Swift/LoggerAPI.git", .upToNextMajor(from: "1.7.3")),
        .package(url: "https://github.com/IBM-Swift/SwiftyRequest.git", .upToNextMajor(from: "2.0.1"))
    ],
    targets: [
        .target(
            name: "openwhisk-swift-sdk",
            dependencies: ["CircuitBreaker", "LoggerAPI", "SwiftyRequest"]
        ),
        .testTarget(
            name: "openwhisk-swift-sdkTests",
            dependencies: ["openwhisk-swift-sdk"]
        )
    ]
)
