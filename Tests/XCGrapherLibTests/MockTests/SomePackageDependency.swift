import Foundation
@testable import XCGrapherLib

private let SomePackageDependencyJSON =
  """
  {
    "identity": "somepackage",
    "name": "SomePackage",
    "url": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage",
    "version": "unspecified",
    "path": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage",
    "dependencies": [
      {
        "identity": "kingfisher",
        "name": "Kingfisher",
        "url": "https://github.com/onevcat/Kingfisher.git",
        "version": "6.3.0",
        "path": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Kingfisher",
        "dependencies": [

        ]
      },
      {
        "identity": "moya",
        "name": "Moya",
        "url": "https://github.com/Moya/Moya.git",
        "version": "14.0.0",
        "path": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Moya",
        "dependencies": [
          {
            "identity": "alamofire",
            "name": "Alamofire",
            "url": "https://github.com/Alamofire/Alamofire.git",
            "version": "5.4.3",
            "path": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Alamofire",
            "dependencies": [

            ]
          },
          {
            "identity": "reactiveswift",
            "name": "ReactiveSwift",
            "url": "https://github.com/Moya/ReactiveSwift.git",
            "version": "6.1.0",
            "path": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/ReactiveSwift",
            "dependencies": [

            ]
          },
          {
            "identity": "rxswift",
            "name": "RxSwift",
            "url": "https://github.com/ReactiveX/RxSwift.git",
            "version": "5.1.2",
            "path": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/RxSwift",
            "dependencies": [

            ]
          }
        ]
      },
      {
        "identity": "alamofire",
        "name": "Alamofire",
        "url": "https://github.com/Alamofire/Alamofire.git",
        "version": "5.4.3",
        "path": "/Users/yuyu/code/xcgrapher/Tests/SampleProjects/SomePackage/.build/checkouts/Alamofire",
        "dependencies": [

        ]
      }
    ]
  }


  """.data(using: .utf8)!

var SomePackageDependency: Dependency {
  try! JSONDecoder().decode(Dependency.self, from: SomePackageDependencyJSON)
}
