import XCTest

@MainActor
final class SwiftPackageResolvedTests: XCTestCase {
  func test() async throws {
    let resolved = try JSONDecoder().decode(PackageResolved.self, from: resolvedJSON)
      .object.pins.map(toDependencyResolved(_:))
    XCTAssertEqual(
      resolved,

      [
        .init(
          package: "async-kit",
          repositoryURL: "https://github.com/vapor/async-kit.git",
          id: .tag("1.13.0", "c3329e444bafbb12d1d312af9191be95348a8175")
        ),
        .init(
          package: "Cryptor",
          repositoryURL: "https://github.com/IBM-Swift/BlueCryptor.git",
          id: .tag("1.0.32", "12d2bf3ec7207ec3cd004b9582f69ef5fae1da3b")
        ),
        .init(
          package: "combine-schedulers",
          repositoryURL: "https://github.com/pointfreeco/combine-schedulers",
          id: .tag("0.9.1", "882ac01eb7ef9e36d4467eb4b1151e74fcef85ab")
        ),
        .init(
          package: "postgres-kit",
          repositoryURL: "https://github.com/vapor/postgres-kit",
          id: .tag("2.2.0", "cbbe3ef8a0a8800301b8b76ab0f09dfc9e7306a2")
        ),
        .init(
          package: "postgres-nio",
          repositoryURL: "https://github.com/vapor/postgres-nio.git",
          id: .tag("1.11.0", "d648c5b4594ffbc2f6173318f70f5531e05ccb4e")
        ),
        .init(
          package: "sql-kit",
          repositoryURL: "https://github.com/vapor/sql-kit.git",
          id: .tag("3.18.0", "89b0a0a5f110e77272fb5a775064a31bfc1f155c")
        ),
        .init(
          package: "swift-backtrace",
          repositoryURL: "https://github.com/swift-server/swift-backtrace",
          id: .tag("1.2.0", "f2fd8c4845a123419c348e0bc4b3839c414077d5")
        ),
        .init(
          package: "swift-case-paths",
          repositoryURL: "https://github.com/pointfreeco/swift-case-paths",
          id: .tag("0.14.1", "fc45e7b2cfece9dd80b5a45e6469ffe67fe67984")
        ),
        .init(
          package: "swift-clocks",
          repositoryURL: "https://github.com/pointfreeco/swift-clocks",
          id: .tag("0.2.0", "20b25ca0dd88ebfb9111ec937814ddc5a8880172")
        ),
        .init(
          package: "swift-collections",
          repositoryURL: "https://github.com/apple/swift-collections",
          id: .tag("1.0.2", "48254824bb4248676bf7ce56014ff57b142b77eb")
        ),
        .init(
          package: "swift-composable-architecture",
          repositoryURL: "https://github.com/pointfreeco/swift-composable-architecture",
          id: .tag("0.52.0", "3e8eee1efe99d06e99426d421733b858b332186b")
        ),
        .init(
          package: "swift-crypto",
          repositoryURL: "https://github.com/apple/swift-crypto",
          id: .tag("1.1.7", "ddb07e896a2a8af79512543b1c7eb9797f8898a5")
        ),
        .init(
          package: "swift-custom-dump",
          repositoryURL: "https://github.com/pointfreeco/swift-custom-dump",
          id: .tag("0.10.2", "84b30e1af72e0ffe6dfbfe39d53b8173caacf224")
        ),
        .init(
          package: "swift-dependencies",
          repositoryURL: "https://github.com/pointfreeco/swift-dependencies",
          id: .tag("0.4.1", "98650d886ec950b587d671261f06d6b59dec4052")
        ),
        .init(
          package: "swift-gen",
          repositoryURL: "https://github.com/pointfreeco/swift-gen",
          id: .tag("0.4.0", "5bd20fb662e1ead7ee47df6bb0a15398295f2e06")
        ),
        .init(
          package: "swift-html",
          repositoryURL: "https://github.com/pointfreeco/swift-html",
          id: .reversion("14d01d19e43598167a8f8965af478285835ca010")
        ),
        .init(
          package: "swift-identified-collections",
          repositoryURL: "https://github.com/pointfreeco/swift-identified-collections",
          id: .tag("0.7.1", "f52eee28bdc6065aa2f8424067e6f04c74bda6e6")
        ),
        .init(
          package: "swift-log",
          repositoryURL: "https://github.com/apple/swift-log.git",
          id: .tag("1.4.2", "5d66f7ba25daf4f94100e7022febf3c75e37a6c7")
        ),
        .init(
          package: "swift-metrics",
          repositoryURL: "https://github.com/apple/swift-metrics.git",
          id: .tag("2.3.1", "1c1408bf8fc21be93713e897d2badf500ea38419")
        ),
        .init(
          package: "swift-nio",
          repositoryURL: "https://github.com/apple/swift-nio.git",
          id: .tag("2.40.0", "124119f0bb12384cef35aa041d7c3a686108722d")
        ),
        .init(
          package: "swift-nio-extras",
          repositoryURL: "https://github.com/apple/swift-nio-extras.git",
          id: .tag("1.12.1", "a75e92bde3683241c15df3dd905b7a6dcac4d551")
        ),
        .init(
          package: "swift-nio-ssl",
          repositoryURL: "https://github.com/apple/swift-nio-ssl.git",
          id: .tag("2.20.2", "c30c680c78c99afdabf84805a83c8745387c4ac7")
        ),
        .init(
          package: "swift-nio-transport-services",
          repositoryURL: "https://github.com/apple/swift-nio-transport-services.git",
          id: .tag("1.13.0", "2cb54f91ddafc90832c5fa247faf5798d0a7c204")
        ),
        .init(
          package: "Overture",
          repositoryURL: "https://github.com/pointfreeco/swift-overture",
          id: .tag("0.5.0", "7977acd7597f413717058acc1e080731249a1d7e")
        ),
        .init(
          package: "swift-parsing",
          repositoryURL: "https://github.com/pointfreeco/swift-parsing",
          id: .tag("0.10.0", "bc92e84968990b41640214b636667f35b6e5d44c")
        ),
        .init(
          package: "swift-prelude",
          repositoryURL: "https://github.com/pointfreeco/swift-prelude",
          id: .reversion("7ff9911580b2f9b7ead5375099781f28b8aad6a8")
        ),
        .init(
          package: "swift-snapshot-testing",
          repositoryURL: "https://github.com/pointfreeco/swift-snapshot-testing",
          id: .tag("1.11.0", "cef5b3f6f11781dd4591bdd1dd0a3d22bd609334")
        ),
        .init(
          package: "swift-tagged",
          repositoryURL: "https://github.com/pointfreeco/swift-tagged",
          id: .tag("0.7.0", "f3f773a5e13f3c8f0ab1ce2ae6378058acefa87d")
        ),
        .init(
          package: "swift-url-routing",
          repositoryURL: "https://github.com/pointfreeco/swift-url-routing",
          id: .tag("0.3.0", "5bf79bb370015e43842a61d558a9ee053171124e")
        ),
        .init(
          package: "swift-web",
          repositoryURL: "https://github.com/pointfreeco/swift-web",
          id: .reversion("2ad82ec94983029566d009f12dca8d235983616a")
        ),
        .init(
          package: "SwiftAWSSignatureV4",
          repositoryURL: "https://github.com/crspybits/SwiftAWSSignatureV4",
          id: .tag("1.2.1", "c66f2db1211ad1969e3d11791b9de62361c78f45")
        ),
        .init(
          package: "swiftui-navigation",
          repositoryURL: "https://github.com/pointfreeco/swiftui-navigation",
          id: .tag("0.7.1", "47dd574b900ba5ba679f56ea00d4d282fc7305a6")
        ),
        .init(
          package: "xctest-dynamic-overlay",
          repositoryURL: "https://github.com/pointfreeco/xctest-dynamic-overlay",
          id: .tag("0.8.4", "ab8c9f45843694dd16be4297e6d44c0634fd9913")
        ),
      ]
    )
  }
}

