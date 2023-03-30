//
//  File.swift
//
//
//  Created by Yu Yu on 2023/3/30.
//

import CustomDump
import XCGrapherCLIParser
import XCTest

@MainActor
final class Tests: XCTestCase {
  fileprivate func assert(
    _ args: [String],
    _ expectExitCode: Int32 = 0,
    _ expectMessage: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) throws {
    do {
      _ = try sut(args)
    } catch {
      XCTAssertNoDifference(XCGrapherArguments.exitCode(for: error).rawValue, expectExitCode, file: file, line: line)
      XCTAssertNoDifference(XCGrapherArguments.fullMessage(for: error), expectMessage, file: file, line: line)
    }
  }

  fileprivate func sut(
    _ args: [String],
    file: StaticString = #filePath,
    line: UInt = #line
  ) throws -> XCGrapherArguments {
    XCGrapherArguments.fileExists = { _ in true }
    XCGrapherArguments.directoryExists = { _ in true }
    return try XCGrapherArguments.parse(args)
  }

  func testHelp() async throws {
    let args = ["--help"]
    let expectExitCode: Int32 = 0
    let expectMessage =
      """
      USAGE: xcgrapher <path> --target <target> [--podlock <podlock>] [--output <output>] [--apple] [--spm] [--pods] [--json] [--verbose]

      ARGUMENTS:
        <path>                  The path to the .xcodeproj or Package.swift

      OPTIONS:
        --target <target>       The name of the Xcode project target (or Swift
                                Package product) to use as a starting point
        --podlock <podlock>     The path to the projects Podfile.lock (default:
                                ./Podfile.lock)
        -o, --output <output>   The path to which the output should be written
        --apple                 Include Apple frameworks in the graph (for --target
                                and readable-source --spm packages)
        --spm                   Include Swift Package Manager frameworks in the graph
        --pods                  Include Cocoapods frameworks in the graph
        --json                  Output json
        --verbose               Display verbose information
        --version               Show the version.
        -h, --help              Show help information.

      """
    try assert(args, expectExitCode, expectMessage)
  }

  func testSomeTarget() async throws {
    let args = ["Package.swift", "--target", "SOME"]
    let v = try sut(args)
    XCTAssertNoDifference(v.target, "SOME")
  }

  func testEmptyTarget() async throws {
    let args = ["Package.swift", "--target", ""]
    let expectExitCode: Int32 = 1
    let expectMessage =
      """
      Error: The operation couldn’t be completed. (--target must not be empty. error 1.)
      """
    try assert(args, expectExitCode, expectMessage)
  }
}
