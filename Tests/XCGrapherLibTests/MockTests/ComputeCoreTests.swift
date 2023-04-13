//
//  File.swift
//
//
//  Created by Yu Yu on 2023/4/13.
//

@testable import XCGrapherLib
import XCTest

@MainActor
final class ATests: XCTestCase {
  func test() async throws {
    try ComputeCore()
      .generateDigraph(target: "some", projectSourceFiles: [])
  }
}
