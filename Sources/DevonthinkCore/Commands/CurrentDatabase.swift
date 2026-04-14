import ArgumentParser
import Foundation

/// Get the currently active DEVONthink database.
struct CurrentDatabase: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "current-database",
        abstract: "Get the currently active DEVONthink database."
    )

    func run() throws {
        let app = try requireApp()
        guard let db = resolvedDatabase(app.currentDatabase) else {
            printErrorMessage("No current database found.")
        }
        printResult(formatDatabase(db))
    }
}
