import ApprovalTests_Swift
@testable import XCGrapherLib

import XCTest

final class LibTests: XCTestCase {
  func test() throws {
    let options = XCGrapherOptions.fixture(startingPoint: .swiftPackage("Package"), target: "Hello")
  }
}
