import ArgumentParser
import Foundation

/// List the contents of a group record.
struct ListGroupContent: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "list-group-content",
        abstract: "List the direct children of a group record."
    )

    @Argument(help: "UUID, numeric ID, or path of the group. Defaults to current group.")
    var identifier: String?

    func run() throws {
        let app = try requireApp()

        let group: DEVONthinkParent
        if let id = identifier, !id.isEmpty, id != "/" {
            let resolver = RecordResolver(app: app)
            group = try resolver.resolveGroup(id)
        } else {
            guard let db = resolvedDatabase(app.currentDatabase),
                  let root = resolvedParent(db.root) else {
                throw CliError.commandFailed("No current database found.")
            }
            group = root
        }

        guard let children = group.children() as? [DEVONthinkRecord] else {
            printResults([])
            return
        }
        printResults(children.map { formatRecordSummary($0) })
    }
}
