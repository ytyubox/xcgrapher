//
//  AppleFrameworksTests
//
//
//  Created by Yu Yu on 2023/4/10.
//

import ApprovalTests_Swift
import Foundation
@testable import XCGrapherLib
import XCTest

final class AppleFrameworksTests: XCTestCase {
  func test() throws {
    let all = try NativeDependencyManager().allNativeFrameworks.sorted { $0.lowercased() < $1.lowercased() }.joined(separator: "\n")
    try Approvals.verify(all)
  }
}
