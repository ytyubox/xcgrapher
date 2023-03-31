import Foundation

public struct ImportInfo {
  public init(importedModuleName: String, importerModuleName: String, color: String) {
    self.importedModuleName = importedModuleName
    self.importerModuleName = importerModuleName
    self.color = color
  }

  public let importedModuleName: String
  public let importerModuleName: String
  public let color: String
}
