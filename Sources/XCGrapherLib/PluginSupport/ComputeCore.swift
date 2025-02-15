import Foundation

@dynamicMemberLookup
class Box<T> {
  init(_ value: T) {
    self.value = value
  }

  var value: T
  subscript<V>(dynamicMember keyPath: WritableKeyPath<T, V>) -> V {
    get {
      value[keyPath: keyPath]
    }
    set {
      value[keyPath: keyPath] = newValue
    }
  }
}

class ComputeCore {
  init(
    swiftPackageManager: SwiftPackageManager? = nil,
    cocoapodsManager: CocoapodsManager? = nil,
    nativeManager: NativeDependencyManager? = nil,
    unknownManager: UnmanagedDependencyManager? = nil
  ) {
    self.swiftPackageManager = swiftPackageManager
    self.cocoapodsManager = cocoapodsManager
    self.nativeManager = nativeManager
    self.unknownManager = unknownManager
  }

  let plugin: XCGrapherModuleImportPlugin = .init()

  var swiftPackageManager: SwiftPackageManager?
  var cocoapodsManager: CocoapodsManager?
  var nativeManager: NativeDependencyManager?
  var unknownManager: UnmanagedDependencyManager?

  func generateDigraph(
    title: String = "XCGrapher",
    target: String,
    projectSourceFiles: [FileManager.Path]
  ) throws -> Digraph {
    var digraph = Digraph(name: title)
    let box_nodes: Box<[ImportInfo]> = .init([])

    // MARK: - Main Target

    let targetImports = ImportFinder(fileList: projectSourceFiles).allImportedModules()

    for file in projectSourceFiles {
      let pluginFile = XCGrapherFile(
        filename: file.lastPathComponent(),
        filepath: file,
        fileContents: try failWithContext(
          attempt: Env.contentsOfFile(file),
          context: (target: target, file: file)
        ),
        origin: .target(name: target)
      )

      let _nodes = try plugin_process(file: pluginFile)
      box_nodes.value.append(contentsOf: _nodes)
    }

    for module in targetImports {
      // MARK: - Swift Package Manager

      // Also handles Apple frameworks imported by Swift Packages
      if swiftPackageManager?.isManaging(module: module) == true {
        var previouslyEncounteredModules: Set<String> = []
        try recurseSwiftPackages(
          from: module,
          importedBy: target,
          importerType: .target,
          building: box_nodes,
          skipping: &previouslyEncounteredModules
        )

        digraph.dependencies = swiftPackageManager?.groupDependency() ?? [:]
        digraph.idNameMapping = swiftPackageManager?.groupPackageDescription() ?? [:]
      }

      // MARK: - Cocoapods

      else if cocoapodsManager?.isManaging(module: module) == true {
        var previouslyEncounteredModules: Set<String> = []
        try recurseCocoapods(
          from: module,
          importedBy: target,
          importerType: .target,
          building: box_nodes,
          skipping: &previouslyEncounteredModules
        )
      }

      // MARK: - Apple

      // (only Apple frameworks imported by the main --target)
      else if nativeManager?.isManaging(module: module) == true {
        let _nodes =
          try plugin_process(library: XCGrapherImport(
            moduleName: module,
            importerName: target,
            moduleType: .apple,
            importerType: .target
          ))

        box_nodes.value.append(contentsOf: _nodes)
      }

      // Weird unknown cases
      else if unknownManager?.isManaging(module: module) == true {
        let _nodes =
          try plugin_process(library: XCGrapherImport(
            moduleName: module,
            importerName: target,
            moduleType: .other,
            importerType: .target
          ))
        box_nodes.value.append(contentsOf: _nodes)
      }
    }

    // MARK: - Finish up

    let edges = try plugin_makeArrows(from: box_nodes.value)
    for edge in Set(edges) {
      digraph.addEdge(from: edge.origin, to: edge.destination, color: edge.color)
    }

    digraph.edges.sort()
    return digraph
  }
}

// MARK: - Recursive Functions

