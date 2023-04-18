import Foundation

// MARK: - Custom Plugin

public class XCGrapherModuleImportPlugin {
  public func process(file: XCGrapherFile) throws -> [ImportInfo] {
    []
  }

  public func process(library: XCGrapherImport) throws -> [ImportInfo] {
    // We want to store:
    // - Who is being imported (library.moduleName)
    // - Who is doing the importing (library.importerName)
    // - A custom color we can use for rendering the arrow (see Extensions.swift)
    let importInfo = ImportInfo(
      importedModuleName: library.moduleName,
      importerModuleName: library.importerName,
      manager: library.moduleType.rawValue
    )

    return [importInfo]
  }

  public func makeArrows(from processingResults: [ImportInfo]) throws -> [XCGrapherArrow] {
    processingResults

      // For every item returned from a process(x:) function, make an edge (arrow) from the importing module to the
      // imported module.
      .map {
        XCGrapherArrow(
          origin: $0.importerModuleName,
          destination: $0.importedModuleName,
          color: $0.manager
        )
      }
  }
}
