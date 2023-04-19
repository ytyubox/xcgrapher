import CustomDump
import Foundation
@testable import XCGrapherLib
import XCTest

func groupPackageDescription(_ package: PackageDescription) -> [String: [String]] {
  var g: [String: [String]] = [:]
  for target in package._targets {
    let target_dep = target.target_dependencies ?? []
    let product_dep = target.product_dependencies ?? []
    g[target.name] = [target_dep, product_dep].flatMap { $0 }
  }
  return g
}

@MainActor
final class SPMTests: XCTestCase {
  func testSomePackage() async throws {
    let package = try SwiftPackage(clone: "").decode(json: SomePackageSPMJSON)
    let g = groupPackageDescription(package)

    XCTAssertNoDifference(g, [
      "Core": ["CasePaths"],
      "SomePackage": ["Core", "Kingfisher", "Moya", "Alamofire"],
      "SomePackageTests": ["SomePackage"],
    ])
  }

  func test() async throws {
    let package = try SwiftPackage(clone: "").decode(json: ISOWORDSSPMJSON)
    let g = groupPackageDescription(package)

    XCTAssertEqual(
      g,
      [
        "DemoFeature": ["ApiClient", "Build", "GameCore", "DictionaryClient", "FeedbackGeneratorClient",
                        "LowPowerModeClient", "OnboardingFeature", "SharedModels", "UserDefaultsClient",
                        "ComposableArchitecture"],
        "daily-challenge-reports": ["DailyChallengeReports"],
        "SelectionSoundsCore": ["AudioPlayerClient", "SharedModels", "TcaHelpers", "ComposableArchitecture"],
        "MultiplayerFeature": ["ClientModels", "ComposableGameCenter", "Styleguide", "TcaHelpers",
                               "ComposableArchitecture"],
        "DatabaseLiveTests": ["DatabaseLive", "FirstPartyMocks", "TestHelpers", "CustomDump"],
        "TestHelpers": [],
        "SiteMiddleware": ["AppSiteAssociationMiddleware", "DailyChallengeMiddleware", "DatabaseClient",
                           "DemoMiddleware", "EnvVars", "LeaderboardMiddleware", "MailgunClient", "MiddlewareHelpers",
                           "PushMiddleware",
                           "ServerConfig", "ServerConfigMiddleware", "SharedModels", "ShareGameMiddleware",
                           "SnsClient",
                           "VerifyReceiptMiddleware", "HttpPipeline", "Overture", "XCTestDynamicOverlay"],
        "VerifyReceiptMiddleware": ["DatabaseClient", "MiddlewareHelpers", "ServerRouter", "ServerTestHelpers",
                                    "SharedModels", "HttpPipeline", "Overture"],
        "SoloFeature": ["ClientModels", "FileClient", "SharedModels", "Styleguide", "ComposableArchitecture"],
        "DictionaryFileClient": ["DictionaryClient", "Gzip", "PuzzleGen"],
        "SharedSwiftUIEnvironment": [],
        "ServerConfig": ["Build"],
        "DictionaryClient": ["SharedModels", "Dependencies", "XCTestDynamicOverlay"],
        "DemoMiddleware": ["DatabaseClient", "DictionaryClient", "MiddlewareHelpers", "SharedModels", "HttpPipeline"],
        "SharedModelsTests": ["FirstPartyMocks", "SharedModels", "TestHelpers", "Overture", "SnapshotTesting"],
        "SettingsFeatureTests": ["TestHelpers", "SettingsFeature", "SnapshotTesting"],
        "EnvVars": ["SnsClient", "Tagged"],
        "LowPowerModeClient": ["ComposableArchitecture"],
        "TrailerFeature": ["ApiClient", "Bloom", "CubeCore", "GameCore", "DictionaryClient",
                           "FeedbackGeneratorClient",
                           "LowPowerModeClient", "OnboardingFeature", "SharedModels", "TcaHelpers",
                           "UserDefaultsClient",
                           "ComposableArchitecture"],
        "DailyChallengeMiddleware": ["DatabaseClient", "MiddlewareHelpers", "SharedModels", "HttpPipeline"],
        "ClientModels": ["ComposableGameCenter", "SharedModels"],
        "BottomMenu": ["Styleguide", "ComposableArchitecture"],
        "RemoteNotificationsClient": ["ComposableArchitecture", "XCTestDynamicOverlay"],
        "Sqlite": ["Csqlite3"],
        "MultiplayerFeatureTests": ["MultiplayerFeature", "TestHelpers"],
        "ComposableGameCenter": ["CombineHelpers", "FirstPartyMocks", "ComposableArchitecture", "Overture", "Tagged",
                                 "XCTestDynamicOverlay"],
        "AppFeatureTests": ["AppFeature", "TestHelpers"],
        "DatabaseLive": ["DatabaseClient", "CasePaths", "Overture", "Prelude", "PostgresKit"],
        "AppAudioLibrary": [],
        "DailyChallengeHelpers": ["ApiClient", "FileClient", "SharedModels", "ComposableArchitecture"],
        "DateHelpers": [],
        "AppSiteAssociationMiddlewareTests": ["AppSiteAssociationMiddleware", "SiteMiddleware",
                                              "HttpPipelineTestSupport", "SnapshotTesting"],
        "ServerTestHelpers": ["Either", "XCTestDynamicOverlay"],
        "Gzip": ["system-zlib"],
        "AppClipAudioLibrary": [],
        "server": ["ServerBootstrap", "SiteMiddleware", "HttpPipeline"],
        "DictionaryFileClientTests": ["DictionaryFileClient"],
        "DailyChallengeReports": ["ServerBootstrap"],
        "TcaHelpers": ["ComposableArchitecture"],
        "GameCore": ["ActiveGamesFeature", "ApiClient", "AudioPlayerClient", "Bloom", "BottomMenu", "Build",
                     "ClientModels", "ComposableGameCenter", "ComposableUserNotifications", "CubeCore",
                     "DictionaryClient",
                     "GameOverFeature", "FeedbackGeneratorClient", "FileClient", "HapticsCore", "LowPowerModeClient",
                     "PuzzleGen",
                     "RemoteNotificationsClient", "SelectionSoundsCore", "SharedSwiftUIEnvironment", "Styleguide",
                     "TcaHelpers",
                     "UIApplicationClient", "UpgradeInterstitialFeature", "ComposableArchitecture"],
        "LeaderboardFeature": ["ApiClient", "AudioPlayerClient", "CubePreview", "LowPowerModeClient", "Styleguide",
                               "SwiftUIHelpers", "ComposableArchitecture", "Overture"],
        "ServerBootstrap": ["DatabaseLive", "DictionarySqliteClient", "EnvVars", "ServerConfig", "SiteMiddleware",
                            "SnsClientLive", "Backtrace", "Crypto"],
        "FileClient": ["ClientModels", "CombineHelpers", "XCTestDebugSupport", "ComposableArchitecture",
                       "XCTestDynamicOverlay"],
        "GameCoreTests": ["GameCore", "TestHelpers", "SnapshotTesting"],
        "UpgradeInterstitialFeatureTests": ["FirstPartyMocks", "UpgradeInterstitialFeature", "Overture",
                                            "SnapshotTesting"],
        "ServerConfigMiddlewareTests": ["ServerConfigMiddleware", "SiteMiddleware", "Either", "HttpPipeline",
                                        "HttpPipelineTestSupport", "Prelude"],
        "MiddlewareHelpers": ["EnvVars", "HttpPipeline"],
        "CubePreviewTests": ["CubePreview", "TestHelpers"],
        "AppSiteAssociationMiddleware": ["HttpPipeline"],
        "MailgunClient": ["ServerTestHelpers", "Either", "Tagged", "UrlFormEncoding"],
        "SnsClientLive": ["SnsClient", "SwiftAWSSignatureV4"],
        "PushMiddlewareTests": ["DatabaseClient", "PushMiddleware", "ServerRouter", "SharedModels", "SiteMiddleware",
                                "CustomDump", "Either", "HttpPipeline", "HttpPipelineTestSupport", "Overture",
                                "Prelude", "SnapshotTesting"],
        "DatabaseClient": ["Build", "ServerTestHelpers", "SharedModels", "SnsClient", "Either",
                           "XCTestDynamicOverlay"],
        "OnboardingFeatureTests": ["OnboardingFeature"],
        "UpgradeInterstitialFeature": ["CombineHelpers", "ComposableStoreKit", "ServerConfigClient", "Styleguide",
                                       "SwiftUIHelpers", "ComposableArchitecture"],
        "DeviceId": ["Dependencies", "XCTestDynamicOverlay"],
        "ShareGameMiddlewareTests": ["ShareGameMiddleware", "SiteMiddleware", "TestHelpers",
                                     "HttpPipelineTestSupport",
                                     "SnapshotTesting"],
        "LeaderboardMiddlewareIntegrationTests": ["DatabaseLive", "LeaderboardMiddleware", "SharedModels",
                                                  "ServerRouter", "SiteMiddleware", "HttpPipeline",
                                                  "HttpPipelineTestSupport", "Prelude", "SnapshotTesting"],
        "ApiClientLive": ["ApiClient", "ServerRouter", "SharedModels", "TcaHelpers", "Dependencies"],
        "SettingsFeature": ["ApiClient", "AudioPlayerClient", "Build", "ComposableStoreKit",
                            "ComposableUserNotifications", "FileClient", "LocalDatabaseClient", "LowPowerModeClient",
                            "RemoteNotificationsClient", "ServerConfigClient", "StatsFeature", "Styleguide",
                            "SwiftUIHelpers", "TcaHelpers",
                            "UIApplicationClient", "UserDefaultsClient", "ComposableArchitecture",
                            "XCTestDynamicOverlay"],
        "DailyChallengeMiddlewareTests": ["FirstPartyMocks", "DailyChallengeMiddleware", "SharedModels",
                                          "SiteMiddleware", "CustomDump", "HttpPipeline", "HttpPipelineTestSupport",
                                          "SnapshotTesting"],
        "Styleguide": ["SwiftUIHelpers", "Tagged"],
        "runner": ["RunnerTasks"],
        "GameOverFeatureTests": ["FirstPartyMocks", "GameOverFeature", "SharedSwiftUIEnvironment", "TestHelpers",
                                 "SnapshotTesting"],
        "AudioPlayerClient": ["ComposableArchitecture", "XCTestDynamicOverlay"],
        "OnboardingFeature": ["CubeCore", "GameCore", "DictionaryClient", "FeedbackGeneratorClient",
                              "LowPowerModeClient", "PuzzleGen", "SharedModels", "ComposableArchitecture"],
        "ComposableUserNotifications": ["ComposableArchitecture", "XCTestDynamicOverlay"],
        "DailyChallengeFeatureIntegrationTests": ["DailyChallengeFeature", "IntegrationTestHelpers", "SiteMiddleware",
                                                  "TestHelpers"],
        "RunnerTests": ["FirstPartyMocks", "RunnerTasks", "CustomDump"],
        "LeaderboardMiddleware": ["DatabaseClient", "DictionaryClient", "MiddlewareHelpers", "ServerRouter",
                                  "CasePaths",
                                  "HttpPipeline"],
        "DemoMiddlewareTests": ["DemoMiddleware", "SiteMiddleware", "HttpPipelineTestSupport", "SnapshotTesting"],
        "SwiftUIHelpers": ["Gen"],
        "HomeFeature": ["ActiveGamesFeature", "ApiClient", "AudioPlayerClient", "Build", "ChangelogFeature",
                        "ClientModels", "CombineHelpers", "ComposableStoreKit", "ComposableUserNotifications",
                        "DailyChallengeFeature",
                        "DateHelpers", "DeviceId", "FileClient", "LeaderboardFeature", "LocalDatabaseClient",
                        "LowPowerModeClient",
                        "MultiplayerFeature", "ServerConfigClient", "SettingsFeature", "SharedModels", "SoloFeature",
                        "Styleguide",
                        "SwiftUIHelpers", "TcaHelpers", "UIApplicationClient", "UpgradeInterstitialFeature",
                        "UserDefaultsClient",
                        "ComposableArchitecture", "Overture"],
        "XCTestDebugSupport": [],
        "CubePreview": ["AudioPlayerClient", "Bloom", "CubeCore", "FeedbackGeneratorClient", "HapticsCore",
                        "LowPowerModeClient", "SelectionSoundsCore", "SharedModels", "ComposableArchitecture"],
        "LeaderboardMiddlewareTests": ["LeaderboardMiddleware", "SiteMiddleware", "CustomDump",
                                       "HttpPipelineTestSupport", "SnapshotTesting"],
        "system-zlib": [],
        "RunnerTasks": ["ServerBootstrap"],
        "GameOverFeature": ["ApiClient", "AudioPlayerClient", "ClientModels", "CombineHelpers", "ComposableStoreKit",
                            "DailyChallengeHelpers", "FileClient", "FirstPartyMocks", "LocalDatabaseClient",
                            "NotificationHelpers",
                            "NotificationsAuthAlert", "SharedModels", "SharedSwiftUIEnvironment", "SwiftUIHelpers",
                            "TcaHelpers",
                            "UpgradeInterstitialFeature", "UserDefaultsClient", "ComposableArchitecture"],
        "DictionarySqliteClient": ["DictionaryClient", "PuzzleGen", "Sqlite"],
        "NotificationHelpers": ["ComposableUserNotifications", "RemoteNotificationsClient", "ComposableArchitecture"],
        "PushMiddleware": ["Build", "DatabaseClient", "SharedModels", "SnsClient", "Either", "HttpPipeline",
                           "Prelude"],
        "DailyChallengeReportsTests": ["DailyChallengeReports", "CustomDump"],
        "ActiveGamesFeature": ["AnyComparable", "ClientModels", "ComposableGameCenter", "DateHelpers", "SharedModels",
                               "Styleguide", "TcaHelpers", "ComposableArchitecture"],
        "VerifyReceiptMiddlewareTests": ["VerifyReceiptMiddleware", "SiteMiddleware", "CustomDump",
                                         "HttpPipelineTestSupport", "SnapshotTesting"],
        "DailyChallengeFeature": ["ApiClient", "ComposableUserNotifications", "CubePreview", "DailyChallengeHelpers",
                                  "DateHelpers", "LeaderboardFeature", "NotificationHelpers",
                                  "NotificationsAuthAlert",
                                  "RemoteNotificationsClient", "SharedModels", "Styleguide", "Overture",
                                  "ComposableArchitecture"],
        "GameFeature": ["ActiveGamesFeature", "ApiClient", "AudioPlayerClient", "BottomMenu", "ClientModels",
                        "ComposableGameCenter", "ComposableUserNotifications", "CubeCore", "DictionaryClient",
                        "GameCore",
                        "GameOverFeature", "FeedbackGeneratorClient", "FileClient", "LowPowerModeClient", "PuzzleGen",
                        "RemoteNotificationsClient", "SettingsFeature", "Styleguide", "TcaHelpers",
                        "UIApplicationClient",
                        "UpgradeInterstitialFeature", "ComposableArchitecture"],
        "GameOverFeatureIntegrationTests": ["GameOverFeature", "IntegrationTestHelpers", "SiteMiddleware"],
        "ChangelogFeature": ["ApiClient", "Build", "ServerConfigClient", "SharedModels", "Styleguide",
                             "SwiftUIHelpers",
                             "TcaHelpers", "UIApplicationClient", "UserDefaultsClient", "ComposableArchitecture",
                             "Overture"],
        "LocalDatabaseClient": ["SharedModels", "Sqlite", "XCTestDebugSupport", "ComposableArchitecture", "Overture"],
        "UserDefaultsClient": ["ComposableArchitecture", "XCTestDynamicOverlay"],
        "CubeCore": ["ClientModels", "SharedModels", "Styleguide", "ComposableArchitecture", "Gen"],
        "AnyComparable": [],
        "ServerConfigMiddleware": ["ServerConfig", "SharedModels", "HttpPipeline"],
        "ShareGameMiddleware": ["DatabaseClient", "EnvVars", "MiddlewareHelpers", "ServerRouter", "SharedModels",
                                "HttpPipeline"],
        "HomeFeatureTests": ["HomeFeature", "SnapshotTesting"],
        "StatsFeature": ["AudioPlayerClient", "LocalDatabaseClient", "Styleguide", "VocabFeature",
                         "ComposableArchitecture"],
        "CombineHelpers": [],
        "PuzzleGen": ["SharedModels", "Gen"],
        "ChangelogFeatureTests": ["ChangelogFeature"],
        "FeedbackGeneratorClient": ["XCTestDebugSupport", "ComposableArchitecture", "XCTestDynamicOverlay"],
        "DailyChallengeFeatureTests": ["DailyChallengeFeature", "TestHelpers", "SnapshotTesting"],
        "ComposableStoreKit": ["ComposableArchitecture", "XCTestDynamicOverlay"],
        "LeaderboardFeatureTests": ["LeaderboardFeature", "IntegrationTestHelpers", "SiteMiddleware"],
        "SnsClient": ["ServerTestHelpers", "Either", "Tagged", "XCTestDynamicOverlay"],
        "Build": ["Dependencies", "Tagged", "XCTestDynamicOverlay"],
        "NotificationsAuthAlert": ["CombineHelpers", "ComposableUserNotifications", "NotificationHelpers",
                                   "RemoteNotificationsClient", "Styleguide", "ComposableArchitecture"],
        "DictionarySqliteClientTests": ["DictionarySqliteClient"],
        "SnsClientTests": ["SnsClient", "SnapshotTesting"],
        "HapticsCore": ["FeedbackGeneratorClient", "TcaHelpers", "ComposableArchitecture"],
        "ServerRouter": ["SharedModels", "Tagged", "Parsing", "URLRouting", "XCTestDynamicOverlay"],
        "ApiClient": ["SharedModels", "XCTestDebugSupport", "CasePaths", "Dependencies", "XCTestDynamicOverlay"],
        "IntegrationTestHelpers": ["ApiClient", "ServerRouter", "TestHelpers", "HttpPipeline"],
        "ServerRouterTests": ["FirstPartyMocks", "ServerRouter", "TestHelpers", "CustomDump", "Overture", "Parsing",
                              "URLRouting"],
        "SiteMiddlewareTests": ["FirstPartyMocks", "SiteMiddleware", "TestHelpers", "HttpPipelineTestSupport",
                                "SnapshotTesting"],
        "Csqlite3": [],
        "Bloom": ["Styleguide", "ComposableArchitecture", "Gen"],
        "AppStoreSnapshotTests": ["AppFeature", "SharedSwiftUIEnvironment", "TestHelpers", "SnapshotTesting"],
        "ServerConfigClient": ["ServerConfig", "ComposableArchitecture", "XCTestDynamicOverlay"],
        "GameFeatureTests": ["AppFeature", "TestHelpers", "Gen"],
        "UIApplicationClient": ["ComposableArchitecture", "XCTestDynamicOverlay"],
        "AppFeature": ["ApiClient", "AudioPlayerClient", "Build", "ClientModels", "ComposableGameCenter",
                       "ComposableStoreKit", "CubeCore", "CubePreview", "DailyChallengeFeature", "DeviceId",
                       "DictionarySqliteClient",
                       "FeedbackGeneratorClient", "FileClient", "GameFeature", "GameOverFeature", "HomeFeature",
                       "LeaderboardFeature",
                       "LocalDatabaseClient", "LowPowerModeClient", "MultiplayerFeature", "NotificationHelpers",
                       "OnboardingFeature",
                       "RemoteNotificationsClient", "ServerRouter", "SettingsFeature", "SharedModels", "SoloFeature",
                       "StatsFeature",
                       "TcaHelpers", "UIApplicationClient", "VocabFeature", "ComposableArchitecture", "Gen", "Tagged",
                       "XCTestDynamicOverlay"],
        "FirstPartyMocks": [],
        "VocabFeature": ["AudioPlayerClient", "CubePreview", "FeedbackGeneratorClient", "LocalDatabaseClient",
                         "LowPowerModeClient", "SharedModels", "ComposableArchitecture"],
        "ClientModelsTests": ["ClientModels", "FirstPartyMocks", "TestHelpers", "CustomDump", "Overture",
                              "SnapshotTesting"],
        "SharedModels": ["Build", "FirstPartyMocks", "CustomDump", "Tagged"],
      ]
    )
  }
}

