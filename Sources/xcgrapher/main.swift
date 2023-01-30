import Foundation
import XCGrapherLib

let options = XCGrapherArguments.parseOrExit().options

do {
    try XCGrapher.run(with: options)
} catch {
    die(error.localizedDescription)
}
