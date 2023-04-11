import XCTest

@testable import XCGrapherLib

/// `sut` fail to execute `dot`, however we don't care as we are just reading the output text file
final class XCGrapherSPMTests: XCTestCase {
  private var sut: ((XCGrapherOptions) throws -> String)!
  private var options: XCGrapherOptions!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = XCGrapher.run
    options = concreteGrapherOptions
  }

  func testSomeAppSPM() throws {
    // GIVEN we only pass --spm to xcgrapher
    options.spm = true

    // WHEN we generate a digraph
    let digraph = try sut(options)

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.spm

    XCGrapherAssertDigraphIsMadeFromEdges(digraph, expectedEdges)
  }

  func testSomeAppAppleAndSPM() throws {
    // GIVEN we pass --apple and --spm to xcgrapher
    options.apple = true
    options.spm = true

    // WHEN we generate a digraph

    let digraph = try sut(options)

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.apple + KnownEdges.spm + KnownEdges.appleFromSPM

    XCGrapherAssertDigraphIsMadeFromEdges(digraph, expectedEdges)
  }
}

private let somePackageRoot = URL(fileURLWithPath: #file)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appendingPathComponent("SampleProjects")
  .appendingPathComponent("SomePackage")
  .path

private let concreteGrapherOptions: XCGrapherOptions = {
  var currentDirectory: URL { .init(string: "some.url")! }

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
    ("Kingfisher", "AVKit"),
    ("Kingfisher", "Accelerate"),
    ("Kingfisher", "AppKit"),
    ("Kingfisher", "Combine"),
    ("Kingfisher", "CoreGraphics"),
    ("Kingfisher", "CoreImage"),
    ("Kingfisher", "CoreServices"),
    ("Kingfisher", "Foundation"),
    ("Kingfisher", "ImageIO"),
    ("Kingfisher", "MobileCoreServices"),
    ("Kingfisher", "SwiftUI"),
    ("Kingfisher", "TVUIKit"),
    ("Kingfisher", "UIKit"),
    ("Kingfisher", "WatchKit"),
    ("Moya", "AppKit"),
    ("Moya", "Foundation"),
    ("Moya", "UIKit"),
  ]
}
