import CustomDump
import XCTest

@MainActor
final class SwiftPackageMergeTests: XCTestCase {
  func test() async throws {
    XCTAssertNoDifference(
      swiftPackageMerge(
        describe: [
          "Core": ["CasePaths"],
          "SomePackage": ["Core", "Kingfisher", "Moya", "Alamofire"],
          "SomePackageTests": ["SomePackage"],
        ],
        dependency: dependency
      ),
      [
        "Core": ["CasePaths"],
        "Kingfisher": [],
        "SomePackage": ["Core", "Kingfisher", "Moya", "Alamofire"],
        "SomePackageTests": ["SomePackage"],
        "alamofire": [],
        "moya": ["alamofire", "reactiveswift", "rxswift"],
        "reactiveswift": [],
        "rxswift": [],
      ]
    )
  }
}

struct Lib: Hashable {
  var name: String
  var id: GitId?
}

func swiftPackageMerge(
  describe: [String: [String]],
  dependency: [Dependency_Key: [String]]
) -> [String: [String]] {
  var r = describe
  for (key, value) in dependency {
    if r[key.identity] != nil { continue }
    r[key.identity] = value
  }
  return r
}

private let dependency =
  [
    XCGrapherLibTests.Dependency_Key(
      identity: "alamofire",
      name: "Alamofire",
      url: "https://github.com/Alamofire/Alamofire.git",
      version: "5.4.3",
      path: "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Alamofire"
    ): [],
    XCGrapherLibTests.Dependency_Key(
      identity: "moya",
      name: "Moya",
      url: "https://github.com/Moya/Moya.git",
      version: "14.0.0",
      path: "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Moya"
    ): ["alamofire", "reactiveswift", "rxswift"],
    XCGrapherLibTests
      .Dependency_Key(
        identity: "reactiveswift",
        name: "ReactiveSwift",
        url: "https://github.com/Moya/ReactiveSwift.git",
        version: "6.1.0",
        path: "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/ReactiveSwift"
      ): [],
    XCGrapherLibTests
      .Dependency_Key(
        identity: "kingfisher",
        name: "Kingfisher",
        url: "https://github.com/onevcat/Kingfisher.git",
        version: "6.3.0",
        path: "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Kingfisher"
      ): [],
    XCGrapherLibTests
      .Dependency_Key(
        identity: "rxswift",
        name: "RxSwift",
        url: "https://github.com/ReactiveX/RxSwift.git",
        version: "5.1.2",
        path: "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/RxSwift"
      ): [],
  ]
