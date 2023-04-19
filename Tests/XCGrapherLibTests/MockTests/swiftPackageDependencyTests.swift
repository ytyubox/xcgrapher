import CustomDump
@testable import XCGrapherLib
import XCTest

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

@MainActor
final class swiftPackageDependencyTests: XCTestCase {
  func test() async throws {
    let dep = try JSONDecoder().decode(Dependency.self, from: SPMDependency)
    var g: [Dependency_Key: [String]] = [:]
    func re(dep: Dependency) {
      let key = Dependency_Key(
        identity: dep.identity,
        name: dep.name,
        url: dep.url,
        version: dep.version,
        path: dep.path
      )
      if g[key] != nil { return }
      g[key] = dep.dependencies.map(\.identity)
      for d in dep.dependencies {
        re(dep: d)
      }
    }
    for d in dep.dependencies {
      re(dep: d)
    }

    XCTAssertEqual(
      g,
      [
        .init(
          identity: "swift-log",
          name: "swift-log",
          url: "https://github.com/apple/swift-log.git",
          version: "1.4.2",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-log"
        ): [],
        .init(
          identity: "swift-prelude",
          name: "swift-prelude",
          url: "https://github.com/pointfreeco/swift-prelude",
          version: "unspecified",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-prelude"
        ): [],
        .init(
          identity: "swift-snapshot-testing",
          name: "swift-snapshot-testing",
          url: "https://github.com/pointfreeco/swift-snapshot-testing",
          version: "1.11.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-snapshot-testing"
        ): [],
        .init(
          identity: "swift-custom-dump",
          name: "swift-custom-dump",
          url: "https://github.com/pointfreeco/swift-custom-dump",
          version: "0.10.2",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-custom-dump"
        ): ["xctest-dynamic-overlay"],
        .init(
          identity: "swift-clocks",
          name: "swift-clocks",
          url: "https://github.com/pointfreeco/swift-clocks",
          version: "0.2.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-clocks"
        ): ["xctest-dynamic-overlay"],
        .init(
          identity: "swift-composable-architecture",
          name: "swift-composable-architecture",
          url: "https://github.com/pointfreeco/swift-composable-architecture",
          version: "0.52.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-composable-architecture"
        ): [
          "combine-schedulers",
          "swift-case-paths",
          "swift-collections",
          "swift-custom-dump",
          "swift-dependencies",
          "swift-identified-collections",
          "swiftui-navigation",
          "xctest-dynamic-overlay",
        ],
        .init(
          identity: "xctest-dynamic-overlay",
          name: "xctest-dynamic-overlay",
          url: "https://github.com/pointfreeco/xctest-dynamic-overlay",
          version: "0.8.4",
          path: "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay"
        ): [],
        .init(
          identity: "bluecryptor",
          name: "Cryptor",
          url: "https://github.com/IBM-Swift/BlueCryptor.git",
          version: "1.0.32",
          path: "/Users/yuyu/code/isowords/.build/checkouts/BlueCryptor"
        ): [],
        .init(
          identity: "swift-gen",
          name: "swift-gen",
          url: "https://github.com/pointfreeco/swift-gen",
          version: "0.4.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-gen"
        ): [],
        .init(
          identity: "swift-metrics",
          name: "swift-metrics",
          url: "https://github.com/apple/swift-metrics.git",
          version: "2.3.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-metrics"
        ): [],
        .init(
          identity: "async-kit",
          name: "async-kit",
          url: "https://github.com/vapor/async-kit.git",
          version: "1.13.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/async-kit"
        ): ["swift-nio", "swift-log"],
        .init(
          identity: "swift-identified-collections",
          name: "swift-identified-collections",
          url: "https://github.com/pointfreeco/swift-identified-collections",
          version: "0.7.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-identified-collections"
        ): ["swift-collections"],
        .init(
          identity: "swift-url-routing",
          name: "swift-url-routing",
          url: "https://github.com/pointfreeco/swift-url-routing",
          version: "0.3.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-url-routing"
        ): ["swift-parsing", "xctest-dynamic-overlay"],
        .init(
          identity: "swift-case-paths",
          name: "swift-case-paths",
          url: "https://github.com/pointfreeco/swift-case-paths",
          version: "0.14.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-case-paths"
        ): ["xctest-dynamic-overlay"],
        .init(
          identity: "swiftawssignaturev4",
          name: "SwiftAWSSignatureV4",
          url: "https://github.com/crspybits/SwiftAWSSignatureV4",
          version: "1.2.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/SwiftAWSSignatureV4"
        ): ["bluecryptor"],
        .init(
          identity: "swift-dependencies",
          name: "swift-dependencies",
          url: "https://github.com/pointfreeco/swift-dependencies",
          version: "0.4.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-dependencies"
        ): ["combine-schedulers", "swift-clocks", "xctest-dynamic-overlay"],
        .init(
          identity: "swift-nio-ssl",
          name: "swift-nio-ssl",
          url: "https://github.com/apple/swift-nio-ssl.git",
          version: "2.20.2",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-nio-ssl"
        ): ["swift-nio"],
        .init(
          identity: "sql-kit",
          name: "sql-kit",
          url: "https://github.com/vapor/sql-kit.git",
          version: "3.18.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/sql-kit"
        ): ["swift-nio", "swift-log"],
        .init(
          identity: "swift-tagged",
          name: "swift-tagged",
          url: "https://github.com/pointfreeco/swift-tagged",
          version: "0.7.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-tagged"
        ): [],
        .init(
          identity: "postgres-kit",
          name: "postgres-kit",
          url: "https://github.com/vapor/postgres-kit",
          version: "2.2.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/postgres-kit"
        ): ["postgres-nio", "sql-kit", "async-kit"],
        .init(
          identity: "swift-html",
          name: "swift-html",
          url: "https://github.com/pointfreeco/swift-html",
          version: "unspecified",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-html"
        ): ["swift-snapshot-testing"],
        .init(
          identity: "swift-collections",
          name: "swift-collections",
          url: "https://github.com/apple/swift-collections",
          version: "1.0.2",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-collections"
        ): [],
        .init(
          identity: "swift-parsing",
          name: "swift-parsing",
          url: "https://github.com/pointfreeco/swift-parsing",
          version: "0.10.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-parsing"
        ): ["swift-case-paths", "xctest-dynamic-overlay"],
        .init(
          identity: "swift-nio",
          name: "swift-nio",
          url: "https://github.com/apple/swift-nio.git",
          version: "2.40.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-nio"
        ): [],
        .init(
          identity: "swift-crypto",
          name: "swift-crypto",
          url: "https://github.com/apple/swift-crypto",
          version: "1.1.7",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-crypto"
        ): [],
        .init(
          identity: "swiftui-navigation",
          name: "swiftui-navigation",
          url: "https://github.com/pointfreeco/swiftui-navigation",
          version: "0.7.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swiftui-navigation"
        ): ["swift-case-paths", "swift-custom-dump", "xctest-dynamic-overlay"],
        .init(
          identity: "swift-overture",
          name: "Overture",
          url: "https://github.com/pointfreeco/swift-overture",
          version: "0.5.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-overture"
        ): [],
        .init(
          identity: "combine-schedulers",
          name: "combine-schedulers",
          url: "https://github.com/pointfreeco/combine-schedulers",
          version: "0.9.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/combine-schedulers"
        ): ["xctest-dynamic-overlay"],
        .init(
          identity: "swift-backtrace",
          name: "swift-backtrace",
          url: "https://github.com/swift-server/swift-backtrace",
          version: "1.2.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-backtrace"
        ): [],
        .init(
          identity: "swift-nio-extras",
          name: "swift-nio-extras",
          url: "https://github.com/apple/swift-nio-extras.git",
          version: "1.12.1",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-nio-extras"
        ): ["swift-nio"],
        .init(
          identity: "postgres-nio",
          name: "postgres-nio",
          url: "https://github.com/vapor/postgres-nio.git",
          version: "1.11.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/postgres-nio"
        ): ["swift-nio", "swift-nio-transport-services", "swift-nio-ssl", "swift-crypto", "swift-metrics", "swift-log"],
        .init(
          identity: "swift-web",
          name: "swift-web",
          url: "https://github.com/pointfreeco/swift-web",
          version: "unspecified",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-web"
        ): [
          "swift-html",
          "swift-prelude",
          "swift-snapshot-testing",
          "swift-crypto",
          "swift-nio",
          "swift-nio-extras",
          "bluecryptor",
        ],
        .init(
          identity: "swift-nio-transport-services",
          name: "swift-nio-transport-services",
          url: "https://github.com/apple/swift-nio-transport-services.git",
          version: "1.13.0",
          path: "/Users/yuyu/code/isowords/.build/checkouts/swift-nio-transport-services"
        ): ["swift-nio"],
      ]
    )
  }
}

