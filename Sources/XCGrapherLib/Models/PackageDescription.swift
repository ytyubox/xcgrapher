import Foundation

struct PackageDescription: Decodable, Equatable {
  let name: String
  let path: String
  let _targets: [Target]
  var targets:[Target] {
    _targets.map{postHandler($0, path: path)}
  }

  struct Target: Decodable,Equatable {
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
  var target = target
  target.path = path.appendingPathComponent(target.path)
  target.sources = target.sources.map { path.appendingPathComponent($0) }
  return target
}
