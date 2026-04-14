import ArgumentParser
import Foundation

/// List all open DEVONthink databases.
struct OpenDatabases: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "open-databases",
        abstract: "List all currently open DEVONthink databases."
    )

    func run() throws {
        let app = try requireApp()
        guard let dbs = app.databases() as? [DEVONthinkDatabase] else {
            printResult([String]())
            return
        }
        let items = dbs.map { formatDatabase($0) }
        printResults(items)
    }
}
