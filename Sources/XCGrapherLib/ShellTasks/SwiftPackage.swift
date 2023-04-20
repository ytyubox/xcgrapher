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

//  func groupPackageDescription() throws -> [String: [String]] {
//    let package = try decode(json: execute().data(using: .utf8)!)
//    var g: [String: [String]] = [:]
//    for target in package._targets {
//      let target_dep = target.target_dependencies ?? []
//      let product_dep = target.product_dependencies ?? []
//      g[target.name] = [target_dep, product_dep].flatMap { $0 }
//    }
//    return g
//  }
}

extension SwiftPackage: ShellTask {
  var stringRepresentation: String {
    "swift package --package-path \"\(clone)\" describe --type json"
  }

  var commandNotFoundInstructions: String {
    "Missing command 'swift'"
  }
}
