import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  [
    testCase(SomePackageTests.allTests),
  ]
}
#endif
