// swift-tools-version:5.7

import Foundation
import PackageDescription

var package = Package(
  name: "xcgrapher",
  platforms: [
    .macOS(.v10_15),
  ],
  products: [
    .executable(name: "xcgrapher", targets: ["xcgrapher"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.2.0"),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.0.1"),
    .package(url: "https://github.com/approvals/ApprovalTests.Swift", from: "2.0.0"),

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
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ]
    ),
    .target(
      name: "XCGrapherLib" // Main source added to a separate framework for testability reasons
    ),
    .testTarget(
      name: "XCGrapherLibTests",
      dependencies: [
        "XCGrapherLib",
        "ApprovalTests.Swift",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ]
    ),
    .testTarget(
      name: "XCGrapherCLIParserTests",
      dependencies: [
        "XCGrapherCLIParser",
        .product(name: "CustomDump", package: "swift-custom-dump"),
        "ApprovalTests.Swift",
      ]
    ),
  ]
)

if true || ProcessInfo.processInfo.environment["END_TO_END_TEST"] != nil {
  package.targets.append(
    .testTarget(
      name: "XCGrapherLibEndToEndTests",
      dependencies: [
        "XCGrapherLib",
        .product(name: "CustomDump", package: "swift-custom-dump"),
        "ApprovalTests.Swift",
      ]
    )
  )
}
