import ApprovalTests_Swift
@testable import XCGrapherLib
import XCTest

/// `sut` fail to execute `dot`, however we don't care as we are just reading the output text file
final class TwoProductSPMTests: XCTestCase {
  private func sut(_ options: XCGrapherOptions) throws -> String {
    try XCGrapher.run(with: options)
  }

  func testSomeAppSPM() throws {
    // GIVEN we only pass --spm to xcgrapher

    let digraph = try sut(option(apple: true))

    try Approvals.verify(digraph)
  }

  func testSomeAppAppleAndSPM() throws {
    // WHEN we generate a digraph

    let digraph = try sut(option(apple: true, spm: true))

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.apple + KnownEdges.spm + KnownEdges.appleFromSPM

    XCGrapherAssertDigraphIsMadeFromEdges(digraph, expectedEdges)
  }
}

private let root = URL(fileURLWithPath: #file)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appendingPathComponent("SampleProjects")
  .appendingPathComponent("SomePackage_TwoTarget")
  .path

private func option(
  apple: Bool = false,
  spm: Bool = false,
  pods: Bool = false,
  force: Bool = false
) -> XCGrapherOptions {
  .fixture(
    startingPoint: .swiftPackage(root),
    target: "SomePackage",
    apple: apple,
    spm: spm,
    pods: pods,
    force: force
  )
}

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
