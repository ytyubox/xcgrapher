//
//  File.swift
//
//
//  Created by Yu Yu on 2023/3/30.
//

import ArgumentParser
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
  ) {
    do {
      _ = try XCGrapherArguments.parse(args)
    } catch {
      XCTAssertNoDifference(XCGrapherArguments.exitCode(for: error).rawValue, expectExitCode, file: file, line: line)
      XCTAssertNoDifference(XCGrapherArguments.fullMessage(for: error), expectMessage, file: file, line: line)
    }
  }

  func test() async throws {
    let args = ["--help"]
    let expectExitCode: Int32 = 0
    let expectMessage =
      """
      USAGE: xcgrapher <path> [--target <target>] [--podlock <podlock>] [--output <output>] [--apple] [--spm] [--pods] [--force] [--json] [--verbose]

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
        --force                 Show frameworks that no dependency manager claims to
                                be managing (perhaps there are name discrepancies?).
                                Using this option doesn't make sense unless you are
                                also using all the other include flags relevant to
                                your project.
        --json                  Output json
        --verbose               Display verbose information
        --version               Show the version.
        -h, --help              Show help information.

      """
    assert(args, expectExitCode, expectMessage)
  }
}
