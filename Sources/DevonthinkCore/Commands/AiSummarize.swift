import ArgumentParser
import Foundation

/// Summarize the content of one or more records using DEVONthink AI.
struct AiSummarize: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ai-summarize",
        abstract: "Summarize the content of one or more records using DEVONthink AI."
    )

    @Argument(parsing: .remaining, help: "UUIDs or identifiers of records to summarize.")
    var identifiers: [String]

    @Option(name: .long, help: "Output format: markdown (default), simple, rich.")
    var format: String = "markdown"

    @Option(name: .long, help: "Destination group UUID or path for the summary record.")
    var group: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)

        let records: [DEVONthinkRecord]
        if identifiers.isEmpty {
            // Use all selected records
            guard let arr = app.selectedRecords() as? [DEVONthinkRecord], !arr.isEmpty else {
                throw CliError.noSelection
            }
            records = arr
        } else {
            records = try identifiers.map { try resolver.resolveRequired($0) }
        }

        let contents = records.compactMap { $0 as? DEVONthinkContent }

        let destGroup: DEVONthinkParent?
        if let g = group {
            destGroup = try resolver.resolveGroup(g)
        } else {
            destGroup = nil
        }

        let summaryType = parseSummaryType(format)

        guard let result = app.summarizeContentsOf(
            in: destGroup, records: contents, to: summaryType, as: DEVONthinkSummaryStyleTextSummary
        ) as? DEVONthinkRecord else {
            throw CliError.operationFailed("Summarization returned no result. Verify DEVONthink AI is enabled and the selected content type is supported.")
        }
        printResult(formatRecord(result))
    }

    private func parseSummaryType(_ s: String) -> DEVONthinkSummaryType {
        switch s.lowercased() {
        case "rich", "rtf":     return DEVONthinkSummaryTypeRich
        case "simple":          return DEVONthinkSummaryTypeSimple
        default:                return DEVONthinkSummaryTypeMarkdown
        }
    }
}
