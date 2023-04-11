import ApprovalTests_Swift
import CustomDump
@_exported @testable import XCGrapherLib
import XCTest

@MainActor
final class ImportFinderTests: XCTestCase {
  func test() async throws {
    XCTAssertNoDifference(
      ImportFinder(fileList: [
        "@testable import A",
        "@_exported @testable import B",
        "var c = D()",
        "@_spi(AA) import E",
        "#if canImport(F)",
        "import class G.H",
      ], contentsOfFile: { $0 })
        .allImportedModules(),
      [
        "A",
        "B",
        "E",
        "G",
      ]
    )
  }

  func testVerify_import() throws {
    let importCodes =
      """
      @_exported @testable import XCGrapherLib
      @_exported import RxRelay
      @_exported import RxSwift
      @_exported import func XCTest.XCTFail
      @_implementationOnly import ArgumentParserToolInfo
      @_implementationOnly import Foundation
      @_spi(CurrentTestCase) import XCTestDynamicOverlay
      @_spi(Internals) import CasePaths
      @_spi(Reflection) import CasePaths
      @_spi(ToolInfo) import ArgumentParser
      @testable import Alamofire
      @testable import ApprovalTests_Swift
      @testable import ApprovalTests_iOS
      @testable import ArgumentParser
      @testable import Kingfisher
      @testable import Moya
      @testable import Nimble
      @testable import Quick
      @testable import QuickTests
      @testable import ReactiveMoya
      @testable import ReactiveSwift
      @testable import ReactiveSwiftTests
      @testable import RxCocoa
      @testable import RxMoya
      @testable import RxSwift
      @testable import SamplePhoneApp
      @testable import SomePackage
      @testable import XCGrapherLib
      @testable import XCTestDynamicOverlay
      import AVKit
      import Accelerate
      import Alamofire
      import AppKit
      import AppKit.NSImage
      import ApprovalTests_Swift
      import ApprovalTests_iOS
      import ArgumentParser
      import ArgumentParserTestHelpers
      import ArgumentParserToolInfo
      import Auth0
      import Auth0ObjectiveC
      import AuthenticationServices
      import Benchmark
      import CDispatch
      import CRT
      import CasePaths
      import Charts
      import Cocoa
      import Combine
      import CommonCrypto
      import Core//
      import CoreFoundation
      import CoreGraphics
      import CoreImage
      import CoreLocation
      import CoreMotion
      import CoreServices
      import CustomDump
      import CwlCatchExceptionSupport
      import CwlMachBadInstructionHandler
      import Danger
      import DangerSwiftProse // package: https://github.com/f-meloni/danger-swift-prose.git
      import DangerXCodeSummary // package: https://github.com/f-meloni/danger-swift-xcodesummary.git
      import Darwin
      import Darwin.C
      import Darwin.POSIX.pthread
      import Dispatch
      import Foundation
      import Foundation.NSObject
      import FoundationNetworking
      import GameKit
      import Glibc
      import ImageIO
      import JWTDecode
      import Kingfisher
      import LocalAuthentication
      import Lottie
      import MachO
      import MobileCoreServices
      import Moya
      import NSObject_Rx
      import Nimble
      import NimbleTests
      import OHHTTPStubs
      import OHHTTPStubsSwift
      import ObjectiveC
      import PackageConfig
      import PackageDescription
      import Photos
      import PlaygroundSupport
      import Quick
      import QuickSpecBase
      import ReactiveSwift
      import RealmSwift
      import RxBlocking
      import RxCocoa
      import RxCocoaRuntime
      import RxExample_iOS
      import RxRelay
      import RxSwift
      import RxTest
      import SafariServices
      import SimpleKeychain
      import SomePackageTests
      import Speech
      import StoreKit
      import Swift
      import SwiftUI
      import SystemConfiguration
      import TVUIKit
      import UIKit
      import UIKit.UIImage
      import UserNotifications
      import UserNotificationsUI
      import WatchKit
      import WebKit
      import WinSDK
      import XCGrapherCLIParser
      import XCGrapherLib
      import XCTest
      import XCTestDynamicOverlay
      import class AVFoundation.AVAsset
      import class Dispatch.DispatchQueue
      import class Dispatch.DispatchSpecificKey
      import class Foundation.BlockOperation
      import class Foundation.Bundle
      import class Foundation.DateFormatter
      import class Foundation.HTTPURLResponse
      import class Foundation.JSONSerialization
      import class Foundation.NSCondition
      import class Foundation.NSDictionary
      import class Foundation.NSError
      import class Foundation.NSLock
      import class Foundation.NSNull
      import class Foundation.NSNumber
      import class Foundation.NSObject
      import class Foundation.NSRecursiveLock
      import class Foundation.NSRegularExpression
      import class Foundation.NSString
      import class Foundation.NSValue
      import class Foundation.NotificationCenter
      import class Foundation.Operation
      import class Foundation.OperationQueue
      import class Foundation.ProcessInfo
      import class Foundation.RunLoop
      import class Foundation.Thread
      import class Foundation.URLResponse
      import class Foundation.URLSession
      import class FoundationNetworking.HTTPURLResponse
      import class FoundationNetworking.URLResponse
      import class FoundationNetworking.URLSession
      import enum Alamofire.AFError
      import enum Dispatch.DispatchTimeInterval
      import enum Foundation.QualityOfService
      import func CoreFoundation._CFIsMainThread
      import func Foundation.NSMakeRange
      import func Foundation.arc4random
      import func Foundation.arc4random_uniform
      import func Foundation.objc_getAssociatedObject
      import func Foundation.objc_setAssociatedObject
      import func Foundation.pthread_getspecific
      import func Foundation.pthread_key_create
      import func Foundation.pthread_setspecific
      import func Glibc.random
      import let CDispatch.NSEC_PER_SEC
      import let CDispatch.NSEC_PER_USEC
      import os
      import protocol Foundation.NSCopying
      import struct Foundation.CharacterSet
      import struct Foundation.Data
      import struct Foundation.Date
      import struct Foundation.IndexPath
      import struct Foundation.NSRange
      import struct Foundation.Notification
      import struct Foundation.TimeInterval
      import struct Foundation.URL
      import struct Foundation.URLRequest
      import struct Foundation.pthread_key_t
      import struct FoundationNetworking.URLRequest
      import var Foundation.NSURLErrorCancelled
      import var Foundation.NSURLErrorDomain
      """
    let modules = ImportFinder(fileList: [importCodes], contentsOfFile: { $0 })
      .allImportedModules()
    try Approvals.verify(modules.sortedAscendingCaseInsensitively().joined(separator: "\n"))
  }
}