private let SomePackageSPMJSON =
  """
  {
    "dependencies" : [
      {
        "identity" : "kingfisher",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "6.0.0",
              "upper_bound" : "7.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/onevcat/Kingfisher.git"
      },
      {
        "identity" : "moya",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "14.0.0",
              "upper_bound" : "15.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/Moya/Moya.git"
      },
      {
        "identity" : "alamofire",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "5.4.3",
              "upper_bound" : "6.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/Alamofire/Alamofire.git"
      },
      {
        "identity" : "swift-case-paths",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.14.1",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-case-paths"
      }
    ],
    "manifest_display_name" : "SomePackage",
    "name" : "SomePackage",
    "path" : "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage_TwoTarget",
    "platforms" : [
      {
        "name" : "macos",
        "version" : "10.15"
      }
    ],
    "products" : [
      {
        "name" : "SomePackage",
        "targets" : [
          "SomePackage"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "Core",
        "targets" : [
          "Core"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      }
    ],
    "targets" : [
      {
        "c99name" : "SomePackageTests",
        "module_type" : "SwiftTarget",
        "name" : "SomePackageTests",
        "path" : "Tests/SomePackageTests",
        "sources" : [
          "SomePackageTests.swift",
          "XCTestManifests.swift"
        ],
        "target_dependencies" : [
          "SomePackage"
        ],
        "type" : "test"
      },
      {
        "c99name" : "SomePackage",
        "module_type" : "SwiftTarget",
        "name" : "SomePackage",
        "path" : "Sources/SomePackage",
        "product_dependencies" : [
          "Kingfisher",
          "Moya",
          "Alamofire"
        ],
        "product_memberships" : [
          "SomePackage"
        ],
        "sources" : [
          "AppleImports.swift",
          "CoreImports.swift",
          "DependencyImports.swift",
          "SomePackage.swift"
        ],
        "target_dependencies" : [
          "Core"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Core",
        "module_type" : "SwiftTarget",
        "name" : "Core",
        "path" : "Sources/Core",
        "product_dependencies" : [
          "CasePaths"
        ],
        "product_memberships" : [
          "SomePackage",
          "Core"
        ],
        "sources" : [
          "Core.swift"
        ],
        "type" : "library"
      }
    ],
    "tools_version" : "5.3"
  }

  """.data(using: .utf8)!

