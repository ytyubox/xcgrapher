import Foundation

struct PackageDescription: Decodable, Equatable {
  let name: String
  let path: String
  let _targets: [Target]
  var targets: [Target] {
    _targets.map { postHandler($0, path: path) }
  }

  struct Target: Decodable, Equatable {
    var name: String
    var path: String
    var sources: [String]
    var target_dependencies: [String]?
    var type: String
  }

  enum CodingKeys: String, CodingKey {
    case name, path, _targets = "targets"
  }
}

// Map all target-related paths to be absolute.
private func postHandler(_ target: PackageDescription.Target, path: String) -> PackageDescription.Target {
  #if swift(>=5.4)
    let path = path.appendingPathComponent(target.path)
    let sources = target.sources.map { path.appendingPathComponent($0) }
  #else
    let path = target.path
    let sources = target.sources.map { target.path.appendingPathComponent($0) }
  #endif
  var target = target
  target.path = path
  target.sources = sources
  return target
}
