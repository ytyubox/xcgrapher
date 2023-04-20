import CustomDump
import Foundation
@testable import XCGrapherLib
import XCTest

@MainActor
final class SPMTests: XCTestCase {
  func testSomePackage() async throws {
    let packageDescription = SomePackageDescribe
    let graph = SwiftPackageManager(packageDescriptions: [packageDescription])
      .groupPackageDescription()

    XCTAssertNoDifference(
      graph,
      [
        "Core": ["CasePaths"],
        "SomePackage": ["Core", "Kingfisher", "Moya", "Alamofire"],
        "SomePackageTests": ["SomePackage"],
      ]
    )
  }
}
