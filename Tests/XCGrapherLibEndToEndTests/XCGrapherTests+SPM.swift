import XCTest

@testable import XCGrapherLib

/// `sut` fail to execute `dot`, however we don't care as we are just reading the output text file
final class XCGrapherSPMTests: XCTestCase {
  private var sut: ((XCGrapherOptions) throws -> Void)!
  private var options: XCGrapherOptions!
  let dotfile = "/tmp/xcgrapher.dot"

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = XCGrapher.run
    options = concreteGrapherOptions

    try? FileManager.default.removeItem(atPath: dotfile) // Remove if needed only
    Logger.log = { _ in }
  }

  func testSomeAppSPM() throws {
    // GIVEN we only pass --spm to xcgrapher
    options.spm = true

    // WHEN we generate a digraph
    try sut(options)
    let digraph = try String(contentsOfFile: dotfile)

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.spm

    XCGrapherAssertDigraphIsMadeFromEdges(digraph, expectedEdges)
  }

  func testSomeAppAppleAndSPM() throws {
    // GIVEN we pass --apple and --spm to xcgrapher
    options.apple = true
    options.spm = true

    // WHEN we generate a digraph
    try sut(options)
    let digraph = try String(contentsOfFile: dotfile)

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.apple + KnownEdges.spm + KnownEdges.appleFromSPM

    XCGrapherAssertDigraphIsMadeFromEdges(digraph, expectedEdges)
  }
}

private let concreteGrapherOptions: XCGrapherOptions = {
  var currentDirectory: URL { .init(string: "some.url")! }

  let somePackageRoot = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("SampleProjects")
    .appendingPathComponent("SomePackage")
    .path

  var startingPoint: StartingPoint = .swiftPackage(somePackageRoot)
  var target = "SomePackage"
  var podlock = ""
  var output = "/tmp/xcgraphertests.png"
  var apple = false
  var spm = false
  var pods = false
  var force = false
  var json = false
  var version = false
  return XCGrapherOptions(
    currentDirectory: currentDirectory,
    startingPoint: startingPoint,
    target: target,
    podlock: podlock,
    output: output,
    apple: apple,
    spm: spm,
    pods: pods,
    force: force,
    json: json,
    verbose: true
  )
}()

private enum KnownEdges {
  static let spm = [
    ("SomePackage", "Kingfisher"),
    ("SomePackage", "Moya"),
    ("Moya", "Alamofire"),
    ("SomePackage", "Alamofire"),
  ]

  static let apple = [
    ("SomePackage", "Foundation"),
    ("SomePackage", "CoreGraphics"),
  ]

  static let appleFromSPM: [(String, String)] = [
    ("Alamofire", "Combine"),
    ("Alamofire", "CoreServices"),
    ("Alamofire", "Foundation"),
    ("Alamofire", "MobileCoreServices"),
    ("Alamofire", "SystemConfiguration"),
    ("Kingfisher", "Accelerate"),
    ("Kingfisher", "AppKit"),
    ("Kingfisher", "AVKit"),
    ("Kingfisher", "Combine"),
    ("Kingfisher", "CoreGraphics"),
    ("Kingfisher", "CoreImage"),
    ("Kingfisher", "CoreServices"),
    ("Kingfisher", "Foundation"),
    ("Kingfisher", "ImageIO"),
    ("Kingfisher", "MobileCoreServices"),
    ("Kingfisher", "SwiftUI"),
    ("Kingfisher", "UIKit"),
    ("Moya", "AppKit"),
    ("Moya", "Foundation"),
    ("Moya", "UIKit"),
  ]
}
