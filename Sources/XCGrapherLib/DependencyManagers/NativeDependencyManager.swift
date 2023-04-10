import Foundation

struct NativeDependencyManager {
  let allNativeFrameworks: [String]

  init() throws {
    let standardList = try FileManager.default
      .contentsOfDirectory(atPath: "/System/Library/Frameworks")

    // It seems the above does not contain UIKit.framework though... so let's use another list that does
    let backupList = getBackupList(url: URL(fileURLWithPath: "/Applications/Xcode.app/Contents/Developer/Platforms"))

    allNativeFrameworks = (standardList + Array(backupList))
      .filter { $0.hasPrefix("_") == false }
      .map { $0.replacingOccurrences(of: ".framework", with: "") }
      .unique()
  }
}

private func getBackupList(url: URL) -> [String] {
  guard let enumerator = FileManager.default.enumerator(
    at: url,
    includingPropertiesForKeys: [.isDirectoryKey],
    options: [.skipsHiddenFiles, .skipsPackageDescendants]
  ) else {
    return []
  }
  var backupList: [String] = []
  do {
    for case let fileURL as URL in enumerator {
      if fileURL.lastPathComponent.lowercased().contains("framework"),
         fileURL.lastPathComponent.lowercased().hasPrefix("_") == false,
         fileURL.pathComponents.filter({ $0.lowercased().contains("frameworks") }).count == 1,
         fileURL.absoluteString.lowercased().contains("private") == false {
        backupList.append(fileURL.lastPathComponent)
      }
    }
  }
  return backupList
}

extension NativeDependencyManager: DependencyManager {
  var pluginModuleType: XCGrapherImport.ModuleType {
    .apple
  }

  func isManaging(module: String) -> Bool {
    allNativeFrameworks.contains(module)
  }

  func dependencies(of module: String) -> [String] {
    [] // Obviously we don't know how Apple's frameworks work internally
  }
}
