//
//  File.swift
//
//
//  Created by Yu Yu on 2023/4/13.
//

import CustomDump
@testable import XCGrapherLib
import XCTest

@MainActor
final class ATests: XCTestCase {
  func testEmpty() async throws {
    XCTAssertNoDifference(
      try ComputeCore()
        .generateDigraph(title: "title", target: "some", projectSourceFiles: []),
      Digraph(name: "title")
    )
  }

  func testFiles() async throws {
    XCTAssertNoDifference(
      try ComputeCore()
        .generateDigraph(
          title: "title",
          target: "some",
          projectSourceFiles: [
            "import Foundation",
          ]
        ),
      Digraph(name: "title")
    )
  }
}
