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
    ].filter(\.isEmpty.not)
      .joined(separator: "\n\n")
  }

  var dependenciesDescription: String {
    var s: [String] = []
    for key in dependencies.keys.sorted(by: { $0.identity < $1.identity }) {
      s.append(
        [
          """
          \(key.identity)<<\(key.url)@\(key.version)>>
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
  struct JSONEdge: Codable, Equatable {
    var a: String
    var b: String
    var tags: String
  }

  func json() -> [JSONEdge] {
    edges
      .map { edge in
        .init(a: edge.a, b: edge.b, tags: edge.tags)
      }
      .sorted(by: { ($0.a.lowercased(), $0.b.lowercased()) < ($1.a.lowercased(), $1.b.lowercased())
      })
  }
}

extension Bool {
  var not: Bool { !self }
}
