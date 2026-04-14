import ArgumentParser
import Foundation

/// Add tags to a record.
struct AddTags: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add-tags",
        abstract: "Add tags to a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID. Defaults to current selection.")
    var identifier: String?

    @Argument(parsing: .remaining, help: "Tags to add.")
    var tags: [String]

    func run() throws {
        guard !tags.isEmpty else {
            throw CliError.invalidArgument("At least one tag is required.")
        }
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)
        let existing = resolvedStrings(record.tags)
        let merged = Array(Set(existing + tags)).sorted()
        record.tags = merged
        printResult(formatRecord(record))
    }
}