private extension ComputeCore {
  func recurseSwiftPackages(
    from module: String,
    importedBy importer: String,
    importerType: XCGrapherImport.ModuleType,
    building box_nodeList: Box<[ImportInfo]>,
    skipping modulesToSkip: inout Set<String>
  ) throws {
    if swiftPackageManager?.isManaging(module: module) == true {
      // `module` is a Swift Package and `importer` is either a Swift Package or the main --target
      let nodes =
        try plugin_process(
          library:
          XCGrapherImport(
            moduleName: module,
            importerName: importer,
            moduleType: .spm,
            importerType: importerType
          )
        )
      box_nodeList.value.append(contentsOf: nodes)

      guard !modulesToSkip.contains(module) else { return }
      modulesToSkip.insert(module)

      guard let package = swiftPackageManager?.knownSPMTargets.first(where: { $0.name == module }) else { return }

      // Give the plugin the opportunity to read the package's source files
      for file in package.sources {
        let pluginFile = XCGrapherFile(
          filename: file.lastPathComponent(),
          filepath: file,
          fileContents: try failWithContext(
            attempt: Env.contentsOfFile(file),
            context: (package: module, file: file)
          ),
          origin: .spm(importName: module)
        )

        let _nodes = try plugin_process(file: pluginFile)
        box_nodeList.value.append(contentsOf: _nodes)
      }

      // Now recurse
      let packageImports = ImportFinder(fileList: package.sources).allImportedModules()
      for _module in packageImports {
        try recurseSwiftPackages(
          from: _module,
          importedBy: module,
          importerType: .spm,
          building: box_nodeList,
          skipping: &modulesToSkip
        )
      }
    } else if nativeManager?.isManaging(module: module) == true {
      modulesToSkip.insert(module)

      // `module` is an Apple framework and `importer` is a Swift Package
      let _nodes =
        try plugin_process(
          library: XCGrapherImport(
            moduleName: module,
            importerName: importer,
            moduleType: .apple,
            importerType: importerType
          )
        )
      box_nodeList.value.append(contentsOf: _nodes)
    } else if unknownManager?.isManaging(module: module) == true {
      modulesToSkip.insert(module)

      // Weird case
      let _nodes =
        try plugin_process(
          library: XCGrapherImport(
            moduleName: module,
            importerName: importer,
            moduleType: .other,
            importerType: importerType
          )
        )
      box_nodeList.value.append(contentsOf: _nodes)
    }
  }

  func recurseCocoapods(
    from module: String,
    importedBy importer: String,
    importerType: XCGrapherImport.ModuleType,
    building box_nodeList: Box<[ImportInfo]>,
    skipping modulesToSkip: inout Set<String>
  ) throws {
    let _nodes = try plugin_process(library: XCGrapherImport(
      moduleName: module,
      importerName: importer,
      moduleType: .cocoapods,
      importerType: importerType
    ))
    box_nodeList.value.append(contentsOf: _nodes)

    guard !modulesToSkip.contains(module) else { return }
    modulesToSkip.insert(module)

    guard cocoapodsManager?.isManaging(module: module) == true else { return }

    for podImport in cocoapodsManager?.dependencies(of: module) ?? [] {
      try recurseCocoapods(
        from: podImport,
        importedBy: module,
        importerType: .cocoapods,
        building: box_nodeList,
        skipping: &modulesToSkip
      )
    }
  }
}

// MARK: - Plugin Caller Proxies

private extension ComputeCore {
  func plugin_process(library: XCGrapherImport) throws -> [ImportInfo] {
    guard library.importerName != library.moduleName else { return [] } // Filter when the library imports itself

    do {
      return try plugin.process(library: library)
    } catch {
      LogError("The plugin function \(type(of: plugin)).process(library:) threw an error: \(error)")
      throw error
    }
  }

  func plugin_process(file: XCGrapherFile) throws -> [ImportInfo] {
    do {
      return try plugin.process(file: file)
    } catch {
      LogError("The plugin function \(type(of: plugin)).process(file:) threw an error: \(error)")
      throw error
    }
  }

  func plugin_makeArrows(from processingResults: [ImportInfo]) throws -> [XCGrapherArrow] {
    do {
      return try plugin.makeArrows(from: processingResults)
    } catch {
      LogError("The plugin function \(type(of: plugin)).makeEdges(from:) threw an error: \(error)")
      throw error
    }
  }
}
