import ArgumentParser
import Foundation

/// Get classification proposals for a record.
struct Classify: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "classify",
        abstract: "Get a list of classification proposals for a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID. Defaults to current selection.")
    var identifier: String?

    @Option(name: .long, help: "Comparison type: data (default) or tags.")
    var comparison: String?

    @Flag(name: .long, help: "Propose tags instead of groups.")
    var tags: Bool = false

    @Option(name: .long, help: "Database name to scope classification.")
    var database: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)

        let db: DEVONthinkDatabase? = try resolveDatabase(app: app, name: database)
        let compType = parseComparisonType(comparison)

        guard let proposals = app.classifyRecord(
            record, in: db,
            comparison: compType,
            tags: tags
        ) as? [[String: Any]] else {
            printResults([])
            return
        }
        printResults(proposals)
    }
}

func parseComparisonType(_ value: String?) -> DEVONthinkComparisonType {
    guard let v = value?.lowercased() else { return DEVONthinkComparisonTypeDataComparison }
    switch v {
    case "tags", "tags-comparison", "tags_comparison":
        return DEVONthinkComparisonTypeTagsComparison
    default:
        return DEVONthinkComparisonTypeDataComparison
    }
}
