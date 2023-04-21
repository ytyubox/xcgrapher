import Foundation

struct SwiftPackageManager {
  struct Package {
    var describe: PackageDescription
    var dependency: Dependency
  }

  init(
    package: Package,
    otherPackageDescriptions: [PackageDescription]
  ) {
    self.package = package
    self.otherPackageDescriptions = otherPackageDescriptions
  }

  let package: Package
  let otherPackageDescriptions: [PackageDescription]

  var knownSPMTargets: [PackageDescription.Target] {
    package.describe.targets
  }

  /// - Parameter packageClones: A list of directories, each a cloned SPM dependency.
  init(package: FileManager.Path, checkouts: [FileManager.Path]) throws {
    self.package = .init(
      describe: try SwiftPackage(clone: package).packageDescription(),
      dependency: try SwiftShowDependency(clone: package).loadDependency()
    )

    func recursiveLoadDescribe(dependency: Dependency) throws -> [PackageDescription] {
      let describe = try SwiftPackage(clone: dependency.path).packageDescription()
      var other: [PackageDescription] = []
      for dependency in dependency.dependencies {
        other.append(contentsOf: try recursiveLoadDescribe(dependency: dependency))
      }
      return [describe] + other
    }
    otherPackageDescriptions = try checkouts
      .map { try SwiftPackage(clone: $0).packageDescription() }
  }

  func groupPackageDescription() -> [String: [String]] {
    var g: [String: [String]] = [:]

    for target in package.describe._targets {
      let target_dep = target.target_dependencies ?? []
      let product_dep = target.product_dependencies ?? []
      g[target.name] = [target_dep, product_dep].flatMap { $0 }
    }

    for description in otherPackageDescriptions {
      g[description.name] = description.products.map(\.name)
    }
    return g
  }

  func groupDependency() -> [Dependency_Key: [String]] {
    var g: [Dependency_Key: [String]] = [:]
    func re(dep: Dependency) {
      let key = Dependency_Key(
        identity: dep.identity,
        name: dep.name,
        url: dep.url,
        version: dep.version,
        path: dep.path
      )
      if g[key] != nil { return }
      g[key] = dep.dependencies.map(\.identity)
      for d in dep.dependencies {
        re(dep: d)
      }
    }

    for d in package.dependency.dependencies {
      re(dep: d)
    }

    return g
  }

  func swiftPackageMerge() -> [String: [String]] {
    let r = groupPackageDescription()

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
