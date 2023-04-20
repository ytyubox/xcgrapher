import Foundation

struct SwiftPackageManager {
  struct Package {
    var describe: PackageDescription
    var dependency: Dependency
  }

  init(packageDescriptions: [PackageDescription]) {
    self.packageDescriptions = packageDescriptions
  }

  let packageDescriptions: [PackageDescription]

  var knownSPMTargets: [PackageDescription.Target] {
    packageDescriptions.flatMap(\.targets)
  }

  /// - Parameter packageClones: A list of directories, each a cloned SPM dependency.
  init(packageClones: [FileManager.Path]) throws {
    packageDescriptions = try packageClones.map {
      try SwiftPackage(clone: $0).packageDescription()
    }
  }

  func groupPackageDescription() -> [String: [String]] {
    var g: [String: [String]] = [:]
    for packageDescription in packageDescriptions {
      for target in packageDescription._targets {
        let target_dep = target.target_dependencies ?? []
        let product_dep = target.product_dependencies ?? []
        g[target.name] = [target_dep, product_dep].flatMap { $0 }
      }
    }
    return g
  }

  func swiftPackageMerge(
    dependency: [Dependency_Key: [String]]
  ) -> [String: [String]] {
    var r = groupPackageDescription()
    for (key, value) in dependency {
      if r[key.identity] != nil { continue }
      r[key.identity] = value
    }
    return r
  }
}

extension SwiftPackageManager: DependencyManager {
  var pluginModuleType: XCGrapherImport.ModuleType {
    .spm
  }

  func isManaging(module: String) -> Bool {
    knownSPMTargets.contains { $0.name == module }
  }

  func dependencies(of module: String) -> [String] {
    guard let target = knownSPMTargets.first(where: { $0.name == module }) else { return [] }

    return ImportFinder(fileList: target.sources).allImportedModules()
  }
}

struct LocalSwiftPackageManager {
  let knownSPMTargets: [PackageDescription.Target]

  /// - Parameter packageClones: A list of directories, each a cloned SPM dependency.
  init(packageClones: [FileManager.Path]) throws {
    knownSPMTargets = try packageClones.flatMap {
      try SwiftPackage(clone: $0).packageDescription().targets
    }
  }
}

extension LocalSwiftPackageManager: DependencyManager {
  var pluginModuleType: XCGrapherImport.ModuleType {
    .local
  }

  func isManaging(module: String) -> Bool {
    knownSPMTargets.contains { $0.name == module }
  }

  func dependencies(of module: String) -> [String] {
    guard let target = knownSPMTargets.first(where: { $0.name == module }) else { return [] }

    return ImportFinder(fileList: target.sources).allImportedModules()
  }
}
