import Foundation
import XCTestDynamicOverlay

enum Env {
  static var contentsOfFile: (String) -> String = {
    _XCTIsTesting
      ? $0
      : try! String(contentsOfFile: $0)
  }

}

// Must also handle `@testable import X`, `import class X.Y` etc
struct ImportFinder {
  internal init(fileList: [FileManager.Path]) {
    self.fileList = fileList
  }

  let fileList: [FileManager.Path]

  func loadFiles() -> [String] {
    fileList
      // swiftlint:disable force_try
      .map(Env.contentsOfFile)
      .flatMap { $0.breakIntoLines() }
  }

  /// Read each file in `fileList` and search for `import X`, `@testable import X`, `import class X.Y` etc.
  /// - Returns: A list of frameworks being imported by every file in `fileList`.
  func allImportedModules() -> [String] {
    loadFiles()
      .map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { $0.contains("import ") && $0.contains("canImport") == false }
      .map {
        $0
          .replacingOccurrences(of: "@testable ", with: "")
          .replacingOccurrences(of: "@_exported ", with: "")
          .replacingOccurrences(of: " class ", with: " ")
          .replacingOccurrences(of: " struct ", with: " ")
          .replacingOccurrences(of: " enum ", with: " ")
          .replacingOccurrences(of: " protocol ", with: " ")
          .replacingOccurrences(of: " var ", with: " ")
          .replacingOccurrences(of: " let ", with: " ")
          .replacingOccurrences(of: " func ", with: " ")
      }
      .map {
        $0.scan {
          $0.scanUpToAndIncluding(string: "import ")
          $0.scanAndStoreUpToCharacters(from: CharacterSet(charactersIn: " ."))
        }
      }
      .map { (raw: String) -> String in
        var raw = raw

        if let index = raw.firstIndex(of: "/") {
          raw.removeSubrange(index...)
        }
        return raw
      }
      .filter { $0 != "Swift" }
      .unique()
      .sortedAscendingCaseInsensitively()
  }
}
