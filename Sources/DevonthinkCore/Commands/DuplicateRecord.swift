import ArgumentParser
import Foundation

/// Duplicate a record into a group.
struct DuplicateRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "duplicate-record",
        abstract: "Duplicate a record into a destination group."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID of the record to duplicate.")
    var identifier: String

    @Argument(help: "UUID or path of the destination group.")
    var destination: String

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)
        let destGroup = try resolver.resolveGroup(destination)

        guard let dup = app.duplicateRecord(record, to: destGroup) as? DEVONthinkRecord else {
            throw CliError.operationFailed("Failed to duplicate record.")
        }
        printResult(formatRecord(dup))
    }
}
