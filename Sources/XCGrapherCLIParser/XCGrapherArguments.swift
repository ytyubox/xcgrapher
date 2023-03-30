import ArgumentParser
import Foundation
import XCGrapherLib

/// Needs this name for `ParsableArguments`'s help text to be correct
public struct XCGrapherArguments: ParsableCommand {
  public static var configuration = CommandConfiguration(commandName: "xcgrapher", version: "0.0.13")
  public static var fileExists: (String) -> Bool = { path in
    FileManager.default.directoryExists(atPath: path)
  }

  public static var directoryExists: (String) -> Bool = { path in
    FileManager.default.directoryExists(atPath: path)
  }

  public static var currentDirectory: () -> URL = {
    URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
      .standardizedFileURL
  }

  public init() {}
  @Argument(help: "The path to the .xcodeproj or Package.swift")
  public var path: String
  @Option(
    name: .long,
    help: "The name of the Xcode project target (or Swift Package product) to use as a starting point",
    transform: targetGuarding
  )
  public var target: String

  @Option(name: .long, help: "The path to the projects Podfile.lock")
  public var podlock: String = "./Podfile.lock"

  @Option(name: .shortAndLong, help: "The path to which the output should be written")
  public var output: String = ""

  @Flag(name: .long, help: "Include Apple frameworks in the graph (for --target and readable-source --spm packages)")
  public var apple: Bool = false

  @Flag(name: .long, help: "Include Swift Package Manager frameworks in the graph")
  public var spm: Bool = false

  @Flag(name: .long, help: "Include Cocoapods frameworks in the graph")
  public var pods: Bool = false

  @Flag(name: .long, help: "Output json")
  public var json: Bool = false

  @Flag(name: .long, help: "Display verbose information")
  public var verbose: Bool = false

  var startingPoint: StartingPoint {
    if path.hasSuffix("Package.swift") {
      return .swiftPackage(path)
    } else {
      return .xcodeProject(path)
    }
  }

  public func validate() throws {
    if path.hasSuffix(".xcodeproj") {
      guard Self.directoryExists(path) else { throw die("'\(path)' is not a valid xcode project.") }
      if (spm || apple || pods) == false {
        print("no dependency set, run with --apple")
      }
    } else if path.hasSuffix("Package.swift") {
      guard Self.fileExists(path) else { throw die("'\(path)' is not a valid Swift Package") }
    } else {
      throw die("--project or --package must be provided.")
    }
  }
}

public extension XCGrapherArguments {
  var computedApple: Bool {
    apple || (pods || spm) == false
  }

  var options: XCGrapherOptions {
    .init(
      currentDirectory: Self.currentDirectory(),
      startingPoint: startingPoint,
      target: target,
      podlock: podlock,
      output: output,
      apple: computedApple,
      spm: spm,
      pods: pods,
      json: json,
      verbose: verbose
    )
  }
}

func targetGuarding(input: String) throws -> String {
  if input.isEmpty {
    throw die("--target must not be empty")
  }
  return input
}
