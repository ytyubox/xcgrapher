import CustomDump
@testable import XCGrapherLib
import XCTest

@MainActor
final class PodManageTests: XCTestCase {
  func test() async throws {
    let manager = try CocoapodsManager(lockFile: podLockContent)

    XCTAssertNoDifference(manager.dependencies(of: "Alamofire"), [])
    XCTAssertNoDifference(manager.dependencies(of: "Auth0"), [
      "JWTDecode",
      "SimpleKeychain",
    ])
    XCTAssertNoDifference(manager.dependencies(of: "JWTDecode"), [])
    XCTAssertNoDifference(manager.dependencies(of: "Moya"), ["Moya/Core"])
    XCTAssertNoDifference(manager.dependencies(of: "Moya/Core"), ["Alamofire"])
    XCTAssertNoDifference(manager.dependencies(of: "NSObject_Rx"), ["RxSwift"])
    XCTAssertNoDifference(manager.dependencies(of: "RxCocoa"), [
      "RxRelay",
      "RxSwift",
    ])
    XCTAssertNoDifference(manager.dependencies(of: "RxRelay"), ["RxSwift"])
    XCTAssertNoDifference(manager.dependencies(of: "RxSwift"), [])
    XCTAssertNoDifference(manager.dependencies(of: "SimpleKeychain"), [])
  }

  func testFirstLevel() async throws {
    let manager = try CocoapodsManager(lockFile: podLockContent)
    XCTAssertNoDifference(manager.dependencies(), [
      CocoapodsManager.Pod(name: "Alamofire", version: "5.4.1"),
      CocoapodsManager.Pod(name: "Auth0", version: "1.32.0"),
      CocoapodsManager.Pod(name: "JWTDecode", version: "2.6.0"),
      CocoapodsManager.Pod(name: "Moya", version: "14.0.0"),
      CocoapodsManager.Pod(name: "Moya/Core", version: "14.0.0"),
      CocoapodsManager.Pod(name: "NSObject_Rx", version: "5.2.0"),
      CocoapodsManager.Pod(name: "RxCocoa", version: "6.0.0"),
      CocoapodsManager.Pod(name: "RxRelay", version: "6.0.0"),
      CocoapodsManager.Pod(name: "RxSwift", version: "6.0.0"),
      CocoapodsManager.Pod(name: "SimpleKeychain", version: "0.12.2"),
    ])
  }
}

private let podLockContent =
  """
  PODS:
    - Alamofire (5.4.1)
    - Auth0 (1.32.0):
      - JWTDecode
      - SimpleKeychain
    - JWTDecode (2.6.0)
    - Moya (14.0.0):
      - Moya/Core (= 14.0.0)
    - Moya/Core (14.0.0):
      - Alamofire (~> 5.0)
    - "NSObject+Rx (5.2.0)":
      - RxSwift (~> 6.0.0)
    - RxCocoa (6.0.0):
      - RxRelay (= 6.0.0)
      - RxSwift (= 6.0.0)
    - RxRelay (6.0.0):
      - RxSwift (= 6.0.0)
    - RxSwift (6.0.0)
    - SimpleKeychain (0.12.2)

  DEPENDENCIES:
    - Auth0 (= 1.32.0)
    - Moya (= 14.0.0)
    - "NSObject+Rx (= 5.2.0)"
    - RxCocoa (= 6.0.0)
    - RxSwift (= 6.0.0)

  SPEC REPOS:
    trunk:
      - Alamofire
      - Auth0
      - JWTDecode
      - Moya
      - "NSObject+Rx"
      - RxCocoa
      - RxRelay
      - RxSwift
      - SimpleKeychain

  SPEC CHECKSUMS:
    Alamofire: 2291f7d21ca607c491dd17642e5d40fdcda0e65c
    Auth0: 24f8ade897f19bfaca637464b0dc6e9bb7fd70f9
    JWTDecode: 480ca441ddbd5fbfb2abf17870af62f86436be58
    Moya: 5b45dacb75adb009f97fde91c204c1e565d31916
    "NSObject+Rx": 488b91a66043cc47de9cd5de9264f2ae1e2fcb13
    RxCocoa: 3f79328fafa3645b34600f37c31e64c73ae3a80e
    RxRelay: 8d593be109c06ea850df027351beba614b012ffb
    RxSwift: c14e798c59b9f6e9a2df8fd235602e85cc044295
    SimpleKeychain: d6a74781e20ebac8cd89deebf593587913aeed07

  PODFILE CHECKSUM: e033541c49b88eaa58a7099228a70f228ec244a2

  COCOAPODS: 1.11.3

  """
