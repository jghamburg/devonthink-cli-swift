import ArgumentParser
import Foundation

/// Lookup records by a specific field value.
struct LookupRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "lookup-record",
        abstract: "Lookup records by a specific field value."
    )

    enum LookupType: String, ExpressibleByArgument, CaseIterable {
        case filename, path, url, tags, comment, contentHash = "content-hash"
    }

    @Argument(help: "The lookup type: filename, path, url, tags, comment, content-hash.")
    var lookupType: LookupType

    @Argument(help: "The value to look up. For tags, provide comma-separated values.")
    var value: String

    @Flag(name: .long, help: "For tags lookup: match any tag instead of all tags.")
    var any: Bool = false

    func run() throws {
        let app = try requireApp()
        var records: [DEVONthinkRecord] = []

        switch lookupType {
        case .filename:
            records = (app.lookupRecords(withFile: value, in: nil) as? [DEVONthinkRecord]) ?? []
        case .path:
            records = (app.lookupRecords(withPath: value, in: nil) as? [DEVONthinkRecord]) ?? []
        case .url:
            if value.hasPrefix("x-devonthink-item://") {
                let resolver = RecordResolver(app: app)
                if let record = try? resolver.resolveRequired(value) {
                    records = [record]
                } else {
                    records = []
                }
            } else {
                let decoded = value.removingPercentEncoding ?? value
                records = (app.lookupRecords(withURL: decoded, in: nil) as? [DEVONthinkRecord]) ?? []
            }
        case .tags:
            let tagList = value.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
            records = (app.lookupRecords(withTags: tagList, any: any, in: nil) as? [DEVONthinkRecord]) ?? []
        case .comment:
            records = (app.lookupRecords(withComment: value, in: nil) as? [DEVONthinkRecord]) ?? []
        case .contentHash:
            records = (app.lookupRecords(withContentHash: value, in: nil) as? [DEVONthinkRecord]) ?? []
        }

        printResults(records.map { formatRecord($0) })
    }
}
