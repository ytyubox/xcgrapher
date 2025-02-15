import Foundation

public enum XCGrapher {
  public static func run(with options: XCGrapherOptions) throws -> String {
    if options.verbose == false {
      Logger.log = { _ in }
    }

    // MARK: - Prepare the --target source file list

    Log("ruby version: \(try TerminalCommand(cmd: "ruby --version").execute())")
    Log("xcodeproj version: \(try TerminalCommand(cmd: "xcodeproj --version").execute())")

    Log("Generating list of source files in \(options.startingPoint.localisedName)")
    let sources = try source(options)

    // MARK: - Create dependency manager lookups

    let handler = ComputeCore()

    if options.spm || options.startingPoint.isSPM {
      Log("Building Swift Package list")
      let swiftPackageDependencySource = try maker(options)
      var swiftPackageDependencies = try swiftPackageDependencySource.swiftPackageDependencies()

      if options.startingPoint.isSPM {
      } else {
        let localPackages = try XcodeprojGetLocalPackages(projectFile: options.startingPoint.path).localPackages()
        if localPackages.isEmpty == false {
          swiftPackageDependencies.append(contentsOf: localPackages.map(\.absoluteString))
        }
      }
      handler.swiftPackageManager = try SwiftPackageManager(
        package: options.startingPoint.path,
        checkouts: swiftPackageDependencies
      )
    }

    if options.pods {
      Log("Building Cocoapod list")
      handler.cocoapodsManager = try CocoapodsManager(lockFile: options.podlock)
    }

    if options.apple {
      Log("Building Apple framework list")
      let nativeManager = try NativeDependencyManager()
      handler.nativeManager = nativeManager
    }

    if options.force {
      Log("Ensuring all additional modules are graphed")
      // Don't ignore unknown dependencies - add a manager that claims it is reponsible for them being there.
      // MUST be last in `allDependencyManagers`.
      let unknownManager = UnmanagedDependencyManager()
      handler.unknownManager = unknownManager
    }
    let digraph = try handler.generateDigraph(
      target: options.target,
      projectSourceFiles: sources
    )

    if options.json {
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      let data = try encoder.encode(digraph.json())
      if options.output.isEmpty,
         let text = String(data: data, encoding: .utf8) {
        print(text)
        return text
      } else {
        let url = expandPath(options.output, in: options.currentDirectory.path)

        try data.write(to: url)

        Log("Result written to", options.output)
      }
    } else {
      // MARK: - Graphing

      Log("Graphing...")

      // MARK: - Writing

      let build = digraph.build()
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

private func maker(_ option: XCGrapherOptions) throws -> SwiftPackageDependencySource {
  let path = option.startingPoint.path
  let target = option.target
  switch option.startingPoint {
  case .xcodeProject: return Xcodebuild(projectFile: path, target: target)
  case .swiftPackage: return SwiftBuild(packagePath: path, product: path)
  }
}

private func source(_ options: XCGrapherOptions) throws -> [String] {
  switch options.startingPoint {
  case let .xcodeProject(project):
    let xcodeproj = Xcodeproj(projectFile: project, target: options.target)
    return try xcodeproj.compileSourcesList()
  case let .swiftPackage(packagePath):
    let package = SwiftPackage(clone: packagePath)
    guard let target = try package.packageDescription().targets.first(where: { $0.name == options.target }) else {
      throw die("Could not locate target '\(options.target)'")
    }
    return target.sources
  }
}
