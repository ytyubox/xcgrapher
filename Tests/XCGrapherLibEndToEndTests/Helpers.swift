import class Foundation.Bundle
@testable import XCGrapherLib
import XCTest

struct Edge: Hashable {
  var a, b: String
}

/// Asserts that the `digraph` is made up of **ONLY** the `edges` and nothing more
func XCGrapherAssertDigraphIsMadeFromEdges(
  _ digraph: String,
  _ edges: [(String, String)],
  file: StaticString = #file,
  line: UInt = #line
) {
  var digraphEdgeStrings = digraph
    .breakIntoLines()
    .filter { $0.contains("\" -> \"") } // We only care about the lines that contain `"X" -> "Y"`
  let edges = edges.map(Edge.init).unique()

  for edge in edges {
    let (edgeFrom, edgeTo) = (edge.a, edge.b)
    let expectedEdge = "\"\(edgeFrom)\" -> \"\(edgeTo)\""
    guard let lineWithExpectedEdge = digraphEdgeStrings.firstIndex(where: { $0.contains(expectedEdge) }) else {
      XCTFail(
        """
        The digraph does not contain the edge \(expectedEdge)
        - edges: \(edges.map { "\($0)" }.joined(separator: "\n"))
        """, file: file, line: line
      )
      continue
    }
    digraphEdgeStrings.remove(at: lineWithExpectedEdge)
  }

  if !digraphEdgeStrings.isEmpty {
    XCTFail("The digraph contains unexpected edges: \(digraphEdgeStrings)", file: file, line: line)
  }
}

/// Finds the location of the products that were built in order for the test to run
func productsDirectory() -> String {
  Bundle.allBundles
    .first { $0.bundlePath.hasSuffix(".xctest") }!
    .bundleURL
    .deletingLastPathComponent()
    .path
}

func defaultXCGrapherPluginLocation() -> String {
  productsDirectory()
    .appendingPathComponent("PackageFrameworks")
    .appendingPathComponent("XCGrapherModuleImportPlugin.framework")
    .appendingPathComponent("XCGrapherModuleImportPlugin")
}

extension Array where Element: CustomStringConvertible {
  var lines: String {
    map(\.description).sorted().joined(separator: "\n")
  }
}
