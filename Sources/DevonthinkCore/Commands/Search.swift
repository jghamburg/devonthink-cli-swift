import ArgumentParser
import Foundation

/// Search for records in DEVONthink.
struct Search: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "Search for records. Supports DEVONthink search operators and wildcards."
    )

    @Argument(help: "The search query. Supports keys, operators, and wildcards.")
    var query: String

    @Option(name: .customLong("in"), help: "Group UUID or path to restrict search scope.")
    var scope: String?

    @Option(name: .long, help: "Database name to scope the search.")
    var database: String?

    @Option(name: .long, help: "Group numeric ID (requires --database).")
    var groupId: Int?

    @Option(name: .long, help: "Group path within the database (requires --database).")
    var groupPath: String?

    @Flag(name: .long, help: "Use the currently selected group as search scope.")
    var useCurrentGroup: Bool = false

    @Option(name: .long, help: "Search comparison mode: no-case (default), no-umlauts, fuzzy, related.")
    var comparison: String?

    @Option(name: .long, help: "Filter results by record type (e.g., markdown, pdf, group, bookmark).")
    var recordType: String?

    @Option(name: .long, help: "Maximum number of results to return (default: 50).")
    var limit: Int = 50

    @Flag(name: .long, help: "Do not search in subgroups of the specified group.")
    var excludeSubgroups: Bool = false

    func run() throws {
        let app = try requireApp()

        // Validate conflicting options
        if useCurrentGroup && (scope != nil || groupId != nil || groupPath != nil) {
            throw CliError.invalidArgument("--use-current-group conflicts with --in, --group-id, and --group-path.")
        }
        if groupId != nil && database == nil {
            throw CliError.invalidArgument("--group-id requires --database.")
        }
        if groupPath != nil && database == nil {
            throw CliError.invalidArgument("--group-path requires --database.")
        }

        // Resolve database if specified
        let db: DEVONthinkDatabase? = try resolveDatabase(app: app, name: database)

        // Resolve search scope
        var searchGroup: DEVONthinkParent? = nil
        if useCurrentGroup {
            searchGroup = resolvedParent(app.currentGroup)
        } else if let scopeId = scope {
            let resolver = RecordResolver(app: app)
            searchGroup = try resolver.resolveGroup(scopeId)
        } else if let gId = groupId, let targetDb = db {
            if let r = app.getRecordWithId(gId, in: targetDb as AnyObject?) as? DEVONthinkParent {
                searchGroup = r
            } else {
                throw CliError.recordNotFound("group ID \(gId)")
            }
        } else if let gPath = groupPath, let targetDb = db {
            if let records = app.lookupRecords(withPath: gPath, in: targetDb) as? [DEVONthinkRecord],
               let group = records.first as? DEVONthinkParent {
                searchGroup = group
            } else {
                throw CliError.recordNotFound("group path '\(gPath)'")
            }
        } else if let targetDb = db {
            // Database-only scope: use root group
            searchGroup = resolvedParent(targetDb.root)
        }

        let comparisonType = parseSearchComparison(comparison)

        let records = app.search(
            query,
            comparison: comparisonType,
            excludeSubgroups: excludeSubgroups,
            in: searchGroup
        ) as? [DEVONthinkRecord] ?? []

        // Post-search record type filtering
        var filtered = records
        if let typeFilter = recordType {
            let normalizedFilter = typeFilter.lowercased()
            filtered = records.filter { recordTypeName($0.recordType).lowercased() == normalizedFilter }
        }

        // Report totalCount (after type filtering, before limit)
        let totalCount = filtered.count

        // Apply limit
        let limited = Array(filtered.prefix(limit))
        let items = limited.map { formatRecordSummary($0) }

        switch currentOutputFormat {
        case .json:
            let wrapper: [String: Any] = [
                "result": items,
                "totalCount": totalCount
            ]
            printJSON(wrapper)
        case .human:
            for (i, item) in items.enumerated() {
                if i > 0 { print("") }
                for (k, v) in item.sorted(by: { $0.key < $1.key }) {
                    print("\(k): \(v)")
                }
            }
            if totalCount > limited.count {
                print("\n(\(totalCount) total results, showing first \(limited.count))")
            }
        }
    }
}

// MARK: - Helpers

/// Resolve a database by name from open databases.
func resolveDatabase(app: DEVONthinkApplication, name: String?) throws -> DEVONthinkDatabase? {
    guard let dbName = name, !dbName.isEmpty else { return nil }
    guard let dbs = app.databases() as? [DEVONthinkDatabase] else {
        throw CliError.databaseNotFound(dbName)
    }
    let lowered = dbName.lowercased()
    if let match = dbs.first(where: { ($0.name ?? "").lowercased() == lowered }) {
        return match
    }
    throw CliError.databaseNotFound(dbName)
}

func parseSearchComparison(_ value: String?) -> DEVONthinkSearchComparison {
    guard let v = value?.lowercased() else { return DEVONthinkSearchComparisonNoCase }
    switch v {
    case "no-case", "nocase":       return DEVONthinkSearchComparisonNoCase
    case "no-umlauts", "noumlauts": return DEVONthinkSearchComparisonNoUmlauts
    case "fuzzy":                   return DEVONthinkSearchComparisonFuzzy
    case "related":                 return DEVONthinkSearchComparisonRelated
    default:                        return DEVONthinkSearchComparisonNoCase
    }
}
