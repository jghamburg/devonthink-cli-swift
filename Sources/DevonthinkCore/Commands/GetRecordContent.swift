import ArgumentParser
import Foundation

/// Get the text content of a record.
struct GetRecordContent: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-record-content",
        abstract: "Get the text content of a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, numeric ID, or path. Defaults to current selection.")
    var identifier: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)

        let typeName = recordTypeName(record.recordType)
        let content: String

        switch typeName {
        case "rtf", "rtfd":
            // Rich text for RTF/RTFD
            content = resolvedString(record.richText) ?? resolvedString(record.plainText) ?? ""
        case "html", "web archive":
            // HTML source for HTML/webarchive
            content = resolvedString(record.source) ?? resolvedString(record.plainText) ?? ""
        default:
            // Plain text for markdown, text, formatted note, and everything else
            content = resolvedString(record.plainText) ?? ""
        }

        printResult(content)
    }
}
