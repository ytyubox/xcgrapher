// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "SomePackage",
  platforms: [
    .macOS(.v10_15),
  ],
  products: [
    .library(
      name: "SomePackage",
      targets: ["SomePackage"]
    ),
    .library(
      name: "Core",
      targets: ["Core"]
    ),
  ],
  dependencies: [
    .package(name: "Kingfisher", url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "6.0.0")),
    .package(name: "Moya", url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0")),
    .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.3")),
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.14.1"),
  ],
  targets: [
    .target(
      name: "SomePackage",
      dependencies: [
        "Kingfisher",
        "Moya",
        "Alamofire",
        "Core",
      ]
    ),
    .target(
      name: "Core",
      dependencies: [
        .product(
          name: "CasePaths",
          package: "swift-case-paths"
        ),
      ]
    ),
    .testTarget(
      name: "SomePackageTests",
      dependencies: ["SomePackage"]
    ),
  ]
)
