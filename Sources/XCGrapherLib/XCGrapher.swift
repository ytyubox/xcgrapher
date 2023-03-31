import Foundation

public enum XCGrapher {

  public static func run(with options: XCGrapherOptions) throws -> String {
    if options.verbose == false {
      Logger.log = { _ in }
    }

    // MARK: - Load the plugin

    // MARK: - Prepare the --target source file list

    Log("ruby version: \(try TerminalCommand(cmd: "ruby --version").execute())")
    Log("xcodeproj version: \(try TerminalCommand(cmd: "xcodeproj --version").execute())")

    Log("Generating list of source files in \(options.startingPoint.localisedName)")
    var sources: [FileManager.Path] = []
    switch options.startingPoint {
    case let .xcodeProject(project):
      let xcodeproj = Xcodeproj(projectFile: project, target: options.target)
      sources = try xcodeproj.compileSourcesList()
    case let .swiftPackage(packagePath):
      let package = SwiftPackage(clone: packagePath)
      guard let target = try package.targets().first(where: { $0.name == options.target }) else {
        throw die("Could not locate target '\(options.target)'")
      }
      sources = target.sources
    }

    // MARK: - Create dependency manager lookups

    let pluginHandler = PluginSupport()

    if options.spm || options.startingPoint.isSPM {
      Log("Building Swift Package list")
      let maker = extractedFunc(options.startingPoint)

      let swiftPackageDependencySource: SwiftPackageDependencySource = maker(
        options.startingPoint.path,
        options.target
      )

      pluginHandler.swiftPackageManager = try SwiftPackageManager(
        packageClones: try swiftPackageDependencySource
          .swiftPackageDependencies()
      )
    }

    if options.pods {
      Log("Building Cocoapod list")
      pluginHandler.cocoapodsManager = try CocoapodsManager(lockFile: options.podlock)
    }

    if options.apple {
      Log("Building Apple framework list")
      let nativeManager = try NativeDependencyManager()
      pluginHandler.nativeManager = nativeManager
    }

    if options.force {
      Log("Ensuring all additional modules are graphed")
      // Don't ignore unknown dependencies - add a manager that claims it is reponsible for them being there.
      // MUST be last in `allDependencyManagers`.
      let unknownManager = UnmanagedDependencyManager()
      pluginHandler.unknownManager = unknownManager
    }
    let digraph = try pluginHandler.generateDigraph(
      target: options.target,
      projectSourceFiles: sources
    )

    if options.json {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let data = try encoder.encode(digraph.json())
      if options.output.isEmpty,
         let text = String(data: data, encoding: .utf8) {
        print(text)
      } else {
        let url = expandPath(options.output, in: options.currentDirectory.path)

        try data.write(to: url)

        Log("Result written to", options.output)
      }
    } else {
      // MARK: - Graphing

      Log("Graphing...")

      // MARK: - Writing

      let digraphOutput = "/tmp/xcgrapher.dot"
      let build = digraph.build()
      try build.data(using: .utf8)!
        .write(to: URL(fileURLWithPath: digraphOutput))
      Log("Result written to", options.output)
      return build
    }
    return ""
  }
}

func expandPath(_ path: String, in directory: String) -> URL {
  if path.hasPrefix("/") {
    return URL(fileURLWithPath: path).standardized
  }
  if path.hasPrefix("~") {
    return URL(fileURLWithPath: NSString(string: path).expandingTildeInPath).standardized
  }
  return URL(fileURLWithPath: directory).appendingPathComponent(path).standardized
}

private func extractedFunc(_ startingPoint: StartingPoint)
  -> (String, String) -> SwiftPackageDependencySource {
  switch startingPoint {
  case .xcodeProject: return Xcodebuild.init
  case .swiftPackage: return SwiftBuild.init
  }
}
