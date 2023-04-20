import CustomDump
@testable import XCGrapherLib
import XCTest

@MainActor
final class SwiftPackageMergeTests: XCTestCase {
  func test() async throws {
    XCTAssertNoDifference(
      SwiftPackageManager(
        packages: [
          .init(
            describe: SomePackageDescribe,
            dependency: SomePackageDependency
          ),
        ]
      )
      .swiftPackageMerge(),
      [
        "Core": ["CasePaths"],
        "kingfisher": [],
        "SomePackage": ["Core", "Kingfisher", "Moya", "Alamofire"],
        "SomePackageTests": ["SomePackage"],
        "alamofire": [],
        "moya": ["alamofire", "reactiveswift", "rxswift"],
        "reactiveswift": [],
        "rxswift": [],
      ]
    )
  }
}

struct Lib: Hashable {
  var name: String
  var id: GitId?
}
