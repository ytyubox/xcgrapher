//
//  File.swift
//
//
//  Created by Yu Yu on 2023/4/20.
//

import Foundation
struct SwiftShowDependency {
  let clone: String

  func loadDependency() throws -> Dependency {
    let json = try execute().data(using: .utf8)!
    return try JSONDecoder().decode(Dependency.self, from: json)
  }
}

extension SwiftShowDependency: ShellTask {
  var stringRepresentation: String {
    """
    swift package --package-path "\(clone)" show --type json
    """
  }

  var commandNotFoundInstructions: String {
    "Missing command 'swift'"
  }
}

struct Dependency: Codable {
  let identity, name: String
  let url: String
  let version, path: String
  let dependencies: [Dependency]
}

struct Dependency_Key: Hashable {
  let identity, name: String
  let url: String
  let version, path: String
}
