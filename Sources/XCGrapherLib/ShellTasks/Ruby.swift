struct Ruby {
  var command: String

  init(require: String..., script: String) {
    let lines = script.breakIntoLines()
    let requiredDependencies = require
    var components = ["ruby"]
    for dependency in requiredDependencies {
      components.append(
        """
        -r '\(dependency)'
        """
      )
    }
    for line in lines {
      components.append(
        """
        -e '\(line)'
        """
      )
    }
    command = components.joined(separator: " ")
  }

  var stringRepresentation: String { command }
}
