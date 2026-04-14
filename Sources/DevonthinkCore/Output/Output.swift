import Foundation

/// Controls output format for the current invocation.
/// Set once at startup from the root command's --json flag.
public enum OutputFormat {
    case human
    case json
}

public var currentOutputFormat: OutputFormat = .human

/// Shared ISO8601 formatter — allocating one per record is expensive (ICU init).
/// Internal so GetRecordProperties.swift can use it directly.
let _isoFormatter: ISO8601DateFormatter = ISO8601DateFormatter()

/// Print a success result. In JSON mode wraps in {"result": ...}.
public func printResult(_ value: Any) {
    switch currentOutputFormat {
    case .human:
        if let str = value as? String {
            print(str)
        } else if let dict = value as? [String: Any] {
            for (k, v) in dict.sorted(by: { $0.key < $1.key }) {
                print("\(k): \(v)")
            }
        } else if let arr = value as? [[String: Any]] {
            for (i, item) in arr.enumerated() {
                if i > 0 { print("") }
                for (k, v) in item.sorted(by: { $0.key < $1.key }) {
                    print("\(k): \(v)")
                }
            }
        } else if let arr = value as? [String] {
            for item in arr { print(item) }
        } else {
            print("\(value)")
        }
    case .json:
        let wrapper: [String: Any] = ["result": value]
        printJSON(wrapper)
    }
}

/// Print a list of results (always an array wrapper in JSON mode).
public func printResults(_ items: [[String: Any]]) {
    switch currentOutputFormat {
    case .human:
        for (i, item) in items.enumerated() {
            if i > 0 { print("") }
            for (k, v) in item.sorted(by: { $0.key < $1.key }) {
                print("\(k): \(v)")
            }
        }
    case .json:
        let wrapper: [String: Any] = ["result": items]
        printJSON(wrapper)
    }
}

/// Print an error and exit with the appropriate code.
public func printError(_ error: CliError) -> Never {
    switch currentOutputFormat {
    case .human:
        fputs("Error: \(error.description)\n", stderr)
    case .json:
        let wrapper: [String: Any] = ["error": error.description]
        if let data = try? JSONSerialization.data(withJSONObject: wrapper, options: [.prettyPrinted]),
           let str = String(data: data, encoding: .utf8) {
            fputs(str + "\n", stderr)
        }
    }
    exit(error.exitCode)
}

/// Print a generic string error and exit 1.
public func printErrorMessage(_ message: String) -> Never {
    printError(.commandFailed(message))
}

// MARK: - Internal helpers

public func printJSON(_ value: Any) {
    guard let data = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted, .sortedKeys]),
          let str = String(data: data, encoding: .utf8) else {
        fputs("{\"error\": \"Failed to serialize output\"}\n", stderr)
        exit(1)
    }
    print(str)
}

// MARK: - Record formatting helpers

public func formatRecord(_ record: DEVONthinkRecord) -> [String: Any] {
    let batch = batchFetchProperties(record)
    if !batch.isEmpty {
        return formatRecordFromBatch(batch, record)
    }
    return formatRecordIndividual(record)
}