struct PackageResolved: Codable {
  let object: Object
  let version: Int
}

// MARK: - Object

struct Object: Codable {
  let pins: [Pin]
}

// MARK: - Pin

struct Pin: Codable {
  let package: String
  let repositoryURL: String
  let state: State
}

func toDependencyResolved(_ pin: Pin) -> DependencyResolved {
  let id: DependencyResolved.Id
  if let tag = pin.state.version {
    id = .tag(tag, pin.state.revision)
  } else if let branch = pin.state.branch {
    if pin.state.revision.hasPrefix(branch) {
      id = .reversion(pin.state.revision)
    } else {
      id = .branch(branch, pin.state.revision)
    }
  } else {
    id = .unowned(pin.state.branch, pin.state.revision, pin.state.version)
  }
  return .init(package: pin.package, repositoryURL: pin.repositoryURL, id: id)
}

struct DependencyResolved: Equatable {
  let package: String
  let repositoryURL: String
  let id: Id
  enum Id: Equatable {
    case branch(String, String), tag(String, String), reversion(String), unowned(String?, String, String?)
  }
}

// MARK: - State

struct State: Codable, Equatable {
  let branch: String?
  let revision: String
  let version: String?
}

private let resolvedJSON =
  """
  {
    "object": {
      "pins": [
        {
          "package": "async-kit",
          "repositoryURL": "https://github.com/vapor/async-kit.git",
          "state": {
            "branch": null,
            "revision": "c3329e444bafbb12d1d312af9191be95348a8175",
            "version": "1.13.0"
          }
        },
        {
          "package": "Cryptor",
          "repositoryURL": "https://github.com/IBM-Swift/BlueCryptor.git",
          "state": {
            "branch": null,
            "revision": "12d2bf3ec7207ec3cd004b9582f69ef5fae1da3b",
            "version": "1.0.32"
          }
        },
        {
          "package": "combine-schedulers",
          "repositoryURL": "https://github.com/pointfreeco/combine-schedulers",
          "state": {
            "branch": null,
            "revision": "882ac01eb7ef9e36d4467eb4b1151e74fcef85ab",
            "version": "0.9.1"
          }
        },
        {
          "package": "postgres-kit",
          "repositoryURL": "https://github.com/vapor/postgres-kit",
          "state": {
            "branch": null,
            "revision": "cbbe3ef8a0a8800301b8b76ab0f09dfc9e7306a2",
            "version": "2.2.0"
          }
        },
        {
          "package": "postgres-nio",
          "repositoryURL": "https://github.com/vapor/postgres-nio.git",
          "state": {
            "branch": null,
            "revision": "d648c5b4594ffbc2f6173318f70f5531e05ccb4e",
            "version": "1.11.0"
          }
        },
        {
          "package": "sql-kit",
          "repositoryURL": "https://github.com/vapor/sql-kit.git",
          "state": {
            "branch": null,
            "revision": "89b0a0a5f110e77272fb5a775064a31bfc1f155c",
            "version": "3.18.0"
          }
        },
        {
          "package": "swift-backtrace",
          "repositoryURL": "https://github.com/swift-server/swift-backtrace",
          "state": {
            "branch": null,
            "revision": "f2fd8c4845a123419c348e0bc4b3839c414077d5",
            "version": "1.2.0"
          }
        },
        {
          "package": "swift-case-paths",
          "repositoryURL": "https://github.com/pointfreeco/swift-case-paths",
          "state": {
            "branch": null,
            "revision": "fc45e7b2cfece9dd80b5a45e6469ffe67fe67984",
            "version": "0.14.1"
          }
        },
        {
          "package": "swift-clocks",
          "repositoryURL": "https://github.com/pointfreeco/swift-clocks",
          "state": {
            "branch": null,
            "revision": "20b25ca0dd88ebfb9111ec937814ddc5a8880172",
            "version": "0.2.0"
          }
        },
        {
          "package": "swift-collections",
          "repositoryURL": "https://github.com/apple/swift-collections",
          "state": {
            "branch": null,
            "revision": "48254824bb4248676bf7ce56014ff57b142b77eb",
            "version": "1.0.2"
          }
        },
        {
          "package": "swift-composable-architecture",
          "repositoryURL": "https://github.com/pointfreeco/swift-composable-architecture",
          "state": {
            "branch": null,
            "revision": "3e8eee1efe99d06e99426d421733b858b332186b",
            "version": "0.52.0"
          }
        },
        {
          "package": "swift-crypto",
          "repositoryURL": "https://github.com/apple/swift-crypto",
          "state": {
            "branch": null,
            "revision": "ddb07e896a2a8af79512543b1c7eb9797f8898a5",
            "version": "1.1.7"
          }
        },
        {
          "package": "swift-custom-dump",
          "repositoryURL": "https://github.com/pointfreeco/swift-custom-dump",
          "state": {
            "branch": null,
            "revision": "84b30e1af72e0ffe6dfbfe39d53b8173caacf224",
            "version": "0.10.2"
          }
        },
        {
          "package": "swift-dependencies",
          "repositoryURL": "https://github.com/pointfreeco/swift-dependencies",
          "state": {
            "branch": null,
            "revision": "98650d886ec950b587d671261f06d6b59dec4052",
            "version": "0.4.1"
          }
        },
        {
          "package": "swift-gen",
          "repositoryURL": "https://github.com/pointfreeco/swift-gen",
          "state": {
            "branch": null,
            "revision": "5bd20fb662e1ead7ee47df6bb0a15398295f2e06",
            "version": "0.4.0"
          }
        },
        {
          "package": "swift-html",
          "repositoryURL": "https://github.com/pointfreeco/swift-html",
          "state": {
            "branch": "14d01d1",
            "revision": "14d01d19e43598167a8f8965af478285835ca010",
            "version": null
          }
        },
        {
          "package": "swift-identified-collections",
          "repositoryURL": "https://github.com/pointfreeco/swift-identified-collections",
          "state": {
            "branch": null,
            "revision": "f52eee28bdc6065aa2f8424067e6f04c74bda6e6",
            "version": "0.7.1"
          }
        },
        {
          "package": "swift-log",
          "repositoryURL": "https://github.com/apple/swift-log.git",
          "state": {
            "branch": null,
            "revision": "5d66f7ba25daf4f94100e7022febf3c75e37a6c7",
            "version": "1.4.2"
          }
        },
        {
          "package": "swift-metrics",
          "repositoryURL": "https://github.com/apple/swift-metrics.git",
          "state": {
            "branch": null,
            "revision": "1c1408bf8fc21be93713e897d2badf500ea38419",
            "version": "2.3.1"
          }
        },
        {
          "package": "swift-nio",
          "repositoryURL": "https://github.com/apple/swift-nio.git",
          "state": {
            "branch": null,
            "revision": "124119f0bb12384cef35aa041d7c3a686108722d",
            "version": "2.40.0"
          }
        },
        {
          "package": "swift-nio-extras",
          "repositoryURL": "https://github.com/apple/swift-nio-extras.git",
          "state": {
            "branch": null,
            "revision": "a75e92bde3683241c15df3dd905b7a6dcac4d551",
            "version": "1.12.1"
          }
        },
        {
          "package": "swift-nio-ssl",
          "repositoryURL": "https://github.com/apple/swift-nio-ssl.git",
          "state": {
            "branch": null,
            "revision": "c30c680c78c99afdabf84805a83c8745387c4ac7",
            "version": "2.20.2"
          }
        },
        {
          "package": "swift-nio-transport-services",
          "repositoryURL": "https://github.com/apple/swift-nio-transport-services.git",
          "state": {
            "branch": null,
            "revision": "2cb54f91ddafc90832c5fa247faf5798d0a7c204",
            "version": "1.13.0"
          }
        },
        {
          "package": "Overture",
          "repositoryURL": "https://github.com/pointfreeco/swift-overture",
          "state": {
            "branch": null,
            "revision": "7977acd7597f413717058acc1e080731249a1d7e",
            "version": "0.5.0"
          }
        },
        {
          "package": "swift-parsing",
          "repositoryURL": "https://github.com/pointfreeco/swift-parsing",
          "state": {
            "branch": null,
            "revision": "bc92e84968990b41640214b636667f35b6e5d44c",
            "version": "0.10.0"
          }
        },
        {
          "package": "swift-prelude",
          "repositoryURL": "https://github.com/pointfreeco/swift-prelude",
          "state": {
            "branch": "7ff9911",
            "revision": "7ff9911580b2f9b7ead5375099781f28b8aad6a8",
            "version": null
          }
        },
        {
          "package": "swift-snapshot-testing",
          "repositoryURL": "https://github.com/pointfreeco/swift-snapshot-testing",
          "state": {
            "branch": null,
            "revision": "cef5b3f6f11781dd4591bdd1dd0a3d22bd609334",
            "version": "1.11.0"
          }
        },
        {
          "package": "swift-tagged",
          "repositoryURL": "https://github.com/pointfreeco/swift-tagged",
          "state": {
            "branch": null,
            "revision": "f3f773a5e13f3c8f0ab1ce2ae6378058acefa87d",
            "version": "0.7.0"
          }
        },
        {
          "package": "swift-url-routing",
          "repositoryURL": "https://github.com/pointfreeco/swift-url-routing",
          "state": {
            "branch": null,
            "revision": "5bf79bb370015e43842a61d558a9ee053171124e",
            "version": "0.3.0"
          }
        },
        {
          "package": "swift-web",
          "repositoryURL": "https://github.com/pointfreeco/swift-web",
          "state": {
            "branch": "2ad82ec",
            "revision": "2ad82ec94983029566d009f12dca8d235983616a",
            "version": null
          }
        },
        {
          "package": "SwiftAWSSignatureV4",
          "repositoryURL": "https://github.com/crspybits/SwiftAWSSignatureV4",
          "state": {
            "branch": null,
            "revision": "c66f2db1211ad1969e3d11791b9de62361c78f45",
            "version": "1.2.1"
          }
        },
        {
          "package": "swiftui-navigation",
          "repositoryURL": "https://github.com/pointfreeco/swiftui-navigation",
          "state": {
            "branch": null,
            "revision": "47dd574b900ba5ba679f56ea00d4d282fc7305a6",
            "version": "0.7.1"
          }
        },
        {
          "package": "xctest-dynamic-overlay",
          "repositoryURL": "https://github.com/pointfreeco/xctest-dynamic-overlay",
          "state": {
            "branch": null,
            "revision": "ab8c9f45843694dd16be4297e6d44c0634fd9913",
            "version": "0.8.4"
          }
        }
      ]
    },
    "version": 1
  }

  """.data(using: .utf8)!
