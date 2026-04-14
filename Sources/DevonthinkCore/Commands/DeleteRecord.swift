import ArgumentParser
import Foundation

/// Delete a record from DEVONthink.
struct DeleteRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "delete-record",
        abstract: "Delete a record. Removes from the specified group or all locations if no group given."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID of the record to delete.")
    var identifier: String

    @Option(name: .long, help: "UUID or path of the specific group to remove from (otherwise deletes all instances).")
    var from: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)

        var fromGroup: DEVONthinkParent? = nil
        if let f = from {
            fromGroup = try resolver.resolveGroup(f)
        }

        let success = app.deleteRecord(record, in: fromGroup)
        if !success {
            throw CliError.operationFailed("Failed to delete record.")
        }
        printResult("Record deleted.")
    }
}