/// Internal — also called by GetRecordProperties.swift to reuse the same batch dict.
func formatRecordFromBatch(_ b: [AnyHashable: Any], _ record: DEVONthinkRecord) -> [String: Any] {
    var dict: [String: Any] = [:]
    if let uuid = batchString(b, 0x55554944, "uuid")          { dict["uuid"] = uuid }
    if let name = batchString(b, 0x706e616d, "name")          { dict["name"] = name }
    let rid = batchInt(b, 0x49442020, "id")
    dict["id"] = rid != 0 ? rid : record.id()
    if let loc  = batchString(b, 0x44546c6f, "location")      { dict["location"] = loc }
    dict["recordType"] = batchRecordType(b, 0x44547270, "recordType")
    if let kind = batchString(b, 0x44546b69, "kind"),    !kind.isEmpty    { dict["kind"] = kind }
    if let cmt  = batchString(b, 0x4454636f, "comment"), !cmt.isEmpty     { dict["comment"] = cmt }
    let tags = batchStrings(b, 0x74616773, "tags")
    if !tags.isEmpty { dict["tags"] = tags }
    if let url = batchString(b, 0x7055524c, "URL"),      !url.isEmpty     { dict["url"] = url }
    if let path = batchString(b, 0x70707468, "path"),    !path.isEmpty    { dict["path"] = path }
    if let ref = batchString(b, 0x7255524c, "referenceURL"), !ref.isEmpty { dict["referenceURL"] = ref }
    dict["size"]   = batchInt(b, 0x7074737a, "size")
    dict["rating"] = batchInt(b, 0x44547274, "rating")
    dict["label"]  = batchInt(b, 0x44546c61, "label")
    let score = batchDouble(b, 0x4454736f, "score")
    if score > 0.0 { dict["score"] = score }
    if let created  = batchDate(b, 0x44546372, "creationDate")     { dict["creationDate"]     = _isoFormatter.string(from: created) }
    if let modified = batchDate(b, 0x44546d6f, "modificationDate") { dict["modificationDate"] = _isoFormatter.string(from: modified) }
    if let db = resolvedDatabase(record.database) { dict["database"] = db.name ?? "" }
    return dict
}

private func formatRecordIndividual(_ record: DEVONthinkRecord) -> [String: Any] {
    var dict: [String: Any] = [:]
    if let uuid = resolvedString(record.uuid) { dict["uuid"] = uuid }
    if let name = record.name { dict["name"] = name }
    dict["id"] = record.id()
    if let loc = resolvedString(record.location) { dict["location"] = loc }
    dict["recordType"] = recordTypeName(record.recordType)
    if let kind = resolvedString(record.kind), !kind.isEmpty { dict["kind"] = kind }
    if let comment = resolvedString(record.comment), !comment.isEmpty { dict["comment"] = comment }
    let tags = resolvedStrings(record.tags)
    if !tags.isEmpty { dict["tags"] = tags }
    if let url = resolvedString(record.url), !url.isEmpty { dict["url"] = url }
    if let path = resolvedString(record.path), !path.isEmpty { dict["path"] = path }
    if let refURL = resolvedString(record.referenceURL), !refURL.isEmpty { dict["referenceURL"] = refURL }
    dict["size"] = record.size
    dict["rating"] = record.rating
    dict["label"] = record.label
    let score = record.score
    if score > 0.0 { dict["score"] = score }
    if let created = resolvedDate(record.creationDate) {
        dict["creationDate"] = _isoFormatter.string(from: created)
    }
    if let modified = resolvedDate(record.modificationDate) {
        dict["modificationDate"] = _isoFormatter.string(from: modified)
    }
    if let db = resolvedDatabase(record.database) {
        dict["database"] = db.name ?? ""
    }
    return dict
}

public func formatDatabase(_ db: DEVONthinkDatabase) -> [String: Any] {
    var dict: [String: Any] = [:]
    if let name = db.name { dict["name"] = name }
    if let uuid = resolvedString(db.uuid) { dict["uuid"] = uuid }
    if let path = resolvedString(db.path) { dict["path"] = path }
    if let filename = resolvedString(db.filename) { dict["filename"] = filename }
    dict["id"] = db.id()
    dict["encrypted"] = db.encrypted
    dict["readOnly"] = db.readOnly
    dict["spotlightIndexing"] = db.spotlightIndexing
    dict["versioning"] = db.versioning
    dict["revisionProof"] = db.revisionProof
    if let comment = resolvedString(db.comment), !comment.isEmpty { dict["comment"] = comment }
    return dict
}

