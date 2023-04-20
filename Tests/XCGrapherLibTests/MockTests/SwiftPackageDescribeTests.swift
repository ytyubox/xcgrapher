import CustomDump
import Foundation
@testable import XCGrapherLib
import XCTest

@MainActor
final class SPMTests: XCTestCase {
  func testSomePackage() async throws {
    let packageDescription = try JSONDecoder().decode(PackageDescription.self, from: SomePackageDescribeJSON)
    let package = SwiftPackageManager(packageDescriptions: [packageDescription])
    let g = try package.groupPackageDescription()

    XCTAssertNoDifference(g, [
      "Core": ["CasePaths"],
      "SomePackage": ["Core", "Kingfisher", "Moya", "Alamofire"],
      "SomePackageTests": ["SomePackage"],
    ])
  }
}

private let SomePackageDescribeJSON =
  """
  {
    "dependencies" : [
      {
        "identity" : "kingfisher",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "6.0.0",
              "upper_bound" : "7.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/onevcat/Kingfisher.git"
      },
      {
        "identity" : "moya",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "14.0.0",
              "upper_bound" : "15.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/Moya/Moya.git"
      },
      {
        "identity" : "alamofire",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "5.4.3",
              "upper_bound" : "6.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/Alamofire/Alamofire.git"
      },
      {
        "identity" : "swift-case-paths",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.14.1",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-case-paths"
      }
    ],
    "manifest_display_name" : "SomePackage",
    "name" : "SomePackage",
    "path" : "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage_TwoTarget",
    "platforms" : [
      {
        "name" : "macos",
        "version" : "10.15"
      }
    ],
    "products" : [
      {
        "name" : "SomePackage",
        "targets" : [
          "SomePackage"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "Core",
        "targets" : [
          "Core"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      }
    ],
    "targets" : [
      {
        "c99name" : "SomePackageTests",
        "module_type" : "SwiftTarget",
        "name" : "SomePackageTests",
        "path" : "Tests/SomePackageTests",
        "sources" : [
          "SomePackageTests.swift",
          "XCTestManifests.swift"
        ],
        "target_dependencies" : [
          "SomePackage"
        ],
        "type" : "test"
      },
      {
        "c99name" : "SomePackage",
        "module_type" : "SwiftTarget",
        "name" : "SomePackage",
        "path" : "Sources/SomePackage",
        "product_dependencies" : [
          "Kingfisher",
          "Moya",
          "Alamofire"
        ],
        "product_memberships" : [
          "SomePackage"
        ],
        "sources" : [
          "AppleImports.swift",
          "CoreImports.swift",
          "DependencyImports.swift",
          "SomePackage.swift"
        ],
        "target_dependencies" : [
          "Core"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Core",
        "module_type" : "SwiftTarget",
        "name" : "Core",
        "path" : "Sources/Core",
        "product_dependencies" : [
          "CasePaths"
        ],
        "product_memberships" : [
          "SomePackage",
          "Core"
        ],
        "sources" : [
          "Core.swift"
        ],
        "type" : "library"
      }
    ],
    "tools_version" : "5.3"
  }

  """.data(using: .utf8)!
