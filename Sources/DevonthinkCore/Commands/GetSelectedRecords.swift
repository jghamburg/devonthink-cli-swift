import ArgumentParser
import Foundation

/// Get currently selected records in DEVONthink.
struct GetSelectedRecords: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-selected-records",
        abstract: "Get the currently selected records in DEVONthink."
    )

    func run() throws {
        let app = try requireApp()
        guard let records = app.selectedRecords() as? [DEVONthinkRecord] else {
            printResults([])
            return
        }
        printResults(records.map { formatRecordSummary($0) })
    }
}
