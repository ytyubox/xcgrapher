struct Ruby: ShellTask {

  var script: String
  let requiredDependencies: [String]

  init(require: String..., script: String) {
    requiredDependencies = require
    self.script = script
  }

  var stringRepresentation: String {
    let lines = script.breakIntoLines()
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
    return components.joined(separator: " ")
  }

  var commandNotFoundInstructions: String {
    "ruby not found"
  }

  var file: String {
    #filePath
  }
  var debugDescription: String {
    script
  }
}
