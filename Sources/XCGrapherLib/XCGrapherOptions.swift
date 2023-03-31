import Foundation

public struct XCGrapherOptions: Equatable {
  public init(
    currentDirectory: URL,
    startingPoint: StartingPoint,
    target: String,
    podlock: String,
    output: String,
    apple: Bool,
    spm: Bool,
    pods: Bool,
    force: Bool,
    json: Bool,
    verbose: Bool
  ) {
    self.currentDirectory = currentDirectory
    self.startingPoint = startingPoint
    self.target = target
    self.podlock = podlock
    self.output = output
    self.apple = apple
    self.spm = spm
    self.pods = pods
    self.force = force
    self.json = json
    self.verbose = verbose
  }

  public var currentDirectory: URL
  public var startingPoint: StartingPoint
  public var target: String
  public var podlock: String
  public var output: String
  public var apple: Bool
  public var spm: Bool
  public var pods: Bool
  public var force: Bool
  public var json: Bool
  public var verbose: Bool
}

public enum StartingPoint: Equatable {
  case xcodeProject(String)
  case swiftPackage(String)

  var localisedName: String {
    switch self {
    case let .xcodeProject(project): return "Xcode project at path '\(project)'"
    case let .swiftPackage(packagePath): return "Swift Package at path '\(packagePath)'"
    }
  }

  var isSPM: Bool {
    switch self {
    case .xcodeProject: return false
    case .swiftPackage: return true
    }
  }

  var path: String {
    switch self {
    case let .xcodeProject(projectPath): return projectPath
    case let .swiftPackage(packagePath): return packagePath
    }
  }
}
