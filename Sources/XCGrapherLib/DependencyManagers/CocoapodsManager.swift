import Foundation

struct CocoapodsManager {
  /// Contains something like:
  /// ```
  /// PODS:
  /// - Auth0 (1.32.0):
  ///   - JWTDecode
  ///   - SimpleKeychain
  /// - JWTDecode (2.6.0)
  /// - NSObject_Rx (5.2.0):
  ///   - RxSwift (~> 6.0.0)
  /// ... etc
  /// ```
  let lockfilePodList: String

  init(lockFile: FileManager.Path) throws {
    lockfilePodList =
      Env.contentsOfFile(lockFile)
        .scan {
          $0.scanUpTo(string: "PODS:")
          $0.scanAndStoreUpTo(string: "\n\n")
        }
        // Account for NSObject+Rx being quoted and actually being imported with a _ instead of +
        .replacingOccurrences(of: "+", with: "_")
        .replacingOccurrences(of: "\"", with: "")
  }
}

extension CocoapodsManager: DependencyManager {
  var pluginModuleType: XCGrapherImport.ModuleType {
    .cocoapods
  }

  func isManaging(module: String) -> Bool {
    let podlockEntry = "\n  - ".appending(module).appending(" ")
    return lockfilePodList.contains(podlockEntry)
  }

  struct Pod: Equatable, Hashable {
    var name: String
    var version: String
  }

  func dependencies() -> [Pod: [String]] {
    lockfilePodList
      .breakIntoLines()
      .filter { $0.hasPrefix("  -") }
      .map { str in
        Pod(
          name: str
            .scan {
              $0.scanUpToAndIncluding(string: "  - ")
              $0.scanAndStoreUpTo(string: " (")
            },
          version: str.scan {
            $0.scanUpToAndIncluding(string: "(")
            $0.scanAndStoreUpTo(string: ")")
          }
        )
      }
      .reduce(into: [:]) { partialResult, pod in
        partialResult[pod] = dependencies(of: pod.name)
      }
  }

  func dependencies(of module: String) -> [String] {
    // Parse the lockfile, looking for entries indented underneath `module`
    lockfilePodList
      .scan {
        $0.scanUpToAndIncluding(string: "\n  - ".appending(module).appending(" "))
        $0.scanAndStoreUpTo(string: "\n  - ")
      }
      .breakIntoLines()
      .dropFirst()
      .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: " -:\n")) }
      .filter { !$0.isEmpty }
      .map { $0.components(separatedBy: " ")[0] }
      .map { $0.replacingOccurrences(of: "\"", with: "") }
  }
}
