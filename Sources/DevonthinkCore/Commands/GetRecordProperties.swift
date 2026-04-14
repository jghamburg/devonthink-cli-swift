import ArgumentParser
import Foundation

/// Get all properties of a record.
struct GetRecordProperties: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-record-properties",
        abstract: "Get all properties of a record."
    )

    @Argument(help: "UUID, x-devonthink-item:// URL, numeric ID, or path. Defaults to current selection.")
    var identifier: String?

    func run() throws {
        let app = try requireApp()
        let resolver = RecordResolver(app: app)
        let record = try resolver.resolve(identifier)
        printResult(formatRecordProperties(record))
    }
}

/// Full property set for get-record-properties (extends formatRecord).
/// Calls batchFetchProperties once and reuses the same batch dict for all fields —
/// base 18 fields via formatRecordFromBatch + 11 extra fields read directly from the
/// batch dict. Total cost: 1 Apple Event (+ 1 fallback AE for plainText if not in batch).
func formatRecordProperties(_ record: DEVONthinkRecord) -> [String: Any] {
    let batch = batchFetchProperties(record)

    if !batch.isEmpty {
        // Base 18 fields — reuses the already-fetched batch (no second pALL call)
        var dict = formatRecordFromBatch(batch, record)

        // Addition date
        if let addDate = batchDate(batch, kPropAdditionDate, "additionDate") {
            dict["additionDate"] = _isoFormatter.string(from: addDate)
        }

        // State flags
        dict["flag"]   = batchBool(batch, kPropFlag,    "flag")
        dict["unread"] = batchBool(batch, kPropUnread,  "unread")
        dict["locked"] = batchBool(batch, kPropLocking, "locking")

        // Counts
        dict["wordCount"]      = batchInt(batch, kPropWordCount,     "wordCount")
        dict["characterCount"] = batchInt(batch, kPropCharacterCount, "characterCount")

        // Exclusion flags
        dict["excludeFromChat"]           = batchBool(batch, kPropExcludeFromChat,     "excludeFromChat")
        dict["excludeFromClassification"] = batchBool(batch, kPropExcludeFromClassify, "excludeFromClassification")
        dict["excludeFromSearch"]         = batchBool(batch, kPropExcludeFromSearch,   "excludeFromSearch")
        dict["excludeFromSeeAlso"]        = batchBool(batch, kPropExcludeFromSeeAlso,  "excludeFromSeeAlso")
        dict["excludeFromTagging"]        = batchBool(batch, kPropExcludeFromTagging,  "excludeFromTagging")
        dict["excludeFromWikiLinking"]    = batchBool(batch, kPropExcludeFromWiki,     "excludeFromWikiLinking")

        // Plain text — try batch first; large records may omit it from pALL, fall back to
        // a single individual AE in that case.
        let typeName = dict["recordType"] as? String ?? ""
        let textTypes: Set<String> = ["markdown", "text", "formatted note", "rtf", "rtfd"]
        if textTypes.contains(typeName) {
            let text: String?
            if let fromBatch = batchString(batch, kPropPlainText, "plainText"), !fromBatch.isEmpty {
                text = fromBatch
            } else {
                text = resolvedString(record.plainText)
            }
            if let t = text, !t.isEmpty {
                dict["plainText"] = t.count > 1000 ? String(t.prefix(1000)) : t
            }
        }

        return dict
    }

    // ── Fallback: individual Apple Event per property ─────────────────────
    var dict = formatRecord(record)

    if let addDate = resolvedDate(record.additionDate) {
        dict["additionDate"] = _isoFormatter.string(from: addDate)
    }

    dict["flag"]   = record.flag
    dict["unread"] = record.unread
    dict["locked"] = record.locking

    dict["wordCount"]      = record.wordCount
    dict["characterCount"] = record.characterCount

    dict["excludeFromChat"]           = record.excludeFromChat
    dict["excludeFromClassification"] = record.excludeFromClassification
    dict["excludeFromSearch"]         = record.excludeFromSearch
    dict["excludeFromSeeAlso"]        = record.excludeFromSeeAlso
    dict["excludeFromTagging"]        = record.excludeFromTagging
    dict["excludeFromWikiLinking"]    = record.excludeFromWikiLinking

    let typeName = recordTypeName(record.recordType)
    let textTypes: Set<String> = ["markdown", "text", "formatted note", "rtf", "rtfd"]
    if textTypes.contains(typeName) {
        if let text = resolvedString(record.plainText), !text.isEmpty {
            dict["plainText"] = text.count > 1000 ? String(text.prefix(1000)) : text
        }
    }

    return dict
}
