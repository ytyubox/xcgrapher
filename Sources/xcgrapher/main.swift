import Foundation
import XCGrapherCLIParser
import XCGrapherLib

let options = XCGrapherArguments.parseOrExit().options

do {
  try XCGrapher.run(with: options)
} catch {
  throw die(error.localizedDescription)
}
