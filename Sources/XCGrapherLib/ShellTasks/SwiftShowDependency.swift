//
//  File.swift
//
//
//  Created by Yu Yu on 2023/4/20.
//

import Foundation

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
