
import Foundation
import XCGrapherPluginSupport

class PluginSupport {

    let plugin: XCGrapherPlugin

    var swiftPackageManager: SwiftPackageManager?
    var cocoapodsManager: CocoapodsManager?
    var nativeManager: NativeDependencyManager?
    var unknownManager: UnmanagedDependencyManager?

    init(pluginPath: FileManager.Path) throws {
        plugin = try PluginLoader.plugin(at: pluginPath)
    }

    init(plugin: XCGrapherPlugin) {
        self.plugin = plugin
    }

    func generateDigraph(target: String, projectSourceFiles: [FileManager.Path]) throws -> Digraph {
        let digraph = Digraph(name: "XCGrapher")
        var nodes: [Any] = []

        // MARK: - Main Target

        let targetImports = ImportFinder(fileList: projectSourceFiles).allImportedModules()

        for file in projectSourceFiles {
            let pluginFile = XCGrapherFile(
                filename: file.lastPathComponent(),
                filepath: file,
                fileContents: try String(contentsOfFile: file),
                source: .target(name: target)
            )

            let _nodes = try plugin_process(file: pluginFile)
            nodes.append(contentsOf: _nodes)
        }

        for module in targetImports {
            
            // MARK: - Swift Package Manager
            // Also handles Apple frameworks imported by Swift Packages
            if swiftPackageManager?.isManaging(module: module) == true {
                var previouslyEncounteredModules: Set<String> = []
                try recurseSwiftPackages(from: module, importedBy: target, importerType: .target, building: &nodes, skipping: &previouslyEncounteredModules)
            }

            // MARK: - Cocoapods
            else if cocoapodsManager?.isManaging(module: module) == true {
                var previouslyEncounteredModules: Set<String> = []
                try recurseCocoapods(from: module, importedBy: target, importerType: .target, building: &nodes, skipping: &previouslyEncounteredModules)
            }

            // MARK: - Apple
            // (only Apple frameworks imported by the main --target)
            else if nativeManager?.isManaging(module: module) == true {
                let _nodes = try plugin_process(library: XCGrapherImport(moduleName: module, importerName: target, moduleType: .apple, importerType: .target))
                nodes.append(contentsOf: _nodes)
            }

            // Weird uknown cases
            else if unknownManager?.isManaging(module: module) == true {
                let _nodes = try plugin_process(library: XCGrapherImport(moduleName: module, importerName: target, moduleType: .other, importerType: .target))
                nodes.append(contentsOf: _nodes)
            }
        }

        // MARK: - Finish up

        let edges = try plugin_makeEdges(from: nodes)
        for edge in Set(edges) {
            digraph.addEdge(from: edge.origin, to: edge.destination, color: edge.color)
        }

        return digraph
    }

}

// MARK: - Recursive Functions

private extension PluginSupport {

    func recurseSwiftPackages(from module: String, importedBy importer: String, importerType: XCGrapherImport.ModuleType, building nodeList: inout [Any], skipping modulesToSkip: inout Set<String>) throws {
        if swiftPackageManager?.isManaging(module: module) == true {
            // `module` is a Swift Package and `importer` is either a Swift Package or the main --target
            let _nodes = try plugin_process(library: XCGrapherImport(moduleName: module, importerName: importer, moduleType: .spm, importerType: importerType))
            nodeList.append(contentsOf: _nodes)

            guard !modulesToSkip.contains(module) else { return }
            modulesToSkip.insert(module)

            guard let package = swiftPackageManager?.knownSPMTargets.first(where: { $0.name == module }) else { return }

            // Give the plugin the opportunity to read the package's source files
            for file in package.allSourceFiles {
                let pluginFile = XCGrapherFile(
                    filename: file.lastPathComponent(),
                    filepath: file,
                    fileContents: try String(contentsOfFile: file),
                    source: .spm(importName: module)
                )

                let _nodes = try plugin_process(file: pluginFile)
                nodeList.append(contentsOf: _nodes)
            }

            // Now recurse
            let packageImports = ImportFinder(fileList: package.allSourceFiles).allImportedModules()
            for _module in packageImports {
                try recurseSwiftPackages(from: _module, importedBy: module, importerType: .spm, building: &nodeList, skipping: &modulesToSkip)
            }
        } else if nativeManager?.isManaging(module: module) == true {
            modulesToSkip.insert(module)

            // `module` is an Apple framework and `importer` is a Swift Package
            let _nodes = try plugin_process(library: XCGrapherImport(moduleName: module, importerName: importer, moduleType: .apple, importerType: importerType))
            nodeList.append(contentsOf: _nodes)
        } else if unknownManager?.isManaging(module: module) == true {
            modulesToSkip.insert(module)

            // Weird case
            let _nodes = try plugin_process(library: XCGrapherImport(moduleName: module, importerName: importer, moduleType: .other, importerType: importerType))
            nodeList.append(contentsOf: _nodes)
        }
    }

    func recurseCocoapods(from module: String, importedBy importer: String, importerType: XCGrapherImport.ModuleType, building nodeList: inout [Any], skipping modulesToSkip: inout Set<String>) throws {
        let _nodes = try plugin_process(library: XCGrapherImport(moduleName: module, importerName: importer, moduleType: .cocoapods, importerType: importerType))
        nodeList.append(contentsOf: _nodes)

        guard !modulesToSkip.contains(module) else { return }
        modulesToSkip.insert(module)

        guard cocoapodsManager?.isManaging(module: module) == true else { return }

        for podImport in cocoapodsManager?.dependencies(of: module) ?? [] {
            try recurseCocoapods(from: podImport, importedBy: module, importerType: .cocoapods, building: &nodeList, skipping: &modulesToSkip)
        }
    }

}

// MARK: - Plugin Caller Proxies

private extension PluginSupport {

    func plugin_process(library: XCGrapherImport) throws -> [Any] {
        guard library.importerName != library.moduleName else { return [] } // Filter when the library imports itself

        do {
            return try plugin.process(library: library)
        } catch {
            LogError("The plugin function \(type(of: plugin)).process(library:) threw an error: \(error)")
            throw error
        }
    }

    func plugin_process(file: XCGrapherFile) throws -> [Any] {
        do {
            return try plugin.process(file: file)
        } catch {
            LogError("The plugin function \(type(of: plugin)).process(file:) threw an error: \(error)")
            throw error
        }
    }

    func plugin_makeEdges(from nodes: [Any]) throws -> [XCGrapherEdge] {
        do {
            return try plugin.makeEdges(from: nodes)
        } catch {
            LogError("The plugin function \(type(of: plugin)).makeEdges(from:) threw an error: \(error)")
            throw error
        }
    }

}