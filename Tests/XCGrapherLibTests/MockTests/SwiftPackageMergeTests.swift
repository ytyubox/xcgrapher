import CustomDump
@testable import XCGrapherLib
import XCTest

@MainActor
final class SwiftPackageMergeTests: XCTestCase {
  func test() async throws {
    XCTAssertNoDifference(
      SwiftPackageManager(
        package:
        .init(
          describe: SomePackageDescribe,
          dependency: SomePackageDependency
        ),
        otherPackageDescriptions: [
          moyaPackageDescribe,
        ]
      )
      .swiftPackageMerge(),
      [
        "Core": ["CasePaths"],
        "SomePackage": ["Core", "Kingfisher", "Moya", "Alamofire"],
        "SomePackageTests": ["SomePackage"],
        "Moya": ["Moya", "ReactiveMoya", "RxMoya"],
      ]
    )
  }
}

struct Lib: Hashable {
  var name: String
  var id: GitId?
}
