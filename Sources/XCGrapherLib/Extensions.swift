import Foundation

extension XCGrapherImport.ModuleType {

  var customColor: String {
    switch self {
    case .target: return "target" // Black
    case .apple: return "apple" // That classic Apple blue colour we all know
    case .spm: return "spm" // The orange of the Swift logo
    case .local: return "local"
    case .cocoapods: return "cocoapods" // The banner color from Cocoapods.org
    case .other: return "other" // Red (something went wrong)
    }
  }

}
