import ArgumentParser
import Foundation

/// Get tag suggestions for a record using DEVONthink AI classification.
struct AiSuggestTags: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ai-suggest-tags",
        abstract: "Get tag suggestions for a record using DEVONthink AI classification."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID. Defaults to current selection.")
    var identifier: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)

        let proposals = app.classifyRecord(
            record, in: nil,
            comparison: DEVONthinkComparisonTypeDataComparison,
            tags: true
        )

        if let groups = proposals as? [DEVONthinkParent] {
            let tags = groups.compactMap { $0.name }.filter { !$0.isEmpty }
            printResult(tags)
            return
        }

        if let records = proposals as? [DEVONthinkRecord] {
            let tags = records.compactMap { $0.name }.filter { !$0.isEmpty }
            printResult(tags)
            return
        }

        if let dicts = proposals as? [[String: Any]] {
            let tags = dicts.compactMap { $0["name"] as? String }
            printResult(tags)
            return
        }

        if let names = proposals as? [String] {
            printResult(names)
            return
        }

        if proposals == nil {
            printResults([])
            return
        }

        throw CliError.operationFailed("Unexpected classification result type: \(type(of: proposals as Any))")
    }
}
