import ArgumentParser
import Foundation

/// Replicate a record to another group in the same database.
struct ReplicateRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "replicate-record",
        abstract: "Replicate a record to another group (must be in the same database)."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID of the record to replicate.")
    var identifier: String

    @Argument(help: "UUID or path of the destination group (must be in the same database).")
    var destination: String

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)
        let destGroup = try resolver.resolveGroup(destination)

        // Validate same-database constraint
        guard let srcDb = resolvedDatabase(record.database),
              let dstDb = resolvedDatabase(destGroup.database),
              resolvedString(srcDb.uuid) == resolvedString(dstDb.uuid) else {
            throw CliError.crossDatabaseReplicate
        }

        guard let replicated = app.replicateRecord(record, to: destGroup) as? DEVONthinkRecord else {
            throw CliError.operationFailed("Failed to replicate record.")
        }
        printResult(formatRecord(replicated))
    }
}
