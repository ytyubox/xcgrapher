import Foundation

public struct ImportInfo {
  public init(importedModuleName: String, importerModuleName: String, manager: String, remote: Remote? = nil) {
    self.importedModuleName = importedModuleName
    self.importerModuleName = importerModuleName
    self.manager = manager
    self.remote = remote
  }

  public let importedModuleName: String
  public let importerModuleName: String
  public let manager: String
  public let remote: Remote?
}

public struct Remote {
  public init(url: String, source: Remote.Source) {
    self.url = url
    self.source = source
  }

  var url: String
  var source: Source

  public enum Source {
    case tag(String), branch(String, String), commit(String)
  }
}
