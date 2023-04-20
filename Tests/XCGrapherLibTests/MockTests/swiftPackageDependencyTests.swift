import CustomDump
@testable import XCGrapherLib
import XCTest

@MainActor
final class swiftPackageDependencyTests: XCTestCase {
  func testSomePackage() async throws {
    let g = SwiftPackageManager(packages: [
      .init(
        describe: PackageDescription(name: "", path: "", _targets: []),
        dependency: SomePackageDependency
      ),
    ])
    .groupDependency()
    XCTAssertEqual(
      g,
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
    )
  }
}
