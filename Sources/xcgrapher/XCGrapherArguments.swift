import ArgumentParser
import Foundation
import XCGrapherLib

typealias XCGrapherArguments = xcgrapher

/// Needs this name for `ParsableArguments`'s help text to be correct
struct xcgrapher: ParsableArguments {
    @Option(name: .long, help: "The path to the .xcodeproj")
    public var project: String?

    @Option(
        name: .long,
        help: "The name of the Xcode project target (or Swift Package product) to use as a starting point"
    )
    public var target: String?

    @Option(name: .long, help: "The path to a Swift Package directory")
    public var package: String?

    @Option(name: .long, help: "The path to the projects Podfile.lock")
    public var podlock: String = "./Podfile.lock"

    @Option(name: .shortAndLong, help: "The path to which the output should be written")
    public var output: String = ""

    @Flag(name: .long, help: "Include Apple frameworks in the graph (for --target and readable-source --spm packages)")
    public var apple: Bool = false

    @Flag(name: .long, help: "Include Swift Package Manager frameworks in the graph")
    public var spm: Bool = false

    @Flag(name: .long, help: "Include Cocoapods frameworks in the graph")
    public var pods: Bool = false

    @Flag(
        name: .long,
        help: "Show frameworks that no dependency manager claims to be managing (perhaps there are name discrepancies?). Using this option doesn't make sense unless you are also using all the other include flags relevant to your project."
    )
    public var force: Bool = false

    @Flag(name: .long, help: "Output json")
    public var json: Bool = false

    @Flag(name: .long, help: "Display version information about xcgrapher")
    public var version: Bool = false

    @Flag(name: .long, help: "Display verbose information")
    public var verbose: Bool = false

    var startingPoint: StartingPoint {
        if let project = project {
            return .xcodeProject(project)
        } else {
            // Should be safe due to the implementation of validate() below
            return .swiftPackage(package ?? "")
        }
    }

    public func validate() throws {
        if version {
            return
        }
        var isRunningForXcodeProject = false

        if let project = project {
            isRunningForXcodeProject = true
            guard FileManager.default.directoryExists(atPath: project) else { die("'\(project)' is not a valid xcode project.") }
        }

        if !isRunningForXcodeProject {
            guard let package = package else { die("--project or --package must be provided.") }
            guard !package.isEmpty else { die("--package is invalid") }
            guard FileManager.default.fileExists(atPath: package.appendingPathComponent("Package.swift")) else { die("'\(package)' is not a valid Swift Package directory") }
        }

        guard let target,
              !target.isEmpty else { die("--target must not be empty.") }

        if isRunningForXcodeProject {
            guard spm || apple || pods else { die("Must include at least one of --apple, --spm or --pods") }
        }
    }
}

extension XCGrapherArguments {
    var options: XCGrapherOptions {
        let currentDirectory =
            URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .standardizedFileURL
        return .init(
            currentDirectory: currentDirectory,
            startingPoint: startingPoint,
            target: target ?? "",
            podlock: podlock,
            output: output,
            apple: apple,
            spm: spm,
            pods: pods,
            force: force,
            json: json,
            verbose: verbose,
            version: version
        )
    }
}