public func recordTypeName(_ type: DEVONthinkDataType) -> String {
    switch type {
    case DEVONthinkDataTypeBookmark:      return "bookmark"
    case DEVONthinkDataTypeFormattedNote: return "formatted note"
    case DEVONthinkDataTypeGroup:         return "group"
    case DEVONthinkDataTypeSmartGroup:    return "smart group"
    case DEVONthinkDataTypeFeed:          return "feed"
    case DEVONthinkDataTypeHTML:          return "html"
    case DEVONthinkDataTypeMarkdown:      return "markdown"
    case DEVONthinkDataTypeMultimedia:    return "multimedia"
    case DEVONthinkDataTypePDFDocument:   return "pdf"
    case DEVONthinkDataTypePicture:       return "picture"
    case DEVONthinkDataTypeRTF:           return "rtf"
    case DEVONthinkDataTypeRTFD:          return "rtfd"
    case DEVONthinkDataTypeSheet:         return "sheet"
    case DEVONthinkDataTypeTxt:           return "text"
    case DEVONthinkDataTypeUnknown:       return "unknown"
    case DEVONthinkDataTypeWebarchive:    return "web archive"
    case DEVONthinkDataTypeXML:           return "xml"
    default:                              return "other"
    }
}

// MARK: - List formatter (12 fields — matches TypeScript search output)

/// Slim record formatter for list commands (search, list-group-content, get-selected-records).
/// Fetches only the 12 fields the TypeScript implementation returns, reducing Apple Event
/// round-trips from ~18 to ~12 per record (and to 1 when batch fetch is available).
public func formatRecordSummary(_ record: DEVONthinkRecord) -> [String: Any] {
    // Attempt single-AE batch fetch; fall back to individual accessors if it fails.
    let batch = batchFetchProperties(record)
    if !batch.isEmpty {
        return formatRecordSummaryFromBatch(batch, record)
    }
    return formatRecordSummaryIndividual(record)
}

private func formatRecordSummaryFromBatch(_ b: [AnyHashable: Any], _ record: DEVONthinkRecord) -> [String: Any] {
    var dict: [String: Any] = [:]
    if let uuid = batchString(b, 0x55554944, "uuid")     { dict["uuid"] = uuid }
    if let name = batchString(b, 0x706e616d, "name")     { dict["name"] = name }
    let rid = batchInt(b, 0x49442020, "id")
    dict["id"] = rid != 0 ? rid : record.id()
    if let path = batchString(b, 0x70707468, "path")     { dict["path"] = path }
    if let loc  = batchString(b, 0x44546c6f, "location") { dict["location"] = loc }
    dict["recordType"] = batchRecordType(b, 0x44547270, "recordType")
    if let kind = batchString(b, 0x44546b69, "kind")     { dict["kind"] = kind }
    if let created  = batchDate(b, 0x44546372, "creationDate")     { dict["creationDate"]     = _isoFormatter.string(from: created) }
    if let modified = batchDate(b, 0x44546d6f, "modificationDate") { dict["modificationDate"] = _isoFormatter.string(from: modified) }
    dict["tags"] = batchStrings(b, 0x74616773, "tags")
    dict["size"] = batchInt(b, 0x7074737a, "size")
    let score = batchDouble(b, 0x4454736f, "score")
    if score > 0.0 { dict["score"] = score }
    return dict
}

private func formatRecordSummaryIndividual(_ record: DEVONthinkRecord) -> [String: Any] {
    var dict: [String: Any] = [:]
    if let uuid = resolvedString(record.uuid) { dict["uuid"] = uuid }
    if let name = record.name { dict["name"] = name }
    dict["id"] = record.id()
    if let path = resolvedString(record.path) { dict["path"] = path }
    if let loc = resolvedString(record.location) { dict["location"] = loc }
    dict["recordType"] = recordTypeName(record.recordType)
    if let kind = resolvedString(record.kind) { dict["kind"] = kind }
    if let created = resolvedDate(record.creationDate) {
        dict["creationDate"] = _isoFormatter.string(from: created)
    }
    if let modified = resolvedDate(record.modificationDate) {
        dict["modificationDate"] = _isoFormatter.string(from: modified)
    }
    let tags = resolvedStrings(record.tags)
    dict["tags"] = tags
    dict["size"] = record.size
    let score = record.score
    if score > 0.0 { dict["score"] = score }
    return dict
}