let SPMDependency =
  """
  {
    "identity": "isowords",
    "name": "isowords",
    "url": "/Users/yuyu/code/isowords",
    "version": "unspecified",
    "path": "/Users/yuyu/code/isowords",
    "dependencies": [
      {
        "identity": "swift-crypto",
        "name": "swift-crypto",
        "url": "https://github.com/apple/swift-crypto",
        "version": "1.1.7",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-crypto",
        "dependencies": [

        ]
      },
      {
        "identity": "swift-case-paths",
        "name": "swift-case-paths",
        "url": "https://github.com/pointfreeco/swift-case-paths",
        "version": "0.14.1",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-case-paths",
        "dependencies": [
          {
            "identity": "xctest-dynamic-overlay",
            "name": "xctest-dynamic-overlay",
            "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
            "version": "0.8.4",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "swift-composable-architecture",
        "name": "swift-composable-architecture",
        "url": "https://github.com/pointfreeco/swift-composable-architecture",
        "version": "0.52.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-composable-architecture",
        "dependencies": [
          {
            "identity": "combine-schedulers",
            "name": "combine-schedulers",
            "url": "https://github.com/pointfreeco/combine-schedulers",
            "version": "0.9.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/combine-schedulers",
            "dependencies": [
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "swift-case-paths",
            "name": "swift-case-paths",
            "url": "https://github.com/pointfreeco/swift-case-paths",
            "version": "0.14.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-case-paths",
            "dependencies": [
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "swift-collections",
            "name": "swift-collections",
            "url": "https://github.com/apple/swift-collections",
            "version": "1.0.2",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-collections",
            "dependencies": [

            ]
          },
          {
            "identity": "swift-custom-dump",
            "name": "swift-custom-dump",
            "url": "https://github.com/pointfreeco/swift-custom-dump",
            "version": "0.10.2",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-custom-dump",
            "dependencies": [
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "swift-dependencies",
            "name": "swift-dependencies",
            "url": "https://github.com/pointfreeco/swift-dependencies",
            "version": "0.4.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-dependencies",
            "dependencies": [
              {
                "identity": "combine-schedulers",
                "name": "combine-schedulers",
                "url": "https://github.com/pointfreeco/combine-schedulers",
                "version": "0.9.1",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/combine-schedulers",
                "dependencies": [
                  {
                    "identity": "xctest-dynamic-overlay",
                    "name": "xctest-dynamic-overlay",
                    "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                    "version": "0.8.4",
                    "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                    "dependencies": [

                    ]
                  }
                ]
              },
              {
                "identity": "swift-clocks",
                "name": "swift-clocks",
                "url": "https://github.com/pointfreeco/swift-clocks",
                "version": "0.2.0",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-clocks",
                "dependencies": [
                  {
                    "identity": "xctest-dynamic-overlay",
                    "name": "xctest-dynamic-overlay",
                    "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                    "version": "0.8.4",
                    "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                    "dependencies": [

                    ]
                  }
                ]
              },
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "swift-identified-collections",
            "name": "swift-identified-collections",
            "url": "https://github.com/pointfreeco/swift-identified-collections",
            "version": "0.7.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-identified-collections",
            "dependencies": [
              {
                "identity": "swift-collections",
                "name": "swift-collections",
                "url": "https://github.com/apple/swift-collections",
                "version": "1.0.2",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-collections",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "swiftui-navigation",
            "name": "swiftui-navigation",
            "url": "https://github.com/pointfreeco/swiftui-navigation",
            "version": "0.7.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swiftui-navigation",
            "dependencies": [
              {
                "identity": "swift-case-paths",
                "name": "swift-case-paths",
                "url": "https://github.com/pointfreeco/swift-case-paths",
                "version": "0.14.1",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-case-paths",
                "dependencies": [
                  {
                    "identity": "xctest-dynamic-overlay",
                    "name": "xctest-dynamic-overlay",
                    "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                    "version": "0.8.4",
                    "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                    "dependencies": [

                    ]
                  }
                ]
              },
              {
                "identity": "swift-custom-dump",
                "name": "swift-custom-dump",
                "url": "https://github.com/pointfreeco/swift-custom-dump",
                "version": "0.10.2",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-custom-dump",
                "dependencies": [
                  {
                    "identity": "xctest-dynamic-overlay",
                    "name": "xctest-dynamic-overlay",
                    "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                    "version": "0.8.4",
                    "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                    "dependencies": [

                    ]
                  }
                ]
              },
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "xctest-dynamic-overlay",
            "name": "xctest-dynamic-overlay",
            "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
            "version": "0.8.4",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "swift-custom-dump",
        "name": "swift-custom-dump",
        "url": "https://github.com/pointfreeco/swift-custom-dump",
        "version": "0.10.2",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-custom-dump",
        "dependencies": [
          {
            "identity": "xctest-dynamic-overlay",
            "name": "xctest-dynamic-overlay",
            "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
            "version": "0.8.4",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "swift-dependencies",
        "name": "swift-dependencies",
        "url": "https://github.com/pointfreeco/swift-dependencies",
        "version": "0.4.1",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-dependencies",
        "dependencies": [
          {
            "identity": "combine-schedulers",
            "name": "combine-schedulers",
            "url": "https://github.com/pointfreeco/combine-schedulers",
            "version": "0.9.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/combine-schedulers",
            "dependencies": [
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "swift-clocks",
            "name": "swift-clocks",
            "url": "https://github.com/pointfreeco/swift-clocks",
            "version": "0.2.0",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-clocks",
            "dependencies": [
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "xctest-dynamic-overlay",
            "name": "xctest-dynamic-overlay",
            "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
            "version": "0.8.4",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "swift-gen",
        "name": "swift-gen",
        "url": "https://github.com/pointfreeco/swift-gen",
        "version": "0.4.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-gen",
        "dependencies": [

        ]
      },
      {
        "identity": "swift-parsing",
        "name": "swift-parsing",
        "url": "https://github.com/pointfreeco/swift-parsing",
        "version": "0.10.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-parsing",
        "dependencies": [
          {
            "identity": "swift-case-paths",
            "name": "swift-case-paths",
            "url": "https://github.com/pointfreeco/swift-case-paths",
            "version": "0.14.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-case-paths",
            "dependencies": [
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "xctest-dynamic-overlay",
            "name": "xctest-dynamic-overlay",
            "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
            "version": "0.8.4",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "swift-tagged",
        "name": "swift-tagged",
        "url": "https://github.com/pointfreeco/swift-tagged",
        "version": "0.7.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-tagged",
        "dependencies": [

        ]
      },
      {
        "identity": "swift-url-routing",
        "name": "swift-url-routing",
        "url": "https://github.com/pointfreeco/swift-url-routing",
        "version": "0.3.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-url-routing",
        "dependencies": [
          {
            "identity": "swift-parsing",
            "name": "swift-parsing",
            "url": "https://github.com/pointfreeco/swift-parsing",
            "version": "0.10.0",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-parsing",
            "dependencies": [
              {
                "identity": "swift-case-paths",
                "name": "swift-case-paths",
                "url": "https://github.com/pointfreeco/swift-case-paths",
                "version": "0.14.1",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-case-paths",
                "dependencies": [
                  {
                    "identity": "xctest-dynamic-overlay",
                    "name": "xctest-dynamic-overlay",
                    "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                    "version": "0.8.4",
                    "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                    "dependencies": [

                    ]
                  }
                ]
              },
              {
                "identity": "xctest-dynamic-overlay",
                "name": "xctest-dynamic-overlay",
                "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
                "version": "0.8.4",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "xctest-dynamic-overlay",
            "name": "xctest-dynamic-overlay",
            "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
            "version": "0.8.4",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "xctest-dynamic-overlay",
        "name": "xctest-dynamic-overlay",
        "url": "https://github.com/pointfreeco/xctest-dynamic-overlay",
        "version": "0.8.4",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/xctest-dynamic-overlay",
        "dependencies": [

        ]
      },
      {
        "identity": "swift-overture",
        "name": "Overture",
        "url": "https://github.com/pointfreeco/swift-overture",
        "version": "0.5.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-overture",
        "dependencies": [

        ]
      },
      {
        "identity": "swift-snapshot-testing",
        "name": "swift-snapshot-testing",
        "url": "https://github.com/pointfreeco/swift-snapshot-testing",
        "version": "1.11.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-snapshot-testing",
        "dependencies": [

        ]
      },
      {
        "identity": "swiftawssignaturev4",
        "name": "SwiftAWSSignatureV4",
        "url": "https://github.com/crspybits/SwiftAWSSignatureV4",
        "version": "1.2.1",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/SwiftAWSSignatureV4",
        "dependencies": [
          {
            "identity": "bluecryptor",
            "name": "Cryptor",
            "url": "https://github.com/IBM-Swift/BlueCryptor.git",
            "version": "1.0.32",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/BlueCryptor",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "swift-backtrace",
        "name": "swift-backtrace",
        "url": "https://github.com/swift-server/swift-backtrace",
        "version": "1.2.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-backtrace",
        "dependencies": [

        ]
      },
      {
        "identity": "postgres-kit",
        "name": "postgres-kit",
        "url": "https://github.com/vapor/postgres-kit",
        "version": "2.2.0",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/postgres-kit",
        "dependencies": [
          {
            "identity": "postgres-nio",
            "name": "postgres-nio",
            "url": "https://github.com/vapor/postgres-nio.git",
            "version": "1.11.0",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/postgres-nio",
            "dependencies": [
              {
                "identity": "swift-nio",
                "name": "swift-nio",
                "url": "https://github.com/apple/swift-nio.git",
                "version": "2.40.0",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio",
                "dependencies": [

                ]
              },
              {
                "identity": "swift-nio-transport-services",
                "name": "swift-nio-transport-services",
                "url": "https://github.com/apple/swift-nio-transport-services.git",
                "version": "1.13.0",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio-transport-services",
                "dependencies": [
                  {
                    "identity": "swift-nio",
                    "name": "swift-nio",
                    "url": "https://github.com/apple/swift-nio.git",
                    "version": "2.40.0",
                    "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio",
                    "dependencies": [

                    ]
                  }
                ]
              },
              {
                "identity": "swift-nio-ssl",
                "name": "swift-nio-ssl",
                "url": "https://github.com/apple/swift-nio-ssl.git",
                "version": "2.20.2",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio-ssl",
                "dependencies": [
                  {
                    "identity": "swift-nio",
                    "name": "swift-nio",
                    "url": "https://github.com/apple/swift-nio.git",
                    "version": "2.40.0",
                    "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio",
                    "dependencies": [

                    ]
                  }
                ]
              },
              {
                "identity": "swift-crypto",
                "name": "swift-crypto",
                "url": "https://github.com/apple/swift-crypto",
                "version": "1.1.7",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-crypto",
                "dependencies": [

                ]
              },
              {
                "identity": "swift-metrics",
                "name": "swift-metrics",
                "url": "https://github.com/apple/swift-metrics.git",
                "version": "2.3.1",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-metrics",
                "dependencies": [

                ]
              },
              {
                "identity": "swift-log",
                "name": "swift-log",
                "url": "https://github.com/apple/swift-log.git",
                "version": "1.4.2",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-log",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "sql-kit",
            "name": "sql-kit",
            "url": "https://github.com/vapor/sql-kit.git",
            "version": "3.18.0",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/sql-kit",
            "dependencies": [
              {
                "identity": "swift-nio",
                "name": "swift-nio",
                "url": "https://github.com/apple/swift-nio.git",
                "version": "2.40.0",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio",
                "dependencies": [

                ]
              },
              {
                "identity": "swift-log",
                "name": "swift-log",
                "url": "https://github.com/apple/swift-log.git",
                "version": "1.4.2",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-log",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "async-kit",
            "name": "async-kit",
            "url": "https://github.com/vapor/async-kit.git",
            "version": "1.13.0",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/async-kit",
            "dependencies": [
              {
                "identity": "swift-nio",
                "name": "swift-nio",
                "url": "https://github.com/apple/swift-nio.git",
                "version": "2.40.0",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio",
                "dependencies": [

                ]
              },
              {
                "identity": "swift-log",
                "name": "swift-log",
                "url": "https://github.com/apple/swift-log.git",
                "version": "1.4.2",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-log",
                "dependencies": [

                ]
              }
            ]
          }
        ]
      },
      {
        "identity": "swift-prelude",
        "name": "swift-prelude",
        "url": "https://github.com/pointfreeco/swift-prelude",
        "version": "unspecified",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-prelude",
        "dependencies": [

        ]
      },
      {
        "identity": "swift-web",
        "name": "swift-web",
        "url": "https://github.com/pointfreeco/swift-web",
        "version": "unspecified",
        "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-web",
        "dependencies": [
          {
            "identity": "swift-html",
            "name": "swift-html",
            "url": "https://github.com/pointfreeco/swift-html",
            "version": "unspecified",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-html",
            "dependencies": [
              {
                "identity": "swift-snapshot-testing",
                "name": "swift-snapshot-testing",
                "url": "https://github.com/pointfreeco/swift-snapshot-testing",
                "version": "1.11.0",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-snapshot-testing",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "swift-prelude",
            "name": "swift-prelude",
            "url": "https://github.com/pointfreeco/swift-prelude",
            "version": "unspecified",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-prelude",
            "dependencies": [

            ]
          },
          {
            "identity": "swift-snapshot-testing",
            "name": "swift-snapshot-testing",
            "url": "https://github.com/pointfreeco/swift-snapshot-testing",
            "version": "1.11.0",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-snapshot-testing",
            "dependencies": [

            ]
          },
          {
            "identity": "swift-crypto",
            "name": "swift-crypto",
            "url": "https://github.com/apple/swift-crypto",
            "version": "1.1.7",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-crypto",
            "dependencies": [

            ]
          },
          {
            "identity": "swift-nio",
            "name": "swift-nio",
            "url": "https://github.com/apple/swift-nio.git",
            "version": "2.40.0",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio",
            "dependencies": [

            ]
          },
          {
            "identity": "swift-nio-extras",
            "name": "swift-nio-extras",
            "url": "https://github.com/apple/swift-nio-extras.git",
            "version": "1.12.1",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio-extras",
            "dependencies": [
              {
                "identity": "swift-nio",
                "name": "swift-nio",
                "url": "https://github.com/apple/swift-nio.git",
                "version": "2.40.0",
                "path": "/Users/yuyu/code/isowords/.build/checkouts/swift-nio",
                "dependencies": [

                ]
              }
            ]
          },
          {
            "identity": "bluecryptor",
            "name": "Cryptor",
            "url": "https://github.com/IBM-Swift/BlueCryptor.git",
            "version": "1.0.32",
            "path": "/Users/yuyu/code/isowords/.build/checkouts/BlueCryptor",
            "dependencies": [

            ]
          }
        ]
      }
    ]
  }

  """.data(using: .utf8)!