private let ISOWORDSSPMJSON =
  """
  {
    "dependencies" : [
      {
        "identity" : "swift-crypto",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "1.1.6",
              "upper_bound" : "2.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/apple/swift-crypto"
      },
      {
        "identity" : "swift-case-paths",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.8.1",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-case-paths"
      },
      {
        "identity" : "swift-composable-architecture",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.49.1",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-composable-architecture"
      },
      {
        "identity" : "swift-custom-dump",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.1.0",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-custom-dump"
      },
      {
        "identity" : "swift-dependencies",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.1.0",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-dependencies"
      },
      {
        "identity" : "swift-gen",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.3.0",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-gen"
      },
      {
        "identity" : "swift-parsing",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.9.2",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-parsing"
      },
      {
        "identity" : "swift-tagged",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.6.0",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-tagged"
      },
      {
        "identity" : "swift-url-routing",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.2.0",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-url-routing"
      },
      {
        "identity" : "xctest-dynamic-overlay",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.2.0",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/xctest-dynamic-overlay"
      },
      {
        "identity" : "swift-overture",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "0.5.0",
              "upper_bound" : "1.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-overture"
      },
      {
        "identity" : "swift-snapshot-testing",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "1.10.0",
              "upper_bound" : "2.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-snapshot-testing"
      },
      {
        "identity" : "swiftawssignaturev4",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "1.1.0",
              "upper_bound" : "2.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/crspybits/SwiftAWSSignatureV4"
      },
      {
        "identity" : "swift-backtrace",
        "requirement" : {
          "exact" : [
            "1.2.0"
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/swift-server/swift-backtrace"
      },
      {
        "identity" : "postgres-kit",
        "requirement" : {
          "exact" : [
            "2.2.0"
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/vapor/postgres-kit"
      },
      {
        "identity" : "swift-prelude",
        "requirement" : {
          "revision" : [
            "7ff9911"
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-prelude"
      },
      {
        "identity" : "swift-web",
        "requirement" : {
          "revision" : [
            "2ad82ec"
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/pointfreeco/swift-web"
      }
    ],
    "manifest_display_name" : "isowords",
    "name" : "isowords",
    "path" : "/Users/yuyu/code/isowords",
    "platforms" : [
      {
        "name" : "ios",
        "version" : "15.0"
      },
      {
        "name" : "macos",
        "version" : "12.0"
      },
      {
        "name" : "tvos",
        "version" : "15.0"
      },
      {
        "name" : "watchos",
        "version" : "8.0"
      }
    ],
    "products" : [
      {
        "name" : "Build",
        "targets" : [
          "Build"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DictionaryClient",
        "targets" : [
          "DictionaryClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DictionarySqliteClient",
        "targets" : [
          "DictionarySqliteClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "FirstPartyMocks",
        "targets" : [
          "FirstPartyMocks"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "PuzzleGen",
        "targets" : [
          "PuzzleGen"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ServerConfig",
        "targets" : [
          "ServerConfig"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ServerRouter",
        "targets" : [
          "ServerRouter"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SharedModels",
        "targets" : [
          "SharedModels"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "Sqlite",
        "targets" : [
          "Sqlite"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "TestHelpers",
        "targets" : [
          "TestHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "XCTestDebugSupport",
        "targets" : [
          "XCTestDebugSupport"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ActiveGamesFeature",
        "targets" : [
          "ActiveGamesFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "AnyComparable",
        "targets" : [
          "AnyComparable"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ApiClient",
        "targets" : [
          "ApiClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ApiClientLive",
        "targets" : [
          "ApiClientLive"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "AppAudioLibrary",
        "targets" : [
          "AppAudioLibrary"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "AppClipAudioLibrary",
        "targets" : [
          "AppClipAudioLibrary"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "AppFeature",
        "targets" : [
          "AppFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "AudioPlayerClient",
        "targets" : [
          "AudioPlayerClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "Bloom",
        "targets" : [
          "Bloom"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "BottomMenu",
        "targets" : [
          "BottomMenu"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ChangelogFeature",
        "targets" : [
          "ChangelogFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ClientModels",
        "targets" : [
          "ClientModels"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "CombineHelpers",
        "targets" : [
          "CombineHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ComposableGameCenter",
        "targets" : [
          "ComposableGameCenter"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ComposableStoreKit",
        "targets" : [
          "ComposableStoreKit"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ComposableUserNotifications",
        "targets" : [
          "ComposableUserNotifications"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "CubeCore",
        "targets" : [
          "CubeCore"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "CubePreview",
        "targets" : [
          "CubePreview"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DailyChallengeFeature",
        "targets" : [
          "DailyChallengeFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DailyChallengeHelpers",
        "targets" : [
          "DailyChallengeHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DateHelpers",
        "targets" : [
          "DateHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DemoFeature",
        "targets" : [
          "DemoFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DeviceId",
        "targets" : [
          "DeviceId"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DictionaryFileClient",
        "targets" : [
          "DictionaryFileClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "FeedbackGeneratorClient",
        "targets" : [
          "FeedbackGeneratorClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "FileClient",
        "targets" : [
          "FileClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "GameCore",
        "targets" : [
          "GameCore"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "GameFeature",
        "targets" : [
          "GameFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "GameOverFeature",
        "targets" : [
          "GameOverFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "HapticsCore",
        "targets" : [
          "HapticsCore"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "HomeFeature",
        "targets" : [
          "HomeFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "IntegrationTestHelpers",
        "targets" : [
          "IntegrationTestHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "LeaderboardFeature",
        "targets" : [
          "LeaderboardFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "LocalDatabaseClient",
        "targets" : [
          "LocalDatabaseClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "LowPowerModeClient",
        "targets" : [
          "LowPowerModeClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "MultiplayerFeature",
        "targets" : [
          "MultiplayerFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "NotificationHelpers",
        "targets" : [
          "NotificationHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "NotificationsAuthAlert",
        "targets" : [
          "NotificationsAuthAlert"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "OnboardingFeature",
        "targets" : [
          "OnboardingFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "RemoteNotificationsClient",
        "targets" : [
          "RemoteNotificationsClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SelectionSoundsCore",
        "targets" : [
          "SelectionSoundsCore"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ServerConfigClient",
        "targets" : [
          "ServerConfigClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SettingsFeature",
        "targets" : [
          "SettingsFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SharedSwiftUIEnvironment",
        "targets" : [
          "SharedSwiftUIEnvironment"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SoloFeature",
        "targets" : [
          "SoloFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "StatsFeature",
        "targets" : [
          "StatsFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "Styleguide",
        "targets" : [
          "Styleguide"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SwiftUIHelpers",
        "targets" : [
          "SwiftUIHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "TcaHelpers",
        "targets" : [
          "TcaHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "TrailerFeature",
        "targets" : [
          "TrailerFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "UIApplicationClient",
        "targets" : [
          "UIApplicationClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "UpgradeInterstitialFeature",
        "targets" : [
          "UpgradeInterstitialFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "UserDefaultsClient",
        "targets" : [
          "UserDefaultsClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "VocabFeature",
        "targets" : [
          "VocabFeature"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "daily-challenge-reports",
        "targets" : [
          "daily-challenge-reports"
        ],
        "type" : {
          "executable" : null
        }
      },
      {
        "name" : "runner",
        "targets" : [
          "runner"
        ],
        "type" : {
          "executable" : null
        }
      },
      {
        "name" : "server",
        "targets" : [
          "server"
        ],
        "type" : {
          "executable" : null
        }
      },
      {
        "name" : "AppSiteAssociationMiddleware",
        "targets" : [
          "AppSiteAssociationMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DailyChallengeMiddleware",
        "targets" : [
          "DailyChallengeMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DailyChallengeReports",
        "targets" : [
          "DailyChallengeReports"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DatabaseClient",
        "targets" : [
          "DatabaseClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DatabaseLive",
        "targets" : [
          "DatabaseLive"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "DemoMiddleware",
        "targets" : [
          "DemoMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "EnvVars",
        "targets" : [
          "EnvVars"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "LeaderboardMiddleware",
        "targets" : [
          "LeaderboardMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "MailgunClient",
        "targets" : [
          "MailgunClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "MiddlewareHelpers",
        "targets" : [
          "MiddlewareHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "PushMiddleware",
        "targets" : [
          "PushMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "RunnerTasks",
        "targets" : [
          "RunnerTasks"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ServerBootstrap",
        "targets" : [
          "ServerBootstrap"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ServerConfigMiddleware",
        "targets" : [
          "ServerConfigMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ServerTestHelpers",
        "targets" : [
          "ServerTestHelpers"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ShareGameMiddleware",
        "targets" : [
          "ShareGameMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SiteMiddleware",
        "targets" : [
          "SiteMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SnsClient",
        "targets" : [
          "SnsClient"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "SnsClientLive",
        "targets" : [
          "SnsClientLive"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "VerifyReceiptMiddleware",
        "targets" : [
          "VerifyReceiptMiddleware"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      }
    ],
    "targets" : [
      {
        "c99name" : "system_zlib",
        "module_type" : "ClangTarget",
        "name" : "system-zlib",
        "path" : "Sources/system-zlib",
        "product_memberships" : [
          "DictionaryFileClient"
        ],
        "sources" : [
          "anchor.c"
        ],
        "type" : "library"
      },
      {
        "c99name" : "server",
        "module_type" : "SwiftTarget",
        "name" : "server",
        "path" : "Sources/server",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "server"
        ],
        "sources" : [
          "main.swift"
        ],
        "target_dependencies" : [
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "type" : "executable"
      },
      {
        "c99name" : "runner",
        "module_type" : "SwiftTarget",
        "name" : "runner",
        "path" : "Sources/runner",
        "product_memberships" : [
          "runner"
        ],
        "sources" : [
          "main.swift"
        ],
        "target_dependencies" : [
          "RunnerTasks"
        ],
        "type" : "executable"
      },
      {
        "c99name" : "daily_challenge_reports",
        "module_type" : "SwiftTarget",
        "name" : "daily-challenge-reports",
        "path" : "Sources/daily-challenge-reports",
        "product_memberships" : [
          "daily-challenge-reports"
        ],
        "sources" : [
          "main.swift"
        ],
        "target_dependencies" : [
          "DailyChallengeReports"
        ],
        "type" : "executable"
      },
      {
        "c99name" : "XCTestDebugSupport",
        "module_type" : "SwiftTarget",
        "name" : "XCTestDebugSupport",
        "path" : "Sources/XCTestDebugSupport",
        "product_memberships" : [
          "XCTestDebugSupport",
          "ApiClient",
          "ApiClientLive",
          "AppFeature",
          "ChangelogFeature",
          "CubePreview",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "FeedbackGeneratorClient",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HapticsCore",
          "HomeFeature",
          "IntegrationTestHelpers",
          "LeaderboardFeature",
          "LocalDatabaseClient",
          "OnboardingFeature",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "Expectation.swift",
          "XCTCurrentTestCase.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "VocabFeature",
        "module_type" : "SwiftTarget",
        "name" : "VocabFeature",
        "path" : "Sources/VocabFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "GameFeature",
          "HomeFeature",
          "SettingsFeature",
          "StatsFeature",
          "VocabFeature"
        ],
        "sources" : [
          "Vocab.swift"
        ],
        "target_dependencies" : [
          "AudioPlayerClient",
          "CubePreview",
          "FeedbackGeneratorClient",
          "LocalDatabaseClient",
          "LowPowerModeClient",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "VerifyReceiptMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "VerifyReceiptMiddlewareTests",
        "path" : "Tests/VerifyReceiptMiddlewareTests",
        "product_dependencies" : [
          "CustomDump",
          "HttpPipelineTestSupport",
          "SnapshotTesting"
        ],
        "sources" : [
          "AppleVerifyReceiptResponse.swift",
          "VerifyReceiptMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "VerifyReceiptMiddleware",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "VerifyReceiptMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "VerifyReceiptMiddleware",
        "path" : "Sources/VerifyReceiptMiddleware",
        "product_dependencies" : [
          "HttpPipeline",
          "Overture"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "ItunesClient.swift",
          "VerifyReceiptMiddleware.swift"
        ],
        "target_dependencies" : [
          "DatabaseClient",
          "MiddlewareHelpers",
          "ServerRouter",
          "ServerTestHelpers",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "UserDefaultsClient",
        "module_type" : "SwiftTarget",
        "name" : "UserDefaultsClient",
        "path" : "Sources/UserDefaultsClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "ChangelogFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "TrailerFeature",
          "UserDefaultsClient"
        ],
        "sources" : [
          "Interface.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "UpgradeInterstitialFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "UpgradeInterstitialFeatureTests",
        "path" : "Tests/UpgradeInterstitialFeatureTests",
        "product_dependencies" : [
          "Overture",
          "SnapshotTesting"
        ],
        "sources" : [
          "ShowUpgradeInterstitialEffectTests.swift",
          "UpgradeInterstitialFeatureTests.swift",
          "UpgradeInterstitialViewTests.swift"
        ],
        "target_dependencies" : [
          "FirstPartyMocks",
          "UpgradeInterstitialFeature"
        ],
        "type" : "test"
      },
      {
        "c99name" : "UpgradeInterstitialFeature",
        "module_type" : "SwiftTarget",
        "name" : "UpgradeInterstitialFeature",
        "path" : "Sources/UpgradeInterstitialFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "OnboardingFeature",
          "TrailerFeature",
          "UpgradeInterstitialFeature"
        ],
        "sources" : [
          "UpgradeInterstitialView.swift"
        ],
        "target_dependencies" : [
          "CombineHelpers",
          "ComposableStoreKit",
          "ServerConfigClient",
          "Styleguide",
          "SwiftUIHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "UIApplicationClient",
        "module_type" : "SwiftTarget",
        "name" : "UIApplicationClient",
        "path" : "Sources/UIApplicationClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "ChangelogFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "TrailerFeature",
          "UIApplicationClient"
        ],
        "sources" : [
          "Client.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "TrailerFeature",
        "module_type" : "SwiftTarget",
        "name" : "TrailerFeature",
        "path" : "Sources/TrailerFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "TrailerFeature"
        ],
        "sources" : [
          "MockTrailerPuzzle.swift",
          "Trailer.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "Bloom",
          "CubeCore",
          "GameCore",
          "DictionaryClient",
          "FeedbackGeneratorClient",
          "LowPowerModeClient",
          "OnboardingFeature",
          "SharedModels",
          "TcaHelpers",
          "UserDefaultsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "TestHelpers",
        "module_type" : "SwiftTarget",
        "name" : "TestHelpers",
        "path" : "Sources/TestHelpers",
        "product_memberships" : [
          "TestHelpers",
          "IntegrationTestHelpers"
        ],
        "sources" : [
          "AsyncStreamProducer.swift",
          "Unwrap.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "TcaHelpers",
        "module_type" : "SwiftTarget",
        "name" : "TcaHelpers",
        "path" : "Sources/TcaHelpers",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "ActiveGamesFeature",
          "ApiClientLive",
          "AppFeature",
          "ChangelogFeature",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HapticsCore",
          "HomeFeature",
          "LeaderboardFeature",
          "MultiplayerFeature",
          "OnboardingFeature",
          "SelectionSoundsCore",
          "SettingsFeature",
          "StatsFeature",
          "TcaHelpers",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "CasePathMatching.swift",
          "EffectPrefix.swift",
          "FilterReducer.swift",
          "Isolated.swift",
          "OnChange.swift",
          "OptionalPaths.swift",
          "RuntimeWarnings.swift",
          "Send.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SwiftUIHelpers",
        "module_type" : "SwiftTarget",
        "name" : "SwiftUIHelpers",
        "path" : "Sources/SwiftUIHelpers",
        "product_dependencies" : [
          "Gen"
        ],
        "product_memberships" : [
          "ActiveGamesFeature",
          "AppFeature",
          "Bloom",
          "BottomMenu",
          "ChangelogFeature",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "MultiplayerFeature",
          "NotificationsAuthAlert",
          "OnboardingFeature",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "Styleguide",
          "SwiftUIHelpers",
          "TrailerFeature",
          "UpgradeInterstitialFeature",
          "VocabFeature"
        ],
        "sources" : [
          "ActivityView.swift",
          "Binding.swift",
          "Color.swift",
          "ContinuousCornerRadius.swift",
          "Date.swift",
          "Preview.swift",
          "SwiftUIShims.swift",
          "UIColor.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Styleguide",
        "module_type" : "SwiftTarget",
        "name" : "Styleguide",
        "path" : "Sources/Styleguide",
        "product_dependencies" : [
          "Tagged"
        ],
        "product_memberships" : [
          "ActiveGamesFeature",
          "AppFeature",
          "Bloom",
          "BottomMenu",
          "ChangelogFeature",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "MultiplayerFeature",
          "NotificationsAuthAlert",
          "OnboardingFeature",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "Styleguide",
          "TrailerFeature",
          "UpgradeInterstitialFeature",
          "VocabFeature"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/Styleguide/Fonts/empty.otf",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "AdaptiveSize.swift",
          "Buttons.swift",
          "Colors.swift",
          "CornerRadius.swift",
          "DeviceState.swift",
          "Fonts.swift",
          "GameButton.swift",
          "GradientBlend.swift",
          "Grid.swift",
          "Hosting.swift",
          "NavigationBar.swift",
          "Padding.swift",
          "RegisterFonts.swift",
          "SettingsForm.swift"
        ],
        "target_dependencies" : [
          "SwiftUIHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "StatsFeature",
        "module_type" : "SwiftTarget",
        "name" : "StatsFeature",
        "path" : "Sources/StatsFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "GameFeature",
          "HomeFeature",
          "SettingsFeature",
          "StatsFeature"
        ],
        "sources" : [
          "StatsFeature.swift"
        ],
        "target_dependencies" : [
          "AudioPlayerClient",
          "LocalDatabaseClient",
          "Styleguide",
          "VocabFeature"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Sqlite",
        "module_type" : "SwiftTarget",
        "name" : "Sqlite",
        "path" : "Sources/Sqlite",
        "product_memberships" : [
          "DictionarySqliteClient",
          "Sqlite",
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LocalDatabaseClient",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap"
        ],
        "sources" : [
          "Sqlite.swift"
        ],
        "target_dependencies" : [
          "Csqlite3"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SoloFeature",
        "module_type" : "SwiftTarget",
        "name" : "SoloFeature",
        "path" : "Sources/SoloFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "HomeFeature",
          "SoloFeature"
        ],
        "sources" : [
          "SoloView.swift"
        ],
        "target_dependencies" : [
          "ClientModels",
          "FileClient",
          "SharedModels",
          "Styleguide"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SnsClientTests",
        "module_type" : "SwiftTarget",
        "name" : "SnsClientTests",
        "path" : "Tests/SnsClientTests",
        "product_dependencies" : [
          "SnapshotTesting"
        ],
        "sources" : [
          "SnsClientTests.swift"
        ],
        "target_dependencies" : [
          "SnsClient"
        ],
        "type" : "test"
      },
      {
        "c99name" : "SnsClientLive",
        "module_type" : "SwiftTarget",
        "name" : "SnsClientLive",
        "path" : "Sources/SnsClientLive",
        "product_dependencies" : [
          "SwiftAWSSignatureV4"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "SnsClientLive"
        ],
        "sources" : [
          "Live.swift"
        ],
        "target_dependencies" : [
          "SnsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SnsClient",
        "module_type" : "SwiftTarget",
        "name" : "SnsClient",
        "path" : "Sources/SnsClient",
        "product_dependencies" : [
          "Either",
          "Tagged",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DatabaseClient",
          "DatabaseLive",
          "DemoMiddleware",
          "EnvVars",
          "LeaderboardMiddleware",
          "MiddlewareHelpers",
          "PushMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "SnsClient",
          "SnsClientLive",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "AnyCodable.swift",
          "ApsPayload.swift",
          "Interface.swift",
          "Mocks.swift",
          "Models.swift"
        ],
        "target_dependencies" : [
          "ServerTestHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SiteMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "SiteMiddlewareTests",
        "path" : "Tests/SiteMiddlewareTests",
        "product_dependencies" : [
          "HttpPipelineTestSupport",
          "SnapshotTesting"
        ],
        "sources" : [
          "AuthenticationMiddlewareTests.swift",
          "CurrentPlayerMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "FirstPartyMocks",
          "SiteMiddleware",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "SiteMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "SiteMiddleware",
        "path" : "Sources/SiteMiddleware",
        "product_dependencies" : [
          "HttpPipeline",
          "Overture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/app-icon-dark.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/favicon-32x32.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/android-icon-192x192.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/icon-twitter-light-mode.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-152x152.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/ms-icon-150x150.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/screenshots/screenshot-6.jpeg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/android-icon-144x144.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/screenshots/screenshot-4.jpeg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/index.html",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/isowords-press-kit-icon.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/android-icon-72x72.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/manifest.json",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/screenshots/screenshot-1.jpeg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/screenshots/screenshot-3.jpeg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/app-store-badge.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/feature-3.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/feature-1-light-mode.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/android-icon-48x48.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/css/base.css",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/android-icon-36x36.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/screenshots/screenshot-5.jpeg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/isowords-press-kit-screenshot-1.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/screenshots/screenshot-2.jpeg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-60x60.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/feature-1.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-76x76.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-72x72.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/icon-twitter.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/cube.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-precomposed.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/ms-icon-310x310.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/favicon.ico",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/feature-2-light-mode.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/favicon-16x16.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/android-icon-96x96.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/point-free-logo.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-120x120.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/icon-github-light-mode.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/twitter-card.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/feature-3-light-mode.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/ms-icon-70x70.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-180x180.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/favicon-96x96.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-57x57.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/feature-2.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-114x114.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/press-kit.html",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/icon-github.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/apple-icon-144x144.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/point-free-logo-dark.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/screenshots/screenshot-7.jpeg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/app-icon-dark.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/phone-outline.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/phone-outline-dark.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/app-icon.svg",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/browserconfig.xml",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/app-icon.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/images/ms-icon-144x144.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SiteMiddleware/Resources/css/style.css",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "ApiMiddleware.swift",
          "AuthenticateMiddleware.swift",
          "CurrentPlayerMiddleware.swift",
          "ErrorReporting.swift",
          "Homepage.swift",
          "PressKit.swift",
          "PrivacyPolicy.swift",
          "ServerEnvironment.swift",
          "SiteMiddleware.swift"
        ],
        "target_dependencies" : [
          "AppSiteAssociationMiddleware",
          "DailyChallengeMiddleware",
          "DatabaseClient",
          "DemoMiddleware",
          "EnvVars",
          "LeaderboardMiddleware",
          "MailgunClient",
          "MiddlewareHelpers",
          "PushMiddleware",
          "ServerConfig",
          "ServerConfigMiddleware",
          "SharedModels",
          "ShareGameMiddleware",
          "SnsClient",
          "VerifyReceiptMiddleware"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SharedSwiftUIEnvironment",
        "module_type" : "SwiftTarget",
        "name" : "SharedSwiftUIEnvironment",
        "path" : "Sources/SharedSwiftUIEnvironment",
        "product_memberships" : [
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "OnboardingFeature",
          "SharedSwiftUIEnvironment",
          "TrailerFeature"
        ],
        "sources" : [
          "EnvironmentValues.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SharedModelsTests",
        "module_type" : "SwiftTarget",
        "name" : "SharedModelsTests",
        "path" : "Tests/SharedModelsTests",
        "product_dependencies" : [
          "Overture",
          "SnapshotTesting"
        ],
        "sources" : [
          "AppleVerifyReceiptResponseTests.swift",
          "BackwardsCompatibilityTestHelpers.swift",
          "CodabilityTests.swift",
          "CompletedGameTests.swift",
          "CubeTests.swift",
          "MovesTests.swift",
          "SubmitGameResponseTests.swift",
          "ThreeTests.swift",
          "VerificationTests.swift"
        ],
        "target_dependencies" : [
          "FirstPartyMocks",
          "SharedModels",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "SharedModels",
        "module_type" : "SwiftTarget",
        "name" : "SharedModels",
        "path" : "Sources/SharedModels",
        "product_dependencies" : [
          "CustomDump",
          "Tagged"
        ],
        "product_memberships" : [
          "DictionaryClient",
          "DictionarySqliteClient",
          "PuzzleGen",
          "ServerRouter",
          "SharedModels",
          "ActiveGamesFeature",
          "ApiClient",
          "ApiClientLive",
          "AppFeature",
          "ChangelogFeature",
          "ClientModels",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "DictionaryFileClient",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "IntegrationTestHelpers",
          "LeaderboardFeature",
          "LocalDatabaseClient",
          "MultiplayerFeature",
          "OnboardingFeature",
          "SelectionSoundsCore",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DatabaseClient",
          "DatabaseLive",
          "DemoMiddleware",
          "LeaderboardMiddleware",
          "PushMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "ServerConfigMiddleware",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "API/ApiError.swift",
          "API/AppleVerifyReceiptResponse.swift",
          "API/CurrentPlayerEnvelope.swift",
          "API/DailyChallengeHistoryResult.swift",
          "API/DailyChallengeResult.swift",
          "API/FetchDailyChallengeResultsResponse.swift",
          "API/FetchLeaderboardResponse.swift",
          "API/FetchTodaysDailyChallengeResponse.swift",
          "API/FetchVocabLeaderboardResponse.swift",
          "API/FetchVocabWordResponse.swift",
          "API/FetchWeekInReviewResponse.swift",
          "API/ServerRoute.swift",
          "API/ShareGameResponse.swift",
          "API/StartDailyChallengeResponse.swift",
          "API/SubmitGameResponse.swift",
          "API/SubmitSharedGameResponse.swift",
          "API/VerifyReceiptEnvelope.swift",
          "Archivable.swift",
          "CompletedGame.swift",
          "Cube.swift",
          "CubeFace.swift",
          "DB/AppleReceipt.swift",
          "DB/DailyChallenge.swift",
          "DB/DailyChallengePlay.swift",
          "DB/LeaderboardScore.swift",
          "DB/Player.swift",
          "DB/PushToken.swift",
          "DB/SharedGame.swift",
          "DB/Word.swift",
          "GameMode.swift",
          "IndexedCubeFace.swift",
          "Internal/TransformKeys.swift",
          "Language.swift",
          "LatticePoint.swift",
          "Mocks.swift",
          "Move.swift",
          "Moves.swift",
          "PlayedWord.swift",
          "PushAuthorizationStatus.swift",
          "PushNotificationContent.swift",
          "Puzzle.swift",
          "Scoring.swift",
          "SharedModels.swift",
          "Three.swift",
          "TimeScope.swift",
          "Verification.swift"
        ],
        "target_dependencies" : [
          "Build",
          "FirstPartyMocks"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ShareGameMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "ShareGameMiddlewareTests",
        "path" : "Tests/ShareGameMiddlewareTests",
        "product_dependencies" : [
          "HttpPipelineTestSupport",
          "SnapshotTesting"
        ],
        "sources" : [
          "ShareGameMiddleware.swift"
        ],
        "target_dependencies" : [
          "ShareGameMiddleware",
          "SiteMiddleware",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "ShareGameMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "ShareGameMiddleware",
        "path" : "Sources/ShareGameMiddleware",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "ShareGameMiddleware",
          "SiteMiddleware"
        ],
        "sources" : [
          "ShareGameMiddleware.swift"
        ],
        "target_dependencies" : [
          "DatabaseClient",
          "EnvVars",
          "MiddlewareHelpers",
          "ServerRouter",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SettingsFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "SettingsFeatureTests",
        "path" : "Tests/SettingsFeatureTests",
        "product_dependencies" : [
          "SnapshotTesting"
        ],
        "sources" : [
          "SettingsFeatureTests.swift",
          "SettingsPurchaseTests.swift",
          "SettingsViewTests.swift"
        ],
        "target_dependencies" : [
          "TestHelpers",
          "SettingsFeature"
        ],
        "type" : "test"
      },
      {
        "c99name" : "SettingsFeature",
        "module_type" : "SwiftTarget",
        "name" : "SettingsFeature",
        "path" : "Sources/SettingsFeature",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "GameFeature",
          "HomeFeature",
          "SettingsFeature"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-2.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-7.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-5.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-3.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-iso.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-6.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-1.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-4.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/SettingsFeature/Resources/icon-8.png",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "AccessibilitySettingsView.swift",
          "AppearanceSettingsView.swift",
          "DeveloperSettingsView.swift",
          "FileClientEffects.swift",
          "Mocks.swift",
          "NotificationsSettingsView.swift",
          "PurchasesSettingsView.swift",
          "Settings.swift",
          "SettingsView.swift",
          "SoundsSettingsView.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "AudioPlayerClient",
          "Build",
          "ComposableStoreKit",
          "ComposableUserNotifications",
          "FileClient",
          "LocalDatabaseClient",
          "LowPowerModeClient",
          "RemoteNotificationsClient",
          "ServerConfigClient",
          "StatsFeature",
          "Styleguide",
          "SwiftUIHelpers",
          "TcaHelpers",
          "UIApplicationClient",
          "UserDefaultsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ServerTestHelpers",
        "module_type" : "SwiftTarget",
        "name" : "ServerTestHelpers",
        "path" : "Sources/ServerTestHelpers",
        "product_dependencies" : [
          "Either",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DatabaseClient",
          "DatabaseLive",
          "DemoMiddleware",
          "EnvVars",
          "LeaderboardMiddleware",
          "MailgunClient",
          "MiddlewareHelpers",
          "PushMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "ServerTestHelpers",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "SnsClient",
          "SnsClientLive",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "UnimplementedEitherIO.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ServerRouterTests",
        "module_type" : "SwiftTarget",
        "name" : "ServerRouterTests",
        "path" : "Tests/ServerRouterTests",
        "product_dependencies" : [
          "CustomDump",
          "Overture",
          "Parsing",
          "URLRouting"
        ],
        "sources" : [
          "ConfigTests.swift",
          "ServerRouterTests.swift",
          "TestRouter.swift"
        ],
        "target_dependencies" : [
          "FirstPartyMocks",
          "ServerRouter",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "ServerRouter",
        "module_type" : "SwiftTarget",
        "name" : "ServerRouter",
        "path" : "Sources/ServerRouter",
        "product_dependencies" : [
          "Tagged",
          "Parsing",
          "URLRouting",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "ServerRouter",
          "ApiClientLive",
          "AppFeature",
          "IntegrationTestHelpers",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "LeaderboardMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "Base64.swift",
          "Router.swift",
          "SignatureVerification.swift"
        ],
        "target_dependencies" : [
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ServerConfigMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "ServerConfigMiddlewareTests",
        "path" : "Tests/ServerConfigMiddlewareTests",
        "product_dependencies" : [
          "Either",
          "HttpPipeline",
          "HttpPipelineTestSupport",
          "Prelude"
        ],
        "sources" : [
          "ServerConfigMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "ServerConfigMiddleware",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "ServerConfigMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "ServerConfigMiddleware",
        "path" : "Sources/ServerConfigMiddleware",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "ServerConfigMiddleware",
          "SiteMiddleware"
        ],
        "sources" : [
          "ServerConfigMiddleware.swift"
        ],
        "target_dependencies" : [
          "ServerConfig",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ServerConfigClient",
        "module_type" : "SwiftTarget",
        "name" : "ServerConfigClient",
        "path" : "Sources/ServerConfigClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "ChangelogFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "OnboardingFeature",
          "ServerConfigClient",
          "SettingsFeature",
          "TrailerFeature",
          "UpgradeInterstitialFeature"
        ],
        "sources" : [
          "Client.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "target_dependencies" : [
          "ServerConfig"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ServerConfig",
        "module_type" : "SwiftTarget",
        "name" : "ServerConfig",
        "path" : "Sources/ServerConfig",
        "product_memberships" : [
          "ServerConfig",
          "AppFeature",
          "ChangelogFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "OnboardingFeature",
          "ServerConfigClient",
          "SettingsFeature",
          "TrailerFeature",
          "UpgradeInterstitialFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "ServerConfigMiddleware",
          "SiteMiddleware"
        ],
        "sources" : [
          "Changelog.swift",
          "ServerConfig.swift"
        ],
        "target_dependencies" : [
          "Build"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ServerBootstrap",
        "module_type" : "SwiftTarget",
        "name" : "ServerBootstrap",
        "path" : "Sources/ServerBootstrap",
        "product_dependencies" : [
          "Backtrace",
          "Crypto"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap"
        ],
        "sources" : [
          "Bootstrap.swift"
        ],
        "target_dependencies" : [
          "DatabaseLive",
          "DictionarySqliteClient",
          "EnvVars",
          "ServerConfig",
          "SiteMiddleware",
          "SnsClientLive"
        ],
        "type" : "library"
      },
      {
        "c99name" : "SelectionSoundsCore",
        "module_type" : "SwiftTarget",
        "name" : "SelectionSoundsCore",
        "path" : "Sources/SelectionSoundsCore",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "OnboardingFeature",
          "SelectionSoundsCore",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "SelectionSoundsCore.swift"
        ],
        "target_dependencies" : [
          "AudioPlayerClient",
          "SharedModels",
          "TcaHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "RunnerTests",
        "module_type" : "SwiftTarget",
        "name" : "RunnerTests",
        "path" : "Tests/RunnerTests",
        "product_dependencies" : [
          "CustomDump"
        ],
        "sources" : [
          "RunnerTests.swift"
        ],
        "target_dependencies" : [
          "FirstPartyMocks",
          "RunnerTasks"
        ],
        "type" : "test"
      },
      {
        "c99name" : "RunnerTasks",
        "module_type" : "SwiftTarget",
        "name" : "RunnerTasks",
        "path" : "Sources/RunnerTasks",
        "product_memberships" : [
          "runner",
          "RunnerTasks"
        ],
        "sources" : [
          "DailyChallengeEndsSoonNotification.swift"
        ],
        "target_dependencies" : [
          "ServerBootstrap"
        ],
        "type" : "library"
      },
      {
        "c99name" : "RemoteNotificationsClient",
        "module_type" : "SwiftTarget",
        "name" : "RemoteNotificationsClient",
        "path" : "Sources/RemoteNotificationsClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "NotificationHelpers",
          "NotificationsAuthAlert",
          "OnboardingFeature",
          "RemoteNotificationsClient",
          "SettingsFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "Interface.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "PuzzleGen",
        "module_type" : "SwiftTarget",
        "name" : "PuzzleGen",
        "path" : "Sources/PuzzleGen",
        "product_dependencies" : [
          "Gen"
        ],
        "product_memberships" : [
          "DictionarySqliteClient",
          "PuzzleGen",
          "AppFeature",
          "DemoFeature",
          "DictionaryFileClient",
          "GameCore",
          "GameFeature",
          "OnboardingFeature",
          "TrailerFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap"
        ],
        "sources" : [
          "English.swift"
        ],
        "target_dependencies" : [
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "PushMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "PushMiddlewareTests",
        "path" : "Tests/PushMiddlewareTests",
        "product_dependencies" : [
          "CustomDump",
          "Either",
          "HttpPipeline",
          "HttpPipelineTestSupport",
          "Overture",
          "Prelude",
          "SnapshotTesting"
        ],
        "sources" : [
          "PushMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "DatabaseClient",
          "PushMiddleware",
          "ServerRouter",
          "SharedModels",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "PushMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "PushMiddleware",
        "path" : "Sources/PushMiddleware",
        "product_dependencies" : [
          "Either",
          "HttpPipeline",
          "Prelude"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "PushMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "sources" : [
          "PushSettingMiddleware.swift",
          "PushTokenMiddleware.swift"
        ],
        "target_dependencies" : [
          "Build",
          "DatabaseClient",
          "SharedModels",
          "SnsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "OnboardingFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "OnboardingFeatureTests",
        "path" : "Tests/OnboardingFeatureTests",
        "sources" : [
          "OnboardingFeatureTests.swift"
        ],
        "target_dependencies" : [
          "OnboardingFeature"
        ],
        "type" : "test"
      },
      {
        "c99name" : "OnboardingFeature",
        "module_type" : "SwiftTarget",
        "name" : "OnboardingFeature",
        "path" : "Sources/OnboardingFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DemoFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "OnboardingGameState.swift",
          "OnboardingStepView.swift",
          "OnboardingView.swift"
        ],
        "target_dependencies" : [
          "CubeCore",
          "GameCore",
          "DictionaryClient",
          "FeedbackGeneratorClient",
          "LowPowerModeClient",
          "PuzzleGen",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "NotificationsAuthAlert",
        "module_type" : "SwiftTarget",
        "name" : "NotificationsAuthAlert",
        "path" : "Sources/NotificationsAuthAlert",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "NotificationsAuthAlert",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "NotificationsAuthAlert.swift"
        ],
        "target_dependencies" : [
          "CombineHelpers",
          "ComposableUserNotifications",
          "NotificationHelpers",
          "RemoteNotificationsClient",
          "Styleguide"
        ],
        "type" : "library"
      },
      {
        "c99name" : "NotificationHelpers",
        "module_type" : "SwiftTarget",
        "name" : "NotificationHelpers",
        "path" : "Sources/NotificationHelpers",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "NotificationHelpers",
          "NotificationsAuthAlert",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "NotificationHelpers.swift"
        ],
        "target_dependencies" : [
          "ComposableUserNotifications",
          "RemoteNotificationsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "MultiplayerFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "MultiplayerFeatureTests",
        "path" : "Tests/MultiplayerFeatureTests",
        "sources" : [
          "MultiplayerFeatureTests.swift",
          "PastGamesTests.swift"
        ],
        "target_dependencies" : [
          "MultiplayerFeature",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "MultiplayerFeature",
        "module_type" : "SwiftTarget",
        "name" : "MultiplayerFeature",
        "path" : "Sources/MultiplayerFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "HomeFeature",
          "MultiplayerFeature"
        ],
        "sources" : [
          "MultiplayerView.swift",
          "PastGameRow.swift",
          "PastGamesView.swift"
        ],
        "target_dependencies" : [
          "ClientModels",
          "ComposableGameCenter",
          "Styleguide",
          "TcaHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "MiddlewareHelpers",
        "module_type" : "SwiftTarget",
        "name" : "MiddlewareHelpers",
        "path" : "Sources/MiddlewareHelpers",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DemoMiddleware",
          "LeaderboardMiddleware",
          "MiddlewareHelpers",
          "RunnerTasks",
          "ServerBootstrap",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "MiddlewareHelpers.swift"
        ],
        "target_dependencies" : [
          "EnvVars"
        ],
        "type" : "library"
      },
      {
        "c99name" : "MailgunClient",
        "module_type" : "SwiftTarget",
        "name" : "MailgunClient",
        "path" : "Sources/MailgunClient",
        "product_dependencies" : [
          "Either",
          "Tagged",
          "UrlFormEncoding"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "MailgunClient",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "sources" : [
          "Interface.swift",
          "Live.swift",
          "Mocks.swift"
        ],
        "target_dependencies" : [
          "ServerTestHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "LowPowerModeClient",
        "module_type" : "SwiftTarget",
        "name" : "LowPowerModeClient",
        "path" : "Sources/LowPowerModeClient",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "LowPowerModeClient",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "Client.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "LocalDatabaseClient",
        "module_type" : "SwiftTarget",
        "name" : "LocalDatabaseClient",
        "path" : "Sources/LocalDatabaseClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Overture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LocalDatabaseClient",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "InMemory.swift",
          "Interface.swift",
          "Live.swift",
          "TestKey.swift"
        ],
        "target_dependencies" : [
          "SharedModels",
          "Sqlite",
          "XCTestDebugSupport"
        ],
        "type" : "library"
      },
      {
        "c99name" : "LeaderboardMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "LeaderboardMiddlewareTests",
        "path" : "Tests/LeaderboardMiddlewareTests",
        "product_dependencies" : [
          "CustomDump",
          "HttpPipelineTestSupport",
          "SnapshotTesting"
        ],
        "sources" : [
          "FetchWeekInReviewMiddlewareTests.swift",
          "LeaderboardMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "LeaderboardMiddleware",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "LeaderboardMiddlewareIntegrationTests",
        "module_type" : "SwiftTarget",
        "name" : "LeaderboardMiddlewareIntegrationTests",
        "path" : "Tests/LeaderboardMiddlewareIntegrationTests",
        "product_dependencies" : [
          "HttpPipeline",
          "HttpPipelineTestSupport",
          "Prelude",
          "SnapshotTesting"
        ],
        "sources" : [
          "LeaderboardMiddlewareIntegrationTests.swift"
        ],
        "target_dependencies" : [
          "DatabaseLive",
          "LeaderboardMiddleware",
          "SharedModels",
          "ServerRouter",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "LeaderboardMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "LeaderboardMiddleware",
        "path" : "Sources/LeaderboardMiddleware",
        "product_dependencies" : [
          "CasePaths",
          "HttpPipeline"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "LeaderboardMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "sources" : [
          "FetchLeaderboardMiddleware.swift",
          "FetchWeekInReviewMiddleware.swift",
          "SubmitGameMiddleware.swift",
          "VocabMiddleware.swift"
        ],
        "target_dependencies" : [
          "DatabaseClient",
          "DictionaryClient",
          "MiddlewareHelpers",
          "ServerRouter"
        ],
        "type" : "library"
      },
      {
        "c99name" : "LeaderboardFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "LeaderboardFeatureTests",
        "path" : "Tests/LeaderboardFeatureTests",
        "sources" : [
          "LeaderboardFeatureIntegrationTests.swift",
          "LeaderboardFeatureTests.swift",
          "LeaderboardResultsTests.swift"
        ],
        "target_dependencies" : [
          "LeaderboardFeature",
          "IntegrationTestHelpers",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "LeaderboardFeature",
        "module_type" : "SwiftTarget",
        "name" : "LeaderboardFeature",
        "path" : "Sources/LeaderboardFeature",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Overture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DailyChallengeFeature",
          "HomeFeature",
          "LeaderboardFeature"
        ],
        "sources" : [
          "Leaderboard.swift",
          "LeaderboardResultsView.swift",
          "ResultsEnvelope.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "AudioPlayerClient",
          "CubePreview",
          "LowPowerModeClient",
          "Styleguide",
          "SwiftUIHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "IntegrationTestHelpers",
        "module_type" : "SwiftTarget",
        "name" : "IntegrationTestHelpers",
        "path" : "Sources/IntegrationTestHelpers",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "IntegrationTestHelpers"
        ],
        "sources" : [
          "IntegrationTestHelpers.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "ServerRouter",
          "TestHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "HomeFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "HomeFeatureTests",
        "path" : "Tests/HomeFeatureTests",
        "product_dependencies" : [
          "SnapshotTesting"
        ],
        "sources" : [
          "HomeViewTests.swift"
        ],
        "target_dependencies" : [
          "HomeFeature"
        ],
        "type" : "test"
      },
      {
        "c99name" : "HomeFeature",
        "module_type" : "SwiftTarget",
        "name" : "HomeFeature",
        "path" : "Sources/HomeFeature",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Overture"
        ],
        "product_memberships" : [
          "AppFeature",
          "HomeFeature"
        ],
        "sources" : [
          "DailyChallengeHeaderView.swift",
          "Home.swift",
          "LeaderboardLinkView.swift",
          "Marquee.swift",
          "NagBanner.swift",
          "StartNewGameView.swift"
        ],
        "target_dependencies" : [
          "ActiveGamesFeature",
          "ApiClient",
          "AudioPlayerClient",
          "Build",
          "ChangelogFeature",
          "ClientModels",
          "CombineHelpers",
          "ComposableStoreKit",
          "ComposableUserNotifications",
          "DailyChallengeFeature",
          "DateHelpers",
          "DeviceId",
          "FileClient",
          "LeaderboardFeature",
          "LocalDatabaseClient",
          "LowPowerModeClient",
          "MultiplayerFeature",
          "ServerConfigClient",
          "SettingsFeature",
          "SharedModels",
          "SoloFeature",
          "Styleguide",
          "SwiftUIHelpers",
          "TcaHelpers",
          "UIApplicationClient",
          "UpgradeInterstitialFeature",
          "UserDefaultsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "HapticsCore",
        "module_type" : "SwiftTarget",
        "name" : "HapticsCore",
        "path" : "Sources/HapticsCore",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HapticsCore",
          "HomeFeature",
          "LeaderboardFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "HapticsCore.swift"
        ],
        "target_dependencies" : [
          "FeedbackGeneratorClient",
          "TcaHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Gzip",
        "module_type" : "SwiftTarget",
        "name" : "Gzip",
        "path" : "Sources/Gzip",
        "product_memberships" : [
          "DictionaryFileClient"
        ],
        "sources" : [
          "Data+Gzip.swift"
        ],
        "target_dependencies" : [
          "system-zlib"
        ],
        "type" : "library"
      },
      {
        "c99name" : "GameOverFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "GameOverFeatureTests",
        "path" : "Tests/GameOverFeatureTests",
        "product_dependencies" : [
          "SnapshotTesting"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Tests/GameOverFeatureTests/Resources/you.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Tests/GameOverFeatureTests/Resources/opponent.png",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "GameOverFeatureTests.swift",
          "GameOverViewTests.swift"
        ],
        "target_dependencies" : [
          "FirstPartyMocks",
          "GameOverFeature",
          "SharedSwiftUIEnvironment",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "GameOverFeatureIntegrationTests",
        "module_type" : "SwiftTarget",
        "name" : "GameOverFeatureIntegrationTests",
        "path" : "Tests/GameOverFeatureIntegrationTests",
        "sources" : [
          "GameOverFeatureIntegrationTests.swift"
        ],
        "target_dependencies" : [
          "GameOverFeature",
          "IntegrationTestHelpers",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "GameOverFeature",
        "module_type" : "SwiftTarget",
        "name" : "GameOverFeature",
        "path" : "Sources/GameOverFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "CompletedMatch.swift",
          "Confetti.swift",
          "GameOverView.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "AudioPlayerClient",
          "ClientModels",
          "CombineHelpers",
          "ComposableStoreKit",
          "DailyChallengeHelpers",
          "FileClient",
          "FirstPartyMocks",
          "LocalDatabaseClient",
          "NotificationHelpers",
          "NotificationsAuthAlert",
          "SharedModels",
          "SharedSwiftUIEnvironment",
          "SwiftUIHelpers",
          "TcaHelpers",
          "UpgradeInterstitialFeature",
          "UserDefaultsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "GameFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "GameFeatureTests",
        "path" : "Tests/GameFeatureTests",
        "product_dependencies" : [
          "Gen"
        ],
        "sources" : [
          "DailyChallengeTests.swift",
          "GameFeatureTests.swift",
          "Generators.swift"
        ],
        "target_dependencies" : [
          "AppFeature",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "GameFeature",
        "module_type" : "SwiftTarget",
        "name" : "GameFeature",
        "path" : "Sources/GameFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "GameFeature"
        ],
        "sources" : [
          "GameFeature.swift",
          "GameFeatureView.swift"
        ],
        "target_dependencies" : [
          "ActiveGamesFeature",
          "ApiClient",
          "AudioPlayerClient",
          "BottomMenu",
          "ClientModels",
          "ComposableGameCenter",
          "ComposableUserNotifications",
          "CubeCore",
          "DictionaryClient",
          "GameCore",
          "GameOverFeature",
          "FeedbackGeneratorClient",
          "FileClient",
          "LowPowerModeClient",
          "PuzzleGen",
          "RemoteNotificationsClient",
          "SettingsFeature",
          "Styleguide",
          "TcaHelpers",
          "UIApplicationClient",
          "UpgradeInterstitialFeature"
        ],
        "type" : "library"
      },
      {
        "c99name" : "GameCoreTests",
        "module_type" : "SwiftTarget",
        "name" : "GameCoreTests",
        "path" : "Tests/GameCoreTests",
        "product_dependencies" : [
          "SnapshotTesting"
        ],
        "sources" : [
          "CubeViewTests.swift",
          "GameCoreTests.swift"
        ],
        "target_dependencies" : [
          "GameCore",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "GameCore",
        "module_type" : "SwiftTarget",
        "name" : "GameCore",
        "path" : "Sources/GameCore",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/GameCore/Resources/flag@2x.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/GameCore/Resources/exit@2x.png",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "CubeSceneViewState.swift",
          "Drawer.swift",
          "GameCore.swift",
          "GameOver.swift",
          "InProgressGame.swift",
          "Mocks.swift",
          "SoundsCore.swift",
          "TurnBased.swift",
          "Views/GameFooterView.swift",
          "Views/GameHeaderView.swift",
          "Views/GameNavView.swift",
          "Views/GameView.swift",
          "Views/PlayersAndScoresView.swift",
          "Views/WordSubmitButton.swift"
        ],
        "target_dependencies" : [
          "ActiveGamesFeature",
          "ApiClient",
          "AudioPlayerClient",
          "Bloom",
          "BottomMenu",
          "Build",
          "ClientModels",
          "ComposableGameCenter",
          "ComposableUserNotifications",
          "CubeCore",
          "DictionaryClient",
          "GameOverFeature",
          "FeedbackGeneratorClient",
          "FileClient",
          "HapticsCore",
          "LowPowerModeClient",
          "PuzzleGen",
          "RemoteNotificationsClient",
          "SelectionSoundsCore",
          "SharedSwiftUIEnvironment",
          "Styleguide",
          "TcaHelpers",
          "UIApplicationClient",
          "UpgradeInterstitialFeature"
        ],
        "type" : "library"
      },
      {
        "c99name" : "FirstPartyMocks",
        "module_type" : "SwiftTarget",
        "name" : "FirstPartyMocks",
        "path" : "Sources/FirstPartyMocks",
        "product_memberships" : [
          "DictionaryClient",
          "DictionarySqliteClient",
          "FirstPartyMocks",
          "PuzzleGen",
          "ServerRouter",
          "SharedModels",
          "ActiveGamesFeature",
          "ApiClient",
          "ApiClientLive",
          "AppFeature",
          "ChangelogFeature",
          "ClientModels",
          "ComposableGameCenter",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "DictionaryFileClient",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "IntegrationTestHelpers",
          "LeaderboardFeature",
          "LocalDatabaseClient",
          "MultiplayerFeature",
          "OnboardingFeature",
          "SelectionSoundsCore",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DatabaseClient",
          "DatabaseLive",
          "DemoMiddleware",
          "LeaderboardMiddleware",
          "PushMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "ServerConfigMiddleware",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "Date.swift",
          "TimeZone.swift",
          "UUID.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "FileClient",
        "module_type" : "SwiftTarget",
        "name" : "FileClient",
        "path" : "Sources/FileClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "SoloFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "Client.swift",
          "FileClientEffects.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "target_dependencies" : [
          "ClientModels",
          "CombineHelpers",
          "XCTestDebugSupport"
        ],
        "type" : "library"
      },
      {
        "c99name" : "FeedbackGeneratorClient",
        "module_type" : "SwiftTarget",
        "name" : "FeedbackGeneratorClient",
        "path" : "Sources/FeedbackGeneratorClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "FeedbackGeneratorClient",
          "GameCore",
          "GameFeature",
          "HapticsCore",
          "HomeFeature",
          "LeaderboardFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "Client.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "target_dependencies" : [
          "XCTestDebugSupport"
        ],
        "type" : "library"
      },
      {
        "c99name" : "EnvVars",
        "module_type" : "SwiftTarget",
        "name" : "EnvVars",
        "path" : "Sources/EnvVars",
        "product_dependencies" : [
          "Tagged"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DemoMiddleware",
          "EnvVars",
          "LeaderboardMiddleware",
          "MiddlewareHelpers",
          "RunnerTasks",
          "ServerBootstrap",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "EnvVars.swift"
        ],
        "target_dependencies" : [
          "SnsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DictionarySqliteClientTests",
        "module_type" : "SwiftTarget",
        "name" : "DictionarySqliteClientTests",
        "path" : "Tests/DictionarySqliteClientTests",
        "sources" : [
          "DictionarySqliteClientTests.swift"
        ],
        "target_dependencies" : [
          "DictionarySqliteClient"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DictionarySqliteClient",
        "module_type" : "SwiftTarget",
        "name" : "DictionarySqliteClient",
        "path" : "Sources/DictionarySqliteClient",
        "product_memberships" : [
          "DictionarySqliteClient",
          "AppFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/DictionarySqliteClient/Dictionaries",
            "rule" : {
              "copy" : {

              }
            }
          }
        ],
        "sources" : [
          "LiveKey.swift"
        ],
        "target_dependencies" : [
          "DictionaryClient",
          "PuzzleGen",
          "Sqlite"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DictionaryFileClientTests",
        "module_type" : "SwiftTarget",
        "name" : "DictionaryFileClientTests",
        "path" : "Tests/DictionaryFileClientTests",
        "sources" : [
          "DictionaryFileClientTests.swift"
        ],
        "target_dependencies" : [
          "DictionaryFileClient"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DictionaryFileClient",
        "module_type" : "SwiftTarget",
        "name" : "DictionaryFileClient",
        "path" : "Sources/DictionaryFileClient",
        "product_memberships" : [
          "DictionaryFileClient"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/DictionaryFileClient/Dictionaries",
            "rule" : {
              "copy" : {

              }
            }
          }
        ],
        "sources" : [
          "Live.swift"
        ],
        "target_dependencies" : [
          "DictionaryClient",
          "Gzip",
          "PuzzleGen"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DictionaryClient",
        "module_type" : "SwiftTarget",
        "name" : "DictionaryClient",
        "path" : "Sources/DictionaryClient",
        "product_dependencies" : [
          "Dependencies",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "DictionaryClient",
          "DictionarySqliteClient",
          "AppFeature",
          "DemoFeature",
          "DictionaryFileClient",
          "GameCore",
          "GameFeature",
          "OnboardingFeature",
          "TrailerFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "DemoMiddleware",
          "LeaderboardMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "sources" : [
          "Client.swift",
          "Puzzle.swift",
          "TestKey.swift"
        ],
        "target_dependencies" : [
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DeviceId",
        "module_type" : "SwiftTarget",
        "name" : "DeviceId",
        "path" : "Sources/DeviceId",
        "product_dependencies" : [
          "Dependencies",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "DeviceId",
          "HomeFeature"
        ],
        "sources" : [
          "DeviceId.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DemoMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "DemoMiddlewareTests",
        "path" : "Tests/DemoMiddlewareTests",
        "product_dependencies" : [
          "HttpPipelineTestSupport",
          "SnapshotTesting"
        ],
        "sources" : [
          "DemoMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "DemoMiddleware",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DemoMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "DemoMiddleware",
        "path" : "Sources/DemoMiddleware",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "DemoMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "sources" : [
          "DemoMiddleware.swift"
        ],
        "target_dependencies" : [
          "DatabaseClient",
          "DictionaryClient",
          "MiddlewareHelpers",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DemoFeature",
        "module_type" : "SwiftTarget",
        "name" : "DemoFeature",
        "path" : "Sources/DemoFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "DemoFeature"
        ],
        "sources" : [
          "Demo.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "Build",
          "GameCore",
          "DictionaryClient",
          "FeedbackGeneratorClient",
          "LowPowerModeClient",
          "OnboardingFeature",
          "SharedModels",
          "UserDefaultsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DateHelpers",
        "module_type" : "SwiftTarget",
        "name" : "DateHelpers",
        "path" : "Sources/DateHelpers",
        "product_memberships" : [
          "ActiveGamesFeature",
          "AppFeature",
          "DailyChallengeFeature",
          "DateHelpers",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "TimeUntilTomorrow.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DatabaseLiveTests",
        "module_type" : "SwiftTarget",
        "name" : "DatabaseLiveTests",
        "path" : "Tests/DatabaseLiveTests",
        "product_dependencies" : [
          "CustomDump"
        ],
        "sources" : [
          "DatabaseLiveTests.swift",
          "DatabaseTestCase.swift",
          "FetchAppleReceiptTests.swift",
          "FetchDailyChallengeReportTests.swift",
          "FetchDailyChallengeResultsTests.swift",
          "FetchLeaderboardSummaryTests.swift",
          "FetchRankedLeaderboardScoresTests.swift",
          "FetchVocabLeaderboardTests.swift",
          "FetchWeekInReviewTests.swift"
        ],
        "target_dependencies" : [
          "DatabaseLive",
          "FirstPartyMocks",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DatabaseLive",
        "module_type" : "SwiftTarget",
        "name" : "DatabaseLive",
        "path" : "Sources/DatabaseLive",
        "product_dependencies" : [
          "CasePaths",
          "Overture",
          "Prelude",
          "PostgresKit"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "DatabaseLive",
          "RunnerTasks",
          "ServerBootstrap"
        ],
        "sources" : [
          "DatabaseLive.swift",
          "Helpers.swift"
        ],
        "target_dependencies" : [
          "DatabaseClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DatabaseClient",
        "module_type" : "SwiftTarget",
        "name" : "DatabaseClient",
        "path" : "Sources/DatabaseClient",
        "product_dependencies" : [
          "Either",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DatabaseClient",
          "DatabaseLive",
          "DemoMiddleware",
          "LeaderboardMiddleware",
          "PushMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "DatabaseClient.swift",
          "Mocks.swift"
        ],
        "target_dependencies" : [
          "Build",
          "ServerTestHelpers",
          "SharedModels",
          "SnsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DailyChallengeReportsTests",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeReportsTests",
        "path" : "Tests/DailyChallengeReportsTests",
        "product_dependencies" : [
          "CustomDump"
        ],
        "sources" : [
          "DailyChallengeReportsTests.swift"
        ],
        "target_dependencies" : [
          "DailyChallengeReports"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DailyChallengeReports",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeReports",
        "path" : "Sources/DailyChallengeReports",
        "product_memberships" : [
          "daily-challenge-reports",
          "DailyChallengeReports"
        ],
        "sources" : [
          "DailyChallengeReports.swift"
        ],
        "target_dependencies" : [
          "ServerBootstrap"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DailyChallengeMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeMiddlewareTests",
        "path" : "Tests/DailyChallengeMiddlewareTests",
        "product_dependencies" : [
          "CustomDump",
          "HttpPipeline",
          "HttpPipelineTestSupport",
          "SnapshotTesting"
        ],
        "sources" : [
          "DailyChallengeMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "FirstPartyMocks",
          "DailyChallengeMiddleware",
          "SharedModels",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DailyChallengeMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeMiddleware",
        "path" : "Sources/DailyChallengeMiddleware",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "sources" : [
          "DailyChallengeMiddleware.swift"
        ],
        "target_dependencies" : [
          "DatabaseClient",
          "MiddlewareHelpers",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DailyChallengeHelpers",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeHelpers",
        "path" : "Sources/DailyChallengeHelpers",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "DailyChallengeHelpers.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "FileClient",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "DailyChallengeFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeFeatureTests",
        "path" : "Tests/DailyChallengeFeatureTests",
        "product_dependencies" : [
          "SnapshotTesting"
        ],
        "sources" : [
          "DailyChallengeFeatureTests.swift",
          "DailyChallengeResultsViewTests.swift",
          "DailyChallengeViewTests.swift"
        ],
        "target_dependencies" : [
          "DailyChallengeFeature",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DailyChallengeFeatureIntegrationTests",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeFeatureIntegrationTests",
        "path" : "Tests/DailyChallengeFeatureIntegrationTests",
        "sources" : [
          "DailyChallengeFeatureIntegrationTests.swift"
        ],
        "target_dependencies" : [
          "DailyChallengeFeature",
          "IntegrationTestHelpers",
          "SiteMiddleware",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "DailyChallengeFeature",
        "module_type" : "SwiftTarget",
        "name" : "DailyChallengeFeature",
        "path" : "Sources/DailyChallengeFeature",
        "product_dependencies" : [
          "Overture",
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "DailyChallengeFeature",
          "HomeFeature"
        ],
        "sources" : [
          "CalendarView.swift",
          "DailyChallengeResults.swift",
          "DailyChallengeView.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "ComposableUserNotifications",
          "CubePreview",
          "DailyChallengeHelpers",
          "DateHelpers",
          "LeaderboardFeature",
          "NotificationHelpers",
          "NotificationsAuthAlert",
          "RemoteNotificationsClient",
          "SharedModels",
          "Styleguide"
        ],
        "type" : "library"
      },
      {
        "c99name" : "CubePreviewTests",
        "module_type" : "SwiftTarget",
        "name" : "CubePreviewTests",
        "path" : "Tests/CubePreviewTests",
        "sources" : [
          "CubePreviewTests.swift"
        ],
        "target_dependencies" : [
          "CubePreview",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "CubePreview",
        "module_type" : "SwiftTarget",
        "name" : "CubePreview",
        "path" : "Sources/CubePreview",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "CubePreview",
          "DailyChallengeFeature",
          "GameFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "SettingsFeature",
          "StatsFeature",
          "VocabFeature"
        ],
        "sources" : [
          "CubePreviewView.swift"
        ],
        "target_dependencies" : [
          "AudioPlayerClient",
          "Bloom",
          "CubeCore",
          "FeedbackGeneratorClient",
          "HapticsCore",
          "LowPowerModeClient",
          "SelectionSoundsCore",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "CubeCore",
        "module_type" : "SwiftTarget",
        "name" : "CubeCore",
        "path" : "Sources/CubeCore",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Gen"
        ],
        "product_memberships" : [
          "AppFeature",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/K.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/shaders/Letter.surface.shader",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/shaders/Face.geometry.shader",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/T.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/B.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/C.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/R.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/Z.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/Y.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/S.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/A.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/M.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/V.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/W.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/border.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/QU.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/X.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/U.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/E.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/P.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/O.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/I.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/H.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/D.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/G.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/L.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/F.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/N.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Sources/CubeCore/Resources/J.png",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "Attitude.swift",
          "Category.swift",
          "CubeFaceNode.swift",
          "CubeNode.swift",
          "CubeSceneView.swift",
          "CubeView.swift",
          "Geometries.swift",
          "LetterGeometry.swift",
          "NubView.swift",
          "ShaderHelpers.swift"
        ],
        "target_dependencies" : [
          "ClientModels",
          "SharedModels",
          "Styleguide"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Csqlite3",
        "module_type" : "SystemLibraryTarget",
        "name" : "Csqlite3",
        "path" : "Sources/Csqlite3",
        "product_memberships" : [
          "DictionarySqliteClient",
          "Sqlite",
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LocalDatabaseClient",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap"
        ],
        "sources" : [

        ],
        "type" : "system-target"
      },
      {
        "c99name" : "ComposableUserNotifications",
        "module_type" : "SwiftTarget",
        "name" : "ComposableUserNotifications",
        "path" : "Sources/ComposableUserNotifications",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "ComposableUserNotifications",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "NotificationHelpers",
          "NotificationsAuthAlert",
          "OnboardingFeature",
          "SettingsFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "Interface.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ComposableStoreKit",
        "module_type" : "SwiftTarget",
        "name" : "ComposableStoreKit",
        "path" : "Sources/ComposableStoreKit",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "ComposableStoreKit",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "TrailerFeature",
          "UpgradeInterstitialFeature"
        ],
        "sources" : [
          "Client.swift",
          "LiveKey.swift",
          "TestKey.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ComposableGameCenter",
        "module_type" : "SwiftTarget",
        "name" : "ComposableGameCenter",
        "path" : "Sources/ComposableGameCenter",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Overture",
          "Tagged",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "ActiveGamesFeature",
          "AppFeature",
          "ClientModels",
          "ComposableGameCenter",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "MultiplayerFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "CrossPlatformSupport.swift",
          "Interface.swift",
          "LiveKey.swift",
          "Mocks.swift",
          "Models.swift",
          "TestKey.swift"
        ],
        "target_dependencies" : [
          "CombineHelpers",
          "FirstPartyMocks"
        ],
        "type" : "library"
      },
      {
        "c99name" : "CombineHelpers",
        "module_type" : "SwiftTarget",
        "name" : "CombineHelpers",
        "path" : "Sources/CombineHelpers",
        "product_memberships" : [
          "ActiveGamesFeature",
          "AppFeature",
          "ClientModels",
          "CombineHelpers",
          "ComposableGameCenter",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "MultiplayerFeature",
          "NotificationsAuthAlert",
          "OnboardingFeature",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "TrailerFeature",
          "UpgradeInterstitialFeature",
          "VocabFeature"
        ],
        "sources" : [
          "Combine.swift",
          "ReplaySubject.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ClientModelsTests",
        "module_type" : "SwiftTarget",
        "name" : "ClientModelsTests",
        "path" : "Tests/ClientModelsTests",
        "product_dependencies" : [
          "CustomDump",
          "Overture",
          "SnapshotTesting"
        ],
        "sources" : [
          "GameContextTests.swift",
          "TurnBasedMatchDataTests.swift"
        ],
        "target_dependencies" : [
          "ClientModels",
          "FirstPartyMocks",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "ClientModels",
        "module_type" : "SwiftTarget",
        "name" : "ClientModels",
        "path" : "Sources/ClientModels",
        "product_memberships" : [
          "ActiveGamesFeature",
          "AppFeature",
          "ClientModels",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "MultiplayerFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "GameContext.swift",
          "InProgressGame.swift",
          "PanData.swift",
          "SavedGamesState.swift",
          "TurnBasedContext.swift",
          "TurnBasedMatchData.swift"
        ],
        "target_dependencies" : [
          "ComposableGameCenter",
          "SharedModels"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ChangelogFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "ChangelogFeatureTests",
        "path" : "Tests/ChangelogFeatureTests",
        "sources" : [
          "ChangelogFeatureTests.swift"
        ],
        "target_dependencies" : [
          "ChangelogFeature"
        ],
        "type" : "test"
      },
      {
        "c99name" : "ChangelogFeature",
        "module_type" : "SwiftTarget",
        "name" : "ChangelogFeature",
        "path" : "Sources/ChangelogFeature",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Overture"
        ],
        "product_memberships" : [
          "AppFeature",
          "ChangelogFeature",
          "HomeFeature"
        ],
        "sources" : [
          "ChangeView.swift",
          "ChangelogView.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "Build",
          "ServerConfigClient",
          "SharedModels",
          "Styleguide",
          "SwiftUIHelpers",
          "TcaHelpers",
          "UIApplicationClient",
          "UserDefaultsClient"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Build",
        "module_type" : "SwiftTarget",
        "name" : "Build",
        "path" : "Sources/Build",
        "product_dependencies" : [
          "Dependencies",
          "Tagged",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "Build",
          "DictionaryClient",
          "DictionarySqliteClient",
          "PuzzleGen",
          "ServerConfig",
          "ServerRouter",
          "SharedModels",
          "ActiveGamesFeature",
          "ApiClient",
          "ApiClientLive",
          "AppFeature",
          "ChangelogFeature",
          "ClientModels",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "DictionaryFileClient",
          "FileClient",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "IntegrationTestHelpers",
          "LeaderboardFeature",
          "LocalDatabaseClient",
          "MultiplayerFeature",
          "OnboardingFeature",
          "SelectionSoundsCore",
          "ServerConfigClient",
          "SettingsFeature",
          "SoloFeature",
          "StatsFeature",
          "TrailerFeature",
          "UpgradeInterstitialFeature",
          "VocabFeature",
          "daily-challenge-reports",
          "runner",
          "server",
          "DailyChallengeMiddleware",
          "DailyChallengeReports",
          "DatabaseClient",
          "DatabaseLive",
          "DemoMiddleware",
          "LeaderboardMiddleware",
          "PushMiddleware",
          "RunnerTasks",
          "ServerBootstrap",
          "ServerConfigMiddleware",
          "ShareGameMiddleware",
          "SiteMiddleware",
          "VerifyReceiptMiddleware"
        ],
        "sources" : [
          "Build.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "BottomMenu",
        "module_type" : "SwiftTarget",
        "name" : "BottomMenu",
        "path" : "Sources/BottomMenu",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "AppFeature",
          "BottomMenu",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "BottomMenu.swift",
          "ComposableBottomMenu.swift"
        ],
        "target_dependencies" : [
          "Styleguide"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Bloom",
        "module_type" : "SwiftTarget",
        "name" : "Bloom",
        "path" : "Sources/Bloom",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Gen"
        ],
        "product_memberships" : [
          "AppFeature",
          "Bloom",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "BloomBackground.swift"
        ],
        "target_dependencies" : [
          "Styleguide"
        ],
        "type" : "library"
      },
      {
        "c99name" : "AudioPlayerClient",
        "module_type" : "SwiftTarget",
        "name" : "AudioPlayerClient",
        "path" : "Sources/AudioPlayerClient",
        "product_dependencies" : [
          "ComposableArchitecture",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature",
          "AudioPlayerClient",
          "CubePreview",
          "DailyChallengeFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "OnboardingFeature",
          "SelectionSoundsCore",
          "SettingsFeature",
          "StatsFeature",
          "TrailerFeature",
          "VocabFeature"
        ],
        "sources" : [
          "Client.swift",
          "LiveKey.swift",
          "Sounds.swift",
          "TestKey.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "AppStoreSnapshotTests",
        "module_type" : "SwiftTarget",
        "name" : "AppStoreSnapshotTests",
        "path" : "Tests/AppStoreSnapshotTests",
        "product_dependencies" : [
          "SnapshotTesting"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Tests/AppStoreSnapshotTests/Resources/opponent.png",
            "rule" : {
              "process" : {

              }
            }
          },
          {
            "path" : "/Users/yuyu/code/isowords/Tests/AppStoreSnapshotTests/Resources/you.png",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "01-Solo.swift",
          "02-TurnBased.swift",
          "03-DailyChallenge.swift",
          "04-Leaderboard.swift",
          "05-Home.swift",
          "AppStorePreview.swift",
          "AppStoreSnapshotTests.swift",
          "AssertAppStoreSnapshot.swift",
          "SnapshotView.swift"
        ],
        "target_dependencies" : [
          "AppFeature",
          "SharedSwiftUIEnvironment",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "AppSiteAssociationMiddlewareTests",
        "module_type" : "SwiftTarget",
        "name" : "AppSiteAssociationMiddlewareTests",
        "path" : "Tests/AppSiteAssociationMiddlewareTests",
        "product_dependencies" : [
          "HttpPipelineTestSupport",
          "SnapshotTesting"
        ],
        "sources" : [
          "AppSiteAssociationMiddlewareTests.swift"
        ],
        "target_dependencies" : [
          "AppSiteAssociationMiddleware",
          "SiteMiddleware"
        ],
        "type" : "test"
      },
      {
        "c99name" : "AppSiteAssociationMiddleware",
        "module_type" : "SwiftTarget",
        "name" : "AppSiteAssociationMiddleware",
        "path" : "Sources/AppSiteAssociationMiddleware",
        "product_dependencies" : [
          "HttpPipeline"
        ],
        "product_memberships" : [
          "daily-challenge-reports",
          "runner",
          "server",
          "AppSiteAssociationMiddleware",
          "DailyChallengeReports",
          "RunnerTasks",
          "ServerBootstrap",
          "SiteMiddleware"
        ],
        "sources" : [
          "AppSiteAssociation.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "AppFeatureTests",
        "module_type" : "SwiftTarget",
        "name" : "AppFeatureTests",
        "path" : "Tests/AppFeatureTests",
        "sources" : [
          "Mocks/AppEnvironment.swift",
          "Mocks/CurrentPlayerMocks.swift",
          "Mocks/DailyChallengeEnvelopeMocks.swift",
          "Mocks/Generators.swift",
          "Mocks/Mocks.swift",
          "PersistenceTests.swift",
          "RemoteNotificationsTests.swift",
          "SharedGameTests.swift",
          "TurnBasedTests.swift",
          "UserNotificationsTests.swift"
        ],
        "target_dependencies" : [
          "AppFeature",
          "TestHelpers"
        ],
        "type" : "test"
      },
      {
        "c99name" : "AppFeature",
        "module_type" : "SwiftTarget",
        "name" : "AppFeature",
        "path" : "Sources/AppFeature",
        "product_dependencies" : [
          "ComposableArchitecture",
          "Gen",
          "Tagged",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "AppFeature"
        ],
        "sources" : [
          "AppDelegate.swift",
          "AppView.swift",
          "GameCenterCore.swift",
          "StoreKitCore.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "AudioPlayerClient",
          "Build",
          "ClientModels",
          "ComposableGameCenter",
          "ComposableStoreKit",
          "CubeCore",
          "CubePreview",
          "DailyChallengeFeature",
          "DeviceId",
          "DictionarySqliteClient",
          "FeedbackGeneratorClient",
          "FileClient",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "LeaderboardFeature",
          "LocalDatabaseClient",
          "LowPowerModeClient",
          "MultiplayerFeature",
          "NotificationHelpers",
          "OnboardingFeature",
          "RemoteNotificationsClient",
          "ServerRouter",
          "SettingsFeature",
          "SharedModels",
          "SoloFeature",
          "StatsFeature",
          "TcaHelpers",
          "UIApplicationClient",
          "VocabFeature"
        ],
        "type" : "library"
      },
      {
        "c99name" : "AppClipAudioLibrary",
        "module_type" : "SwiftTarget",
        "name" : "AppClipAudioLibrary",
        "path" : "Sources/AppClipAudioLibrary",
        "product_memberships" : [
          "AppClipAudioLibrary"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/AppClipAudioLibrary/Resources/empty.mp3",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "Bundle.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "AppAudioLibrary",
        "module_type" : "SwiftTarget",
        "name" : "AppAudioLibrary",
        "path" : "Sources/AppAudioLibrary",
        "product_memberships" : [
          "AppAudioLibrary"
        ],
        "resources" : [
          {
            "path" : "/Users/yuyu/code/isowords/Sources/AppAudioLibrary/Resources/empty.mp3",
            "rule" : {
              "process" : {

              }
            }
          }
        ],
        "sources" : [
          "Bundle.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ApiClientLive",
        "module_type" : "SwiftTarget",
        "name" : "ApiClientLive",
        "path" : "Sources/ApiClientLive",
        "product_dependencies" : [
          "Dependencies"
        ],
        "product_memberships" : [
          "ApiClientLive"
        ],
        "sources" : [
          "LiveKey.swift",
          "Secrets.swift"
        ],
        "target_dependencies" : [
          "ApiClient",
          "ServerRouter",
          "SharedModels",
          "TcaHelpers"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ApiClient",
        "module_type" : "SwiftTarget",
        "name" : "ApiClient",
        "path" : "Sources/ApiClient",
        "product_dependencies" : [
          "CasePaths",
          "Dependencies",
          "XCTestDynamicOverlay"
        ],
        "product_memberships" : [
          "ApiClient",
          "ApiClientLive",
          "AppFeature",
          "ChangelogFeature",
          "DailyChallengeFeature",
          "DailyChallengeHelpers",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "GameOverFeature",
          "HomeFeature",
          "IntegrationTestHelpers",
          "LeaderboardFeature",
          "OnboardingFeature",
          "SettingsFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "ApiDecode.swift",
          "Client.swift",
          "Helpers.swift",
          "TestKey.swift"
        ],
        "target_dependencies" : [
          "SharedModels",
          "XCTestDebugSupport"
        ],
        "type" : "library"
      },
      {
        "c99name" : "AnyComparable",
        "module_type" : "SwiftTarget",
        "name" : "AnyComparable",
        "path" : "Sources/AnyComparable",
        "product_memberships" : [
          "ActiveGamesFeature",
          "AnyComparable",
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "AnyComparable.swift"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ActiveGamesFeature",
        "module_type" : "SwiftTarget",
        "name" : "ActiveGamesFeature",
        "path" : "Sources/ActiveGamesFeature",
        "product_dependencies" : [
          "ComposableArchitecture"
        ],
        "product_memberships" : [
          "ActiveGamesFeature",
          "AppFeature",
          "DemoFeature",
          "GameCore",
          "GameFeature",
          "HomeFeature",
          "OnboardingFeature",
          "TrailerFeature"
        ],
        "sources" : [
          "ActiveGameCard.swift",
          "ActiveGamesView.swift",
          "ActiveTurnBasedMatch.swift"
        ],
        "target_dependencies" : [
          "AnyComparable",
          "ClientModels",
          "ComposableGameCenter",
          "DateHelpers",
          "SharedModels",
          "Styleguide",
          "TcaHelpers"
        ],
        "type" : "library"
      }
    ],
    "tools_version" : "5.5"
  }



  """.data(using: .utf8)!
