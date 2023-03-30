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
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.0.1"),

  ],
  targets: [
    .executableTarget(
      name: "xcgrapher",
      dependencies: [
        "XCGrapherLib",
        "XCGrapherCLIParser",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .target(
      name: "XCGrapherCLIParser",
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
//    .testTarget(
//      name: "XCGrapherLibEndToEndTests",
//      dependencies: ["XCGrapherLib"]
//    ),

    .testTarget(
      name: "XCGrapherCLIParserTests",
      dependencies: [
        "XCGrapherCLIParser",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ]
    ),
  ]
)
