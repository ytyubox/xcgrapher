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

    let digraph = try sut(option(spm: true))

    try Approvals.verify(digraph)
  }

  func testSomeAppAppleAndSPM() throws {
    // WHEN we generate a digraph

    let digraph = try sut(option(apple: true, spm: true))

    try Approvals.verify(digraph)
  }

  func test_SPMRaw_ComputeCheckoutsDirectory() throws {
    let builder = SwiftBuild(packagePath: root, product: "SomePackage")
    try Approvals.verify(builder.computeCheckoutsDirectory())
  }

  func test_SPMRaw_swiftPackageDependencies() throws {
    let builder = SwiftBuild(packagePath: root, product: "SomePackage")
    try Approvals.verify(builder.swiftPackageDependencies().lines)
  }

  func test_SPMRaw_MainSwiftPackageDescriptionJSON() throws {
    let json = try SwiftPackage(clone: root)
      .execute()

    try Approvals.verify(json)
  }

  func test_SPMRaw_SwiftPackageDescriptionJSONs() throws {
    let builder = SwiftBuild(packagePath: root, product: "SomePackage")

    let packageDescriptions = try builder.swiftPackageDependencies()
      .map(SwiftPackage.init)
      .map {
        let json = try $0.execute()
        return $0.clone + "\n" + json
      }

    try Approvals.verify(packageDescriptions.lines)
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
