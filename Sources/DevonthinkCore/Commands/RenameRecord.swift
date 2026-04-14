import ArgumentParser
import Foundation

/// Rename a record.
struct RenameRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "rename-record",
        abstract: "Rename a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID.")
    var identifier: String

    @Argument(help: "New name for the record.")
    var newName: String

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)
        record.name = newName
        printResult(formatRecord(record))
    }
}
