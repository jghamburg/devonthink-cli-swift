import ArgumentParser
import Foundation

/// Update the text content of an existing record.
struct UpdateRecordContent: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "update-record-content",
        abstract: "Update the text content of a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID of the record.")
    var identifier: String

    @Option(name: .long, help: "New content to set (reads from stdin if omitted).")
    var content: String?

    @Flag(name: .long, help: "Append to existing content instead of replacing it.")
    var append: Bool = false

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)

        let newContent: String
        if let c = content {
            newContent = c
        } else {
            // Read from stdin
            var lines: [String] = []
            while let line = readLine(strippingNewline: false) {
                lines.append(line)
            }
            newContent = lines.joined()
        }

        let typeName = recordTypeName(record.recordType)
        let updatedProperty: String

        switch typeName {
        case "html", "web archive":
            // Set source for HTML/webarchive
            if append {
                let existing = resolvedString(record.source) ?? ""
                record.source = existing + newContent
            } else {
                record.source = newContent
            }
            updatedProperty = "source"
        default:
            // Set plainText for everything else
            if append {
                let existing = resolvedString(record.plainText) ?? ""
                record.plainText = existing + newContent
            } else {
                record.plainText = newContent
            }
            updatedProperty = "plainText"
        }

        var result = formatRecord(record)
        result["updatedProperty"] = updatedProperty
        printResult(result)
    }
}
