import Foundation

/// A class for generating a Digraph string file - e.g.
/// ```
/// digraph SomeApp {
///   "a" -> "b"
///   "b" -> "c"
/// }
/// ```
struct Digraph: Equatable {
  /// The name of the digraph structure
  let name: String

  var dependencies: [Dependency_Key: [String]] = [:]
  var idNameMapping: [String: [String]] = [:]
  var edges: [Edge] = []

  /// Adds an arrow line from `a` to `b` in the graph.
  /// - Parameters:
  ///   - a: The element the arrow should originate from
  ///   - b: The element the arrow should point to
  ///   - color: The color of the line, e.g. `#FF0000`
  mutating func addEdge(from a: String, to b: String, color: String) {
    edges.append(Edge(a: a, b: b, tags: color))
  }

  func build() -> String {
    [
      indentedEdgeStrings
        .joined(separator: "\n"),
      dependenciesDescription,
      productsDescription,
    ].filter(\.isEmpty.not)
      .joined(separator: "\n\n")
  }

  var dependenciesDescription: String {
    var s: [String] = []
    for key in dependencies.keys.sorted(by: { $0.identity < $1.identity }) {
      s.append(
        [
          """
          `\(key.name)`-\(key.identity)<<\(key.url)@\(key.version)>>
          """,
          dependencies[key]!.sorted().map { "`\($0)`" }
            .joined(separator: ","),
        ]
        .filter(\.isEmpty.not)
        .joined(separator: ": ")
      )
    }
    return s.joined(separator: "\n")
  }

  var productsDescription: String {
    var s: [String] = []
    for key in idNameMapping.keys.sorted() {
      s.append(
        """
        \(key): \(idNameMapping[key]!.map { "`\($0)`" }.joined(separator: ", "))
        """
      )
    }
    return s.joined(separator: "\n")
  }
}

extension Digraph {
  struct Edge: Equatable, Comparable {
    static func < (lhs: Digraph.Edge, rhs: Digraph.Edge) -> Bool {
      [lhs.string, rhs.string].sortedAscendingCaseInsensitively() == [lhs.string, rhs.string]
    }

    let a: String
    let b: String
    let tags: String

    var string: String {
      """
      "\(a)" -> "\(b)"
      """
    }

    func string(max: Int) -> String {
      let offset = String(repeating: " ", count: max + 4 - string.count)
      return
        """
        \(string)\(offset)// \(tags)
        """
    }
  }

  var indentedEdgeStrings: [String] {
    let max = edges.map(\.string.count).max() ?? 0

    return edges
      .map { "  ".appending($0.string(max: max)) }
      .sortedAscendingCaseInsensitively()
  }
}

extension Digraph {
  struct JSON: Codable {
    var edges: [JSONEdge]
    var products: [String: [String]]
    var dependencies: [Dep]
  }

  struct Dep: Codable, Comparable {
    static func < (lhs: Digraph.Dep, rhs: Digraph.Dep) -> Bool {
      lhs.identity < rhs.identity
    }

    var identity: String
    var name: String
    var url: String
    var version: String
    var relationship: [String]
  }

  struct JSONEdge: Codable, Equatable, Comparable {
    static func < (lhs: Digraph.JSONEdge, rhs: Digraph.JSONEdge) -> Bool {
      (
        lhs.a.lowercased(),
        lhs.b.lowercased(),
        lhs.tags.lowercased()
      )
        <
        (
          rhs.a.lowercased(),
          rhs.b.lowercased(),
          rhs.tags.lowercased()
        )
    }

    var a: String
    var b: String
    var tags: String
  }

  func json() -> JSON {
    let edges: [JSONEdge] =
      edges
        .map { edge in
          .init(a: edge.a, b: edge.b, tags: edge.tags)
        }
        .sorted()

    return .init(
      edges: edges,
      products: idNameMapping,
      dependencies: dependencies.map { key, value in
        Dep(identity: key.identity, name: key.name, url: key.url, version: key.version, relationship: value)
      }.sorted()
    )
  }
}

extension Bool {
  var not: Bool { !self }
}
