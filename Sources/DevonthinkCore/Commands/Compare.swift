import ArgumentParser
import Foundation

/// Get a list of records similar to a given record, or compare two records.
struct Compare: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "compare",
        abstract: "Get similar records, or compare two specific records."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID. Defaults to current selection.")
    var identifier: String?

    @Option(name: .long, help: "UUID of a second record for direct two-record comparison.")
    var compareWith: String?

    @Option(name: .long, help: "Comparison type: data (default) or tags.")
    var comparison: String?

    @Option(name: .long, help: "Database name to scope the comparison.")
    var database: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)

        let compType = parseComparisonType(comparison)

        if let compareWithId = compareWith {
            // Two-record comparison mode
            let record2 = try resolver.resolveRequired(compareWithId)
            let result = twoRecordComparison(record, record2)
            printResult(result)
        } else {
            // Single-record mode: find similar records
            let db: DEVONthinkDatabase? = try resolveDatabase(app: app, name: database)

            guard let similar = app.compareRecord(
                record, content: nil, to: db,
                comparison: compType
            ) as? [DEVONthinkRecord] else {
                printResult(["mode": "single_record", "similarRecords": [] as [[String: Any]], "totalCount": 0] as [String: Any])
                return
            }
            let items = similar.map { formatRecord($0) }
            printResult([
                "mode": "single_record",
                "similarRecords": items,
                "totalCount": items.count
            ] as [String: Any])
        }
    }

    private func twoRecordComparison(_ r1: DEVONthinkRecord, _ r2: DEVONthinkRecord) -> [String: Any] {
        let rec1Info = formatRecord(r1)
        let rec2Info = formatRecord(r2)

        let sameType = recordTypeName(r1.recordType) == recordTypeName(r2.recordType)

        let tags1 = resolvedStrings(r1.tags)
        let tags2 = resolvedStrings(r2.tags)
        let commonTags = Array(Set(tags1).intersection(Set(tags2)))
        let maxTagCount = max(tags1.count, tags2.count, 1)
        let tagSimilarity = Double(commonTags.count) / Double(maxTagCount)

        let sizeDifference = abs(r1.size - r2.size)

        return [
            "mode": "two_record",
            "record1": rec1Info,
            "record2": rec2Info,
            "comparison": [
                "sameType": sameType,
                "commonTags": commonTags,
                "sizeDifference": sizeDifference,
                "tagSimilarity": tagSimilarity
            ] as [String: Any]
        ] as [String: Any]
    }
}
