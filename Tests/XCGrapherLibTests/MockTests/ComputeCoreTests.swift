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

  func testFilesApple() async throws {
    XCTAssertNoDifference(
      try ComputeCore(nativeManager: .init())
        .generateDigraph(
          title: "title",
          target: "some",
          projectSourceFiles: [
            "import Foundation",
          ]
        ),
      Digraph(
        name: "title",
        edges: [.init(a: "some", b: "Foundation", tags: "apple")]
      )
    )
  }

  func testSPM() async throws {
    XCTAssertNoDifference(
      try ComputeCore(swiftPackageManager: .init(
        packageDescriptions: [
          .init(
            name: "some",
            path: "",
            _targets:
            [
              .init(
                name: "A",
                path: "",
                sources:
                [
                  "import B",
                ],
                type: ""
              ),
              .init(
                name: "B",
                path: "",
                sources: [],
                type: ""
              ),
            ]
          ),
        ]
      ))
      .generateDigraph(
        title: "title",
        target: "some",
        projectSourceFiles: [
          "import A",
        ]
      ),
      Digraph(
        name: "title",
        edges: [
          .init(a: "A", b: "B", tags: "spm"),
          .init(a: "some", b: "A", tags: "spm"),
        ]
      )
    )
  }

  func testCocoaPods() async throws {
    XCTAssertNoDifference(
      try ComputeCore(cocoapodsManager: .init(
        lockFile:
        """
        PODS:
          - A (1)
        """
      ))
      .generateDigraph(
        title: "title",
        target: "some",
        projectSourceFiles: [
          "import A",
        ]
      ),
      Digraph(
        name: "title",
        edges: [
          .init(a: "some", b: "A", tags: "cocoapods"),
        ]
      )
    )
  }
}
