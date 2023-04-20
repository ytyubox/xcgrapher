import Foundation

struct SwiftPackage {
  let clone: FileManager.Path
  func decode(json: Data) throws -> PackageDescription {
    return try JSONDecoder().decode(PackageDescription.self, from: json)
  }

  func packageDescription() throws -> PackageDescription {
    let json = try execute().data(using: .utf8)!

    return try decode(json: json)
  }
}

extension SwiftPackage: ShellTask {
  var stringRepresentation: String {
    "swift package --package-path \"\(clone)\" describe --type json"
  }

  var commandNotFoundInstructions: String {
    "Missing command 'swift'"
  }
}
