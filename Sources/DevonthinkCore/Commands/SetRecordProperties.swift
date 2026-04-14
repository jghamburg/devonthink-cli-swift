import ArgumentParser
import Foundation

/// Set properties on a record.
struct SetRecordProperties: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "set-record-properties",
        abstract: "Set one or more properties on a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, or numeric ID. Defaults to current selection.")
    var identifier: String?

    @Option(name: .long, help: "New name for the record.")
    var name: String?

    @Option(name: .long, help: "New comment.")
    var comment: String?

    @Option(name: .long, help: "New URL.")
    var url: String?

    @Option(name: .long, help: "Comma-separated tags (replaces existing tags).")
    var tags: String?

    @Flag(name: [.customLong("unread")], help: "Mark record as unread.")
    var markUnread: Bool = false

    @Flag(name: [.customLong("read")], help: "Mark record as read.")
    var markRead: Bool = false

    @Flag(name: .long, help: "Flag the record.")
    var flag: Bool = false

    @Flag(name: .long, help: "Unflag the record.")
    var unflag: Bool = false

    @Flag(name: .long, help: "Lock the record.")
    var locked: Bool = false

    @Flag(name: .long, help: "Unlock the record.")
    var unlocked: Bool = false

    @Flag(name: .customLong("exclude-from-chat"), help: "Exclude from AI chat.")
    var excludeFromChat: Bool = false

    @Flag(name: .customLong("include-in-chat"), help: "Include in AI chat.")
    var includeInChat: Bool = false

    @Flag(name: .customLong("exclude-from-classification"), help: "Exclude from classification.")
    var excludeFromClassification: Bool = false

    @Flag(name: .customLong("include-in-classification"), help: "Include in classification.")
    var includeInClassification: Bool = false

    @Flag(name: .customLong("exclude-from-search"), help: "Exclude from search.")
    var excludeFromSearch: Bool = false

    @Flag(name: .customLong("include-in-search"), help: "Include in search.")
    var includeInSearch: Bool = false

    @Flag(name: .customLong("exclude-from-see-also"), help: "Exclude from See Also.")
    var excludeFromSeeAlso: Bool = false

    @Flag(name: .customLong("include-in-see-also"), help: "Include in See Also.")
    var includeInSeeAlso: Bool = false

    @Flag(name: .customLong("exclude-from-tagging"), help: "Exclude group from tagging.")
    var excludeFromTagging: Bool = false

    @Flag(name: .customLong("include-in-tagging"), help: "Include group in tagging.")
    var includeInTagging: Bool = false

    @Flag(name: .customLong("exclude-from-wiki-linking"), help: "Exclude from Wiki linking.")
    var excludeFromWikiLinking: Bool = false

    @Flag(name: .customLong("include-in-wiki-linking"), help: "Include in Wiki linking.")
    var includeInWikiLinking: Bool = false

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)

        var updated: [String] = []
        var skipped: [String] = []

        if let n = name {
            record.name = n
            updated.append("name")
        }
        if let c = comment {
            record.comment = c
            updated.append("comment")
        }
        if let u = url {
            record.url = u
            updated.append("url")
        }
        if let t = tags {
            let tagList = t.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
            record.tags = tagList
            updated.append("tags")
        }
        if markUnread { record.unread = true; updated.append("unread") }
        if markRead   { record.unread = false; updated.append("unread") }
        if flag       { record.flag = true; updated.append("flag") }
        if unflag     { record.flag = false; updated.append("flag") }
        if locked     { record.locking = true; updated.append("locked") }
        if unlocked   { record.locking = false; updated.append("locked") }

        // Exclusion flags
        if excludeFromChat        { record.excludeFromChat = true; updated.append("excludeFromChat") }
        if includeInChat          { record.excludeFromChat = false; updated.append("excludeFromChat") }
        if excludeFromClassification { record.excludeFromClassification = true; updated.append("excludeFromClassification") }
        if includeInClassification   { record.excludeFromClassification = false; updated.append("excludeFromClassification") }
        if excludeFromSearch      { record.excludeFromSearch = true; updated.append("excludeFromSearch") }
        if includeInSearch        { record.excludeFromSearch = false; updated.append("excludeFromSearch") }
        if excludeFromSeeAlso     { record.excludeFromSeeAlso = true; updated.append("excludeFromSeeAlso") }
        if includeInSeeAlso       { record.excludeFromSeeAlso = false; updated.append("excludeFromSeeAlso") }
        if excludeFromWikiLinking { record.excludeFromWikiLinking = true; updated.append("excludeFromWikiLinking") }
        if includeInWikiLinking   { record.excludeFromWikiLinking = false; updated.append("excludeFromWikiLinking") }

        // excludeFromTagging only applies to groups
        if excludeFromTagging || includeInTagging {
            let typeName = recordTypeName(record.recordType)
            if typeName == "group" || typeName == "smart group" {
                if excludeFromTagging { record.excludeFromTagging = true; updated.append("excludeFromTagging") }
                if includeInTagging   { record.excludeFromTagging = false; updated.append("excludeFromTagging") }
            } else {
                skipped.append("excludeFromTagging (not a group)")
            }
        }

        var result = formatRecord(record)
        result["updated"] = updated
        if !skipped.isEmpty { result["skipped"] = skipped }
        printResult(result)
    }
}
