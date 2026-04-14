import ArgumentParser
import Foundation

/// Create a record from a URL (web document, PDF, Markdown, or formatted note).
struct CreateFromUrl: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-from-url",
        abstract: "Capture a web URL as a new record (PDF, web archive, Markdown, or formatted note)."
    )

    @Argument(help: "The URL to capture.")
    var url: String

    @Option(name: .long, help: "Output format: pdf, webarchive, markdown, formatted-note. Default: pdf.")
    var format: String = "pdf"

    @Option(name: .long, help: "Name for the new record. Derived from page title if omitted.")
    var name: String?

    @Option(name: .long, help: "Destination group UUID or path. Defaults to the current database's incoming group.")
    var group: String?

    @Flag(name: .long, help: "Enable pagination for PDF output.")
    var pdfPagination: Bool = false

    @Option(name: .long, help: "Viewport width for PDF rendering.")
    var pdfWidth: Int?

    @Flag(name: .long, help: "Enable readability mode (strip ads/navigation).")
    var readability: Bool = false

    func run() throws {
        let app = try requireApp()

        let dest: DEVONthinkParent
        if let groupId = group {
            let resolver = RecordResolver(app: app)
            dest = try resolver.resolveGroup(groupId)
        } else {
            guard let currentDb = resolvedDatabase(app.currentDatabase),
                  let incomingGroup = resolvedParent(currentDb.incomingGroup) else {
                throw CliError.commandFailed("No destination group available.")
            }
            dest = incomingGroup
        }

        let record: DEVONthinkRecord?

        switch format.lowercased() {
        case "pdf":
            record = app.createPDFDocument(
                from: url, agent: nil, in: dest, name: name, pagination: pdfPagination,
                readability: readability, referrer: nil,
                width: pdfWidth.map { NSNumber(value: $0) }
            ) as? DEVONthinkRecord

        case "webarchive", "web-archive", "web-document", "web_document":
            record = app.createWebDocument(
                from: url, agent: nil, in: dest, name: name, readability: readability, referrer: nil
            ) as? DEVONthinkRecord

        case "markdown", "md":
            record = app.createMarkdown(
                from: url, agent: nil, in: dest, name: name, readability: readability, referrer: nil
            ) as? DEVONthinkRecord

        case "formatted-note", "formatted_note", "formatted note":
            record = app.createFormattedNote(
                from: url, agent: nil, in: dest, name: name, readability: readability,
                referrer: nil, source: nil
            ) as? DEVONthinkRecord

        default:
            throw CliError.invalidArgument("Unknown format '\(format)'. Use: pdf, webarchive, markdown, formatted-note.")
        }

        guard let r = record else {
            throw CliError.operationFailed("Failed to create record from URL.")
        }
        printResult(formatRecord(r))
    }
}
