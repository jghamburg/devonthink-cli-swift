import ArgumentParser
import Foundation

/// Move a record to a different group.
struct MoveRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "move-record",
        abstract: "Move a record to a different group (can be in a different database)."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID of the record to move.")
    var identifier: String

    @Argument(help: "UUID or path of the destination group.")
    var destination: String

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)
        let destGroup = try resolver.resolveGroup(destination)

        guard let moved = app.moveRecord(record, from: nil, to: destGroup) as? DEVONthinkRecord else {
            throw CliError.operationFailed("Failed to move record.")
        }
        printResult(formatRecord(moved))
    }
}
