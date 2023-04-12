import Foundation

/// A class for generating a Digraph string file - e.g.
/// ```
/// digraph SomeApp {
///   "a" -> "b"
///   "b" -> "c"
/// }
/// ```
class Digraph {
  /// The name of the digraph structure
  let name: String

  private(set) var edges: [Edge] = []

  init(name: String) {
    self.name = name
  }

  /// Adds an arrow line from `a` to `b` in the graph.
  /// - Parameters:
  ///   - a: The element the arrow should originate from
  ///   - b: The element the arrow should point to
  ///   - color: The color of the line, e.g. `#FF0000`
  func addEdge(from a: String, to b: String) {
    edges.append(Edge(a: a, b: b))
  }

  /// Removes any edge with the name `a`
  func removeEdges(referencing a: String) {
    edges.removeAll {
      $0.a == a || $0.b == a
    }
  }

  func build() -> String {
    indentedEdgeStrings
      .joined(separator: "\n")
  }
}

extension Digraph {
  struct Edge {
    let a: String
    let b: String

    var string: String {
      """
      "\(a)" -> "\(b)"
      """
    }
  }

  var indentedEdgeStrings: [String] {
    edges
      .map { "  ".appending($0.string) }
      .sortedAscendingCaseInsensitively()
  }
}

extension Digraph {
  struct JSONEdge: Codable, Equatable {
    var a: String
    var b: String
  }

  func json() -> [JSONEdge] {
    edges
      .map { edge in
        .init(a: edge.a, b: edge.b)
      }
      .sorted(by: { ($0.a.lowercased(), $0.b.lowercased()) < ($1.a.lowercased(), $1.b.lowercased())
      })
  }
}
