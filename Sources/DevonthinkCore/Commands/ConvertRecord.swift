import ArgumentParser
import Foundation

/// Convert a record to a different format.
struct ConvertRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "convert-record",
        abstract: "Convert a record to a different format."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID of the record to convert.")
    var identifier: String

    @Argument(help: "Target format: txt, rtf, formatted-note, html, markdown, bookmark, webarchive, pdf, single-page-pdf.")
    var toFormat: String

    @Option(name: .long, help: "Destination group UUID or path for the converted record.")
    var group: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolveRequired(identifier)

        let destGroup: DEVONthinkParent?
        if let g = group {
            destGroup = try resolver.resolveGroup(g)
        } else {
            destGroup = nil
        }

        let convertType = parseConvertType(toFormat)

        guard let converted = app.convertRecord(record, to: convertType, in: destGroup) as? DEVONthinkRecord else {
            throw CliError.operationFailed("Failed to convert record.")
        }
        printResult(formatRecord(converted))
    }

    private func parseConvertType(_ s: String) -> DEVONthinkConvertType {
        switch s.lowercased() {
        case "txt", "text", "simple":                              return DEVONthinkConvertTypeSimple
        case "rtf", "richtext", "rich":                            return DEVONthinkConvertTypeRich
        case "formatted-note", "formatted_note", "note":           return DEVONthinkConvertTypeNote
        case "html":                                               return DEVONthinkConvertTypeHTML
        case "markdown", "md":                                     return DEVONthinkConvertTypeMarkdown
        case "bookmark":                                           return DEVONthinkConvertTypeBookmark
        case "webarchive", "web-archive":                          return DEVONthinkConvertTypeWebarchive
        case "pdf", "pdf-document":                                return DEVONthinkConvertTypePDFDocument
        case "single-page-pdf", "single-page-pdf-document":       return DEVONthinkConvertTypeSinglePagePDFDocument
        default:
            // Print a warning and default to simple
            fputs("Warning: Unknown format '\(s)', defaulting to plain text.\n", stderr)
            return DEVONthinkConvertTypeSimple
        }
    }
}
