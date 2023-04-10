import Foundation

enum Logger {
  static var log: (String) -> Void = {
    print($0)
  }

  static var logError: (String) -> Void = {
    let data = Data($0.utf8)
    FileHandle.standardError.write(data)
  }
}

public func die(
  _ message: String? = nil,
  file: String = #file,
  function: String = #function,
  line: Int = #line
) -> Error {
  return NSError(domain: message ?? "N/A", code: 1)
}

func Log(_ items: Any..., dim: Bool = false, file: String = #file) {
  let color = dim ? Colors.dim : ""
  Logger.log(items.reduce(color + logPrefix(file: file)) { $0 + " \($1)" } + Colors.reset)
}

func LogError(_ items: Any..., file: String = #file) {
  Logger.logError(items.reduce(Colors.red + logPrefix(file: file)) { $0 + " \($1)" } + Colors.reset)
}

func failWithContext<T>(attempt: @autoclosure () throws -> T, context: Any, file: String = #file) throws -> T {
  do {
    return try attempt()
  } catch {
    LogError("Error context:", String(describing: context), file: file)
    throw error
  }
}

private func logPrefix(file: String) -> String {
  let name = file.components(separatedBy: "/").last?.replacingOccurrences(of: ".swift", with: "") ?? "???"
  return "[\(name)]"
}

private enum Colors {
  static var red: String {
    if amIBeingDebugged {return ""}
    return "\u{001B}[0;31m"
  }

  static var dim: String {
    if amIBeingDebugged {return ""}
    return "\u{001B}[2m"
  }

  static var reset: String {
    if amIBeingDebugged {return ""}
    return "\u{001B}[0;0m"
  }
}

let amIBeingDebugged: Bool = {
  // Buffer for "sysctl(...)" call's result.
  var info = kinfo_proc()
  // Counts buffer's size in bytes (like C/C++'s `sizeof`).
  var size = MemoryLayout.stride(ofValue: info)
  // Tells we want info about own process.
  var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
  // Call the API (and assert success).
  let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
  assert(junk == 0, "sysctl failed")
  // Finally, checks if debugger's flag is present yet.
  return (info.kp_proc.p_flag & P_TRACED) != 0
}()
