//
//  File.swift
//
//
//  Created by Yu Yu on 2023/4/20.
//

import Foundation

private let MoyaPackageDescribeJSON =
  """
  {
    "dependencies" : [
      {
        "identity" : "alamofire",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "5.0.0",
              "upper_bound" : "6.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/Alamofire/Alamofire.git"
      },
      {
        "identity" : "reactiveswift",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "6.1.0",
              "upper_bound" : "7.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/Moya/ReactiveSwift.git"
      },
      {
        "identity" : "rxswift",
        "requirement" : {
          "range" : [
            {
              "lower_bound" : "5.0.0",
              "upper_bound" : "6.0.0"
            }
          ]
        },
        "type" : "sourceControl",
        "url" : "https://github.com/ReactiveX/RxSwift.git"
      }
    ],
    "manifest_display_name" : "Moya",
    "name" : "Moya",
    "path" : "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Moya",
    "platforms" : [
      {
        "name" : "macos",
        "version" : "10.12"
      },
      {
        "name" : "ios",
        "version" : "10.0"
      },
      {
        "name" : "tvos",
        "version" : "10.0"
      },
      {
        "name" : "watchos",
        "version" : "3.0"
      }
    ],
    "products" : [
      {
        "name" : "Moya",
        "targets" : [
          "Moya"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "ReactiveMoya",
        "targets" : [
          "ReactiveMoya"
        ],
        "type" : {
          "library" : [
            "automatic"
          ]
        }
      },
      {
        "name" : "RxMoya",
        "targets" : [
          "RxMoya"
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
        "c99name" : "RxMoya",
        "module_type" : "SwiftTarget",
        "name" : "RxMoya",
        "path" : "Sources/RxMoya",
        "product_dependencies" : [
          "RxSwift"
        ],
        "product_memberships" : [
          "RxMoya"
        ],
        "sources" : [
          "MoyaProvider+Rx.swift",
          "Observable+Response.swift",
          "Single+Response.swift"
        ],
        "target_dependencies" : [
          "Moya"
        ],
        "type" : "library"
      },
      {
        "c99name" : "ReactiveMoya",
        "module_type" : "SwiftTarget",
        "name" : "ReactiveMoya",
        "path" : "Sources/ReactiveMoya",
        "product_dependencies" : [
          "ReactiveSwift"
        ],
        "product_memberships" : [
          "ReactiveMoya"
        ],
        "sources" : [
          "MoyaProvider+Reactive.swift",
          "SignalProducer+Response.swift"
        ],
        "target_dependencies" : [
          "Moya"
        ],
        "type" : "library"
      },
      {
        "c99name" : "Moya",
        "module_type" : "SwiftTarget",
        "name" : "Moya",
        "path" : "Sources/Moya",
        "product_dependencies" : [
          "Alamofire"
        ],
        "product_memberships" : [
          "Moya",
          "ReactiveMoya",
          "RxMoya"
        ],
        "sources" : [
          "AnyEncodable.swift",
          "Cancellable.swift",
          "Endpoint.swift",
          "Image.swift",
          "Moya+Alamofire.swift",
          "MoyaError.swift",
          "MoyaProvider+Defaults.swift",
          "MoyaProvider+Internal.swift",
          "MoyaProvider.swift",
          "MultiTarget.swift",
          "MultipartFormData.swift",
          "Plugin.swift",
          "Plugins/AccessTokenPlugin.swift",
          "Plugins/CredentialsPlugin.swift",
          "Plugins/NetworkActivityPlugin.swift",
          "Plugins/NetworkLoggerPlugin.swift",
          "RequestTypeWrapper.swift",
          "Response.swift",
          "TargetType.swift",
          "Task.swift",
          "URL+Moya.swift",
          "URLRequest+Encoding.swift",
          "ValidationType.swift"
        ],
        "type" : "library"
      }
    ],
    "tools_version" : "5.0"
  }
  """.data(using: .utf8)!
