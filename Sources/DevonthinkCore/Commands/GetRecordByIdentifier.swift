import ArgumentParser
import Foundation

/// Get a record by UUID, item link, or numeric ID.
struct GetRecordByIdentifier: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-record-by-identifier",
        abstract: "Get a record by UUID, x-devonthink-item:// link, or numeric ID."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric scripting ID.")
    var identifier: String

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)
        printResult(formatRecord(record))
    }
}
