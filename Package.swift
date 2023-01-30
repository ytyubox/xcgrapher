// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "xcgrapher",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "xcgrapher", targets: ["xcgrapher"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        .executableTarget(
            name: "xcgrapher",
            dependencies: [
                "XCGrapherLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "XCGrapherLib" // Main source added to a separate framework for testability reasons
        ),
        .testTarget(
            name: "XCGrapherLibTests",
            dependencies: ["XCGrapherLib"]
        ),
    ]
)
