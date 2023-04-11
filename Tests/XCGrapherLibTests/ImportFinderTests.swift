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
        "@_spi(CurrentTestCase) import E",
        "#if canImport(F)",
      ], contentsOfFile: { $0 })
        .allImportedModules(),
      [
        "A",
        "B",
        "E",
      ]
    )
  }
}
