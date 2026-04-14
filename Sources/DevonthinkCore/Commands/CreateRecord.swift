import ArgumentParser
import Foundation

/// Create a new record in DEVONthink.
struct CreateRecord: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-record",
        abstract: "Create a new record in DEVONthink."
    )

    @Option(name: .long, help: "Record name.")
    var name: String

    @Option(name: .long, help: "Record type: text, markdown, html, rtf, bookmark, group, formatted-note. Default: text.")
    var type: String = "text"

    @Option(name: .long, help: "Text content for the new record.")
    var content: String?

    @Option(name: .long, help: "URL for bookmark records.")
    var url: String?

    @Option(name: .long, help: "Comment for the record.")
    var comment: String?

    @Option(name: .long, help: "Comma-separated tags.")
    var tags: String?

    @Option(name: .long, help: "Destination group UUID or path. Defaults to the current database's incoming group.")
    var group: String?

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

        var props: [String: Any] = [
            "name": name,
            "type": recordTypeCode(type),
        ]
        if let c = content { props["content"] = c }
        if let u = url { props["URL"] = u }
        if let cm = comment { props["comment"] = cm }
        if let t = tags {
            props["tags"] = t.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        }

        guard let record = app.createRecord(with: props, in: dest) as? DEVONthinkRecord else {
            throw CliError.operationFailed("Failed to create record.")
        }
        printResult(formatRecord(record))
    }
}

func recordTypeCode(_ name: String) -> String {
    switch name.lowercased() {
    case "markdown", "md": return "markdown"
    case "html":           return "html"
    case "rtf", "richtext": return "rtf"
    case "bookmark":       return "bookmark"
    case "formatted note", "formatted-note", "formatted_note": return "formatted note"
    case "group":          return "group"
    case "text", "txt":    return "txt"
    default:               return name
    }
}
