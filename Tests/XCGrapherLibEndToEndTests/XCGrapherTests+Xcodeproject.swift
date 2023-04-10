import XCTest

@testable import XCGrapherLib

/// `sut` fail to execute `dot`, however we don't care as we are just reading the output text file
final class XCGrapherXcodeprojectTests: XCTestCase {
  private var sut: ((XCGrapherOptions) throws -> String)!
  private var options: XCGrapherOptions!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = XCGrapher.run
    options = ConcreteGrapherOptions
  }

  func testSomeAppPods() throws {
    // GIVEN we only pass --pods to xcgrapher
    options.pods = true

    // WHEN we generate a digraph

    let digraph = try sut(options)

    XCGrapherAssertDigraphIsMadeFromEdges(
      digraph, [
        ("Auth0", "JWTDecode"),
        ("Auth0", "SimpleKeychain"),
        ("Moya", "Moya/Core"),
        ("Moya/Core", "Alamofire"),
        ("NSObject_Rx", "RxSwift"),
        ("RxCocoa", "RxRelay"),
        ("RxCocoa", "RxSwift"),
        ("RxRelay", "RxSwift"),
        ("SomeApp", "Auth0"),
        ("SomeApp", "Moya"),
        ("SomeApp", "NSObject_Rx"),
        ("SomeApp", "RxCocoa"),
        ("SomeApp", "RxSwift"),
      ]
    )
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

  func testSomeAppPodsAndSPM() throws {
    // GIVEN we pass both --spm and --pods to xcgrapher
    options.spm = true
    options.pods = true

    // WHEN we generate a digraph

    let digraph = try sut(options)

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.spm + KnownEdges.pods

    XCGrapherAssertDigraphIsMadeFromEdges(digraph, expectedEdges)
  }

  func testSomeAppApple() throws {
    // GIVEN we only pass --apple to xcgrapher
    options.apple = true

    // WHEN we generate a digraph

    let digraph = try sut(options)

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.apple

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

  func testSomeAppAppleAndSPMAndPods() throws {
    // GIVEN we pass --apple and --spm and --pods to xcgrapher
    options.apple = true
    options.spm = true
    options.pods = true

    // WHEN we generate a digraph
    let digraph = try sut(options)

    // THEN the digraph only contains these edges
    let expectedEdges = KnownEdges.apple + KnownEdges.spm + KnownEdges.appleFromSPM + KnownEdges.pods + KnownEdges
      .appleFromPods

    XCGrapherAssertDigraphIsMadeFromEdges(digraph, expectedEdges)
  }
}

private let someAppRoot = URL(fileURLWithPath: #file)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appendingPathComponent("SampleProjects")
  .appendingPathComponent("SomeApp")
  .path
private let ConcreteGrapherOptions: XCGrapherOptions = .init(
  currentDirectory: .init(string: "some.url")!,
  startingPoint: .xcodeProject(someAppRoot.appendingPathComponent("SomeApp.xcodeproj")),
  target: "SomeApp",
  podlock: someAppRoot.appendingPathComponent("Podfile.lock"),
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
