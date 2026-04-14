import Foundation
import ScriptingBridge

// MARK: - Apple Event FourCC constants for DEVONthinkRecord properties
// Confirmed from Sources/DevonthinkBridge/DEVONthink.m codeForPropertyNameData__ table.

private let kPropAll             : AEKeyword = 0x70414c4c  // 'pALL' — fetch all properties at once
private let kPropUUID            : AEKeyword = 0x55554944  // 'UUID'  → "uuid"
private let kPropName            : AEKeyword = 0x706e616d  // 'pnam'  → "name"
private let kPropId              : AEKeyword = 0x49442020  // 'ID  '  → "id"
private let kPropLocation        : AEKeyword = 0x44546c6f  // 'DTlo'  → "location"
private let kPropPath            : AEKeyword = 0x70707468  // 'ppth'  → "path"
private let kPropKind            : AEKeyword = 0x44546b69  // 'DTki'  → "kind"
private let kPropTags            : AEKeyword = 0x74616773  // 'tags'  → "tags"
private let kPropSize            : AEKeyword = 0x7074737a  // 'ptsz'  → "size"    (was 0x70747377 — fixed)
private let kPropScore           : AEKeyword = 0x4454736f  // 'DTso'  → "score"   (was 0x44546f73 — fixed)
private let kPropCreationDate    : AEKeyword = 0x44546372  // 'DTcr'  → "creationDate"
private let kPropModDate         : AEKeyword = 0x44546d6f  // 'DTmo'  → "modificationDate"
private let kPropRecordType      : AEKeyword = 0x44547270  // 'DTrp'  → "recordType" (was 0x44546d74 'DTmt' — fixed)
private let kPropComment         : AEKeyword = 0x4454636f  // 'DTco'  → "comment"
private let kPropURL             : AEKeyword = 0x7055524c  // 'pURL'  → "URL"
private let kPropReferenceURL    : AEKeyword = 0x7255524c  // 'rURL'  → "referenceURL"
private let kPropRating          : AEKeyword = 0x44547274  // 'DTrt'  → "rating"
private let kPropLabel           : AEKeyword = 0x44546c61  // 'DTla'  → "label"
// Properties used by get-record-properties (confirmed from DEVONthink.m codeForPropertyNameData__)
let kPropAdditionDate       : AEKeyword = 0x44546164  // 'DTad'  → "additionDate"
let kPropFlag               : AEKeyword = 0x44547374  // 'DTst'  → "flag"
let kPropUnread             : AEKeyword = 0x44547572  // 'DTur'  → "unread"
let kPropLocking            : AEKeyword = 0x44546c63  // 'DTlc'  → "locking"
let kPropWordCount          : AEKeyword = 0x44547763  // 'DTwc'  → "wordCount"
let kPropCharacterCount     : AEKeyword = 0x44546363  // 'DTcc'  → "characterCount"
let kPropExcludeFromChat    : AEKeyword = 0x44547869  // 'DTxi'  → "excludeFromChat"
let kPropExcludeFromClassify: AEKeyword = 0x44547863  // 'DTxc'  → "excludeFromClassification"
let kPropExcludeFromSearch  : AEKeyword = 0x44547873  // 'DTxs'  → "excludeFromSearch"
let kPropExcludeFromSeeAlso : AEKeyword = 0x44547861  // 'DTxa'  → "excludeFromSeeAlso"
let kPropExcludeFromTagging : AEKeyword = 0x44547874  // 'DTxt'  → "excludeFromTagging"
let kPropExcludeFromWiki    : AEKeyword = 0x44547877  // 'DTxw'  → "excludeFromWikiLinking"
let kPropPlainText          : AEKeyword = 0x4454706c  // 'DTpl'  → "plainText"

// MARK: - Batch fetcher

/// Fetches all properties of a DEVONthinkRecord in a single Apple Event using
/// the 'pALL' property code.
///
/// ScriptingBridge may return the AE record as either:
///   - [NSNumber: Any]  keyed by FourCC (AEKeyword)
///   - [String: Any]    keyed by AppleScript property name
/// Both are stored together in a [AnyHashable: Any] dict so callers don't need
/// to care which key type the runtime chose.
///
/// Returns empty dict on failure — callers fall back to individual property accessors.
/// Cost when successful: 1 Apple Event per record (vs ~12–18 individual gets).
func batchFetchProperties(_ record: DEVONthinkRecord) -> [AnyHashable: Any] {
    let specifier = (record as SBObject).property(withCode: kPropAll)
    guard let raw = specifier.get() else { return [:] }

    if let dict = raw as? [AnyHashable: Any], !dict.isEmpty {
        return dict
    }
    // NSDictionary with mixed key types comes through as [NSObject: AnyObject]
    if let dict = raw as? NSDictionary as? [AnyHashable: Any], !dict.isEmpty {
        return dict
    }
    return [:]
}

// MARK: - Dual-key lookup helpers
// Each helper tries the FourCC (NSNumber) key first, then the string name key.
// This handles both key-type variants that ScriptingBridge may return.

private func lookup(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> Any? {
    return dict[NSNumber(value: fourcc)] ?? dict[name]
}

func batchString(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> String? {
    guard let v = lookup(dict, fourcc, name) else { return nil }
    if let s = v as? String { return s }
    if let a = v as? NSAttributedString { return a.string }
    if let sb = v as? SBObject { return resolvedString(sb.get()) }
    return nil
}

func batchStrings(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> [String] {
    guard let v = lookup(dict, fourcc, name) else { return [] }
    if let arr = v as? [String] { return arr }
    if let arr = v as? NSArray { return arr.compactMap { $0 as? String } }
    if let sb = v as? SBObject { return resolvedStrings(sb.get()) }
    return []
}

func batchDate(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> Date? {
    guard let v = lookup(dict, fourcc, name) else { return nil }
    if let d = v as? Date { return d }
    if let sb = v as? SBObject { return resolvedDate(sb.get()) }
    return nil
}

func batchInt(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> Int {
    guard let v = lookup(dict, fourcc, name) else { return 0 }
    if let n = v as? Int { return n }
    if let n = v as? NSNumber { return n.intValue }
    return 0
}

func batchDouble(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> Double {
    guard let v = lookup(dict, fourcc, name) else { return 0.0 }
    if let n = v as? Double { return n }
    if let n = v as? NSNumber { return n.doubleValue }
    return 0.0
}

func batchBool(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> Bool {
    guard let v = lookup(dict, fourcc, name) else { return false }
    if let b = v as? Bool { return b }
    if let n = v as? NSNumber { return n.boolValue }
    return false
}

func batchRecordType(_ dict: [AnyHashable: Any], _ fourcc: AEKeyword, _ name: String) -> String {
    guard let v = lookup(dict, fourcc, name) else { return "other" }
    if let s = v as? String { return s }
    if let n = v as? NSNumber {
        return recordTypeName(DEVONthinkDataType(rawValue: UInt32(n.intValue)))
    }
    return "other"
}
