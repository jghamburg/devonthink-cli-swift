import ArgumentParser
import Foundation

/// Remove tags from a record.
struct RemoveTags: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "remove-tags",
        abstract: "Remove tags from a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID. Defaults to current selection.")
    var identifier: String?

    @Argument(parsing: .remaining, help: "Tags to remove.")
    var tags: [String]

    func run() throws {
        guard !tags.isEmpty else {
            throw CliError.invalidArgument("At least one tag is required.")
        }
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)
        let existing = resolvedStrings(record.tags)
        let tagsToRemove = Set(tags)
        let updated = existing.filter { !tagsToRemove.contains($0) }
        record.tags = updated
        printResult(formatRecord(record))
    }
}
