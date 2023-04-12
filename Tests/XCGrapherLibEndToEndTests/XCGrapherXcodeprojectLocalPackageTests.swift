import ApprovalTests_Swift
import CustomDump
@testable import XCGrapherLib
import XCTest

/// `sut` fail to execute `dot`, however we don't care as we are just reading the output text file
final class XCGrapherXcodeprojLocalPackageTests: XCTestCase {
  private func sut(_ options: XCGrapherOptions) throws -> String {
    try XCGrapher.run(with: options)
  }

  func testXcodeprojGetLocalPackages() throws {
    let packages = try XcodeprojGetLocalPackages(projectFile: ConcreteGrapherOptions.startingPoint.path)
      .localPackages()
    XCTAssertNoDifference(
      packages.map(\.lastPathComponent),
      ["SomeAppCore"]
    )
  }

  func testSomeAppPods() throws {
    let digraph = try sut(
      .fixture(
        startingPoint: .xcodeProject(root.appendingPathComponent("SomeApp.xcodeproj")),
        target: "SomeApp",
        podlock: root.appendingPathComponent("Podfile.lock"),
        pods: true
      )
    )

    try Approvals.verify(digraph)
  }

  func testSomeAppSPM() throws {
    // GIVEN we only pass --apple to xcgrapher

    // WHEN we generate a digraph

    let digraph = try sut(
      .fixture(
        startingPoint: .xcodeProject(root.appendingPathComponent("SomeApp.xcodeproj")),
        target: "SomeApp",
        spm: true
      )
    )

    try Approvals.verify(digraph)
  }

  func testSomeAppApple() throws {
    // GIVEN we only pass --apple to xcgrapher

    // WHEN we generate a digraph

    let digraph = try sut(
      .fixture(
        startingPoint: .xcodeProject(root.appendingPathComponent("SomeApp.xcodeproj")),
        target: "SomeApp",
        apple: true
      )
    )

    try Approvals.verify(digraph)
  }

  func testSomeAppAppleAndSPM() throws {
    // GIVEN we pass --apple and --spm to xcgrapher
    let digraph = try sut(
      .fixture(
        startingPoint: .xcodeProject(root.appendingPathComponent("SomeApp.xcodeproj")),
        target: "SomeApp",
        apple: true,
        spm: true
      )
    )

    try Approvals.verify(digraph)
  }

  func testSomeAppAppleAndSPMAndPods() throws {
    // GIVEN we pass --apple and --spm and --pods to xcgrapher

    let digraph = try sut(
      .fixture(
        startingPoint: .xcodeProject(root.appendingPathComponent("SomeApp.xcodeproj")),
        target: "SomeApp",
        podlock: root.appendingPathComponent("Podfile.lock"),
        apple: true,
        spm: true,
        pods: true
      )
    )
    try Approvals.verify(digraph)
  }
}

private let root = URL(fileURLWithPath: #file)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appendingPathComponent("SampleProjects")
  .appendingPathComponent("SomeAppWithLocalPackage")
  .path
private let ConcreteGrapherOptions: XCGrapherOptions = .init(
  currentDirectory: .init(string: "some.url")!,
  startingPoint: .xcodeProject(root.appendingPathComponent("SomeApp.xcodeproj")),
  target: "SomeApp",
  podlock: root.appendingPathComponent("Podfile.lock"),
  output: "",
  apple: false,
  spm: false,
  pods: false,
  force: false,
  json: false,
  verbose: true
)

private enum KnownEdges {
  static let pods = [
    ("SomeApp", "RxSwift"),
    ("SomeApp", "RxCocoa"),
    ("SomeApp", "Auth0"),
    ("SomeApp", "Moya"),
    ("SomeApp", "NSObject_Rx"),
    ("NSObject_Rx", "RxSwift"),
    ("RxCocoa", "RxSwift"),
    ("RxCocoa", "RxRelay"),
    ("RxRelay", "RxSwift"),
    ("Moya", "Moya/Core"),
    ("Moya/Core", "Alamofire"),
    ("Auth0", "JWTDecode"),
    ("Auth0", "SimpleKeychain"),
  ]

  static let spm = [
    ("SomeApp", "Charts"),
    ("SomeApp", "RealmSwift"),
    ("SomeApp", "Lottie"),
    ("RealmSwift", "Realm"),
    ("Charts", "Algorithms"),
    ("Algorithms", "RealModule"),
    ("RealModule", "_NumericsShims"),
  ]

  static let apple = [
    ("SomeApp", "Foundation"),
    ("SomeApp", "AVFoundation"),
    ("SomeApp", "UIKit"),
    ("SomeApp", "Charts"),
  ]

  static let appleFromSPM = [
    ("RealmSwift", "Combine"),
    ("RealmSwift", "SwiftUI"),
    ("RealmSwift", "Foundation"),
    ("Lottie", "Foundation"),
    ("Lottie", "AppKit"),
    ("Lottie", "CoreGraphics"),
    ("Lottie", "CoreText"),
    ("Lottie", "QuartzCore"),
    ("Lottie", "UIKit"),
    ("Charts", "Foundation"),
    ("Charts", "AppKit"),
    ("Charts", "CoreGraphics"),
    ("Charts", "QuartzCore"),
    ("Charts", "Cocoa"),
    ("Charts", "Quartz"),
    ("Charts", "UIKit"),
  ]

  static let appleFromPods: [(String, String)] = [
    // Unsupported at this time
  ]
}
