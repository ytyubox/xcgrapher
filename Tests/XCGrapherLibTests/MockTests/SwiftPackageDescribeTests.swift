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
