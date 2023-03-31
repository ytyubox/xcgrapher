//
//  File.swift
//
//
//  Created by Yu Yu on 2023/3/30.
//

import CustomDump
import XCGrapherCLIParser
import XCGrapherLib
import XCTest

@MainActor
final class XCGrapherArgumentsTests: XCTestCase {
  fileprivate func assert(
    _ args: [String],
    _ expectExitCode: Int32 = 0,
    _ expectMessage: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) throws {
    do {
      _ = try sut(args)
      XCTFail("expect to fail to parse success", file: file, line: line)
    } catch {
      XCTAssertNoDifference(XCGrapherArguments.exitCode(for: error).rawValue, expectExitCode, file: file, line: line)
      XCTAssertNoDifference(XCGrapherArguments.fullMessage(for: error), expectMessage, file: file, line: line)
    }
  }

  fileprivate func sut(
    _ args: [String],
    file: StaticString = #filePath,
    line: UInt = #line
  ) throws -> XCGrapherOptions {
    return try XCGrapherArguments.parse(args).options
  }

  override func setUpWithError() throws {
    XCGrapherArguments.fileExists = { _ in true }
    XCGrapherArguments.directoryExists = { _ in true }
    XCGrapherArguments.currentDirectory = { anyURL }
  }

  func testVersion() async throws {
    let args = ["--version"]
    let expectExitCode: Int32 = 0
    let expectMessage =
      """
      0.0.14
      """
    try assert(args, expectExitCode, expectMessage)
  }

  func testHelp() async throws {
    let args = ["--help"]
    let expectExitCode: Int32 = 0
    let expectMessage =
      """
      USAGE: xcgrapher <path> --target <target> [--podlock <podlock>] [--output <output>] [--apple] [--spm] [--pods] [--force] [--json] [--verbose]

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

    try assert(args, expectExitCode, expectMessage)
  }

  func testEmptyPath() async throws {
    let args = ["", "--target", "SOME"]
    try assert(
      args,
      1,
      """
      Error: The operation couldn’t be completed. (--project or --package must be provided. error 1.)
      """
    )
  }

  func testFailPath() async throws {
    XCGrapherArguments.fileExists = { _ in false }
    let args = ["SOME/Package.swift", "--target", "SOME"]
    try assert(
      args,
      1,
      """
      Error: The operation couldn’t be completed. ('SOME/Package.swift' is not a valid Swift Package. error 1.)
      """
    )
  }

  func testXcodeprojSomeTarget() async throws {
    let args = ["SOME.xcodeproj", "--target", "SOME"]
    let v = try sut(args)
    XCTAssertNoDifference(
      v,
      .init(
        currentDirectory: anyURL,
        startingPoint: .xcodeProject("SOME.xcodeproj"),
        target: "SOME",
        podlock: "./Podfile.lock",
        output: "",
        apple: true,
        spm: false,
        pods: false,
        force: false,
        json: false,
        verbose: false
      )
    )
  }

  func testPackageSomeTarget() async throws {
    let args = ["Package.swift", "--target", "SOME"]
    let v = try sut(args)
    XCTAssertNoDifference(
      v,
      .init(
        currentDirectory: anyURL,
        startingPoint: .swiftPackage("."),
        target: "SOME",
        podlock: "./Podfile.lock",
        output: "",
        apple: true,
        spm: false,
        pods: false,
        force: false,
        json: false,
        verbose: false
      )
    )
  }

  func testSubfolderPackageSomeTarget() async throws {
    let args = ["SOME/Package.swift", "--target", "SOME"]
    let v = try sut(args)
    XCTAssertNoDifference(
      v,
      .init(
        currentDirectory: anyURL,
        startingPoint: .swiftPackage("SOME"),
        target: "SOME",
        podlock: "./Podfile.lock",
        output: "",
        apple: true,
        spm: false,
        pods: false,
        force: false,
        json: false,
        verbose: false
      )
    )
  }

  func testSomeTargetOnySPM() async throws {
    let args = ["Package.swift", "--target", "SOME", "--spm"]
    let v = try sut(args)
    XCTAssertNoDifference(
      v,
      .init(
        currentDirectory: anyURL,
        startingPoint: .swiftPackage("."),
        target: "SOME",
        podlock: "./Podfile.lock",
        output: "",
        apple: false,
        spm: true,
        pods: false,
        force: false,
        json: false,
        verbose: false
      )
    )
  }

  func testEmptyTarget() async throws {
    let args = ["Package.swift", "--target", ""]
    let expectExitCode: Int32 = 64
    let expectMessage =
      """
      Error: The value '' is invalid for '--target <target>': Error Domain=--target must not be empty. Code=1 "(null)"
      Help:  --target <target>  The name of the Xcode project target (or Swift Package product) to use as a starting point
      Usage: xcgrapher <path> --target <target> [--podlock <podlock>] [--output <output>] [--apple] [--spm] [--pods] [--force] [--json] [--verbose]
        See 'xcgrapher --help' for more information.
      """
    try assert(args, expectExitCode, expectMessage)
  }
}

private var anyURL = URL(string: "any.url")!
