import Foundation
struct XcodeprojGetLocalPackages {
  let projectFile: FileManager.Path

  func localPackages() throws -> [URL] {
    try execute()
      .breakIntoLines()
      .compactMap(URL.init)
      .filter { FileManager.default.fileExists(atPath: $0.appendingPathComponent("Package.swift").absoluteString) }
  }
}

extension XcodeprojGetLocalPackages: ShellTask {
  var stringRepresentation: String {
    Ruby(
      require: "xcodeproj",
      script:
      """
      require "Xcodeproj"

      projectFile = "\(projectFile)"

      project = Xcodeproj::Project.open(projectFile)

      for object in project.objects
          if object.isa == "PBXFileReference"
              if ["wrapper", "folder"].include? object.last_known_file_type.to_s
                  puts object.real_path.to_s
              end
          end
      end
      """
    )
    .stringRepresentation
  }

  var commandNotFoundInstructions: String {
    "Missing command 'xcodeproj' - install it with `gem install xcodeproj` or see https://github.com/CocoaPods/Xcodeproj"
  }
}
