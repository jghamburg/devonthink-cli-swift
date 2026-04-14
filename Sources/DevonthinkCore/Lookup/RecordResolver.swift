import Foundation

/// Resolves a record identifier string to a DEVONthinkRecord using the
/// priority chain: x-devonthink-item URL → UUID → numeric ID → path → name → current selection.
public struct RecordResolver {

    private let app: DEVONthinkApplication

    public init(app: DEVONthinkApplication) {
        self.app = app
    }

    /// Resolve an optional identifier to a record.
    /// If identifier is nil, falls back to the currently selected record.
    public func resolve(_ identifier: String?) throws -> DEVONthinkRecord {
        guard let id = identifier, !id.isEmpty else {
            return try currentSelection()
        }

        // x-devonthink-item:// reference URL (includes email message IDs)
        if id.hasPrefix("x-devonthink-item://") {
            let stripped = String(id.dropFirst("x-devonthink-item://".count))

            // 1. If stripped portion is a UUID, look up directly
            if isUUID(stripped) {
                if let r = app.getRecordWithUuid(stripped.uppercased(), in: nil as AnyObject?) as? DEVONthinkRecord {
                    return r
                }
            }

            // 2. URL-decode and try UUID lookup again
            if let decoded = stripped.removingPercentEncoding, decoded != stripped, isUUID(decoded) {
                if let r = app.getRecordWithUuid(decoded.uppercased(), in: nil as AnyObject?) as? DEVONthinkRecord {
                    return r
                }
            }

            // 3. Fallback: lookupRecordsWithURL using the full reference URL
            if let records = app.lookupRecords(withURL: id, in: nil) as? [DEVONthinkRecord] {
                // Verify referenceURL matches
                if let match = records.first(where: { resolvedString($0.referenceURL) == id }) {
                    return match
                }
                if let first = records.first {
                    return first
                }
            }

            throw CliError.recordNotFound(id)
        }

        // UUID: 36-char format xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
        if isUUID(id) {
            if let r = app.getRecordWithUuid(id, in: nil as AnyObject?) as? DEVONthinkRecord {
                return r
            }
            throw CliError.recordNotFound(id)
        }

        // Numeric scripting ID
        if let numericId = Int(id) {
            if let r = app.getRecordWithId(numericId, in: nil as AnyObject?) as? DEVONthinkRecord {
                return r
            }
            throw CliError.recordNotFound(id)
        }

        // POSIX path (starts with /)
        if id.hasPrefix("/") {
            if let records = app.lookupRecords(withPath: id, in: nil) as? [DEVONthinkRecord],
               let r = records.first {
                return r
            }
            throw CliError.recordNotFound(id)
        }

        // Fallback: try as name via search
        if let records = app.search(id, comparison: DEVONthinkSearchComparisonNoCase, excludeSubgroups: false, in: nil) as? [DEVONthinkRecord] {
            let nameMatch = records.first { ($0.name ?? "") == id }
            if let r = nameMatch ?? records.first {
                return r
            }
        }

        throw CliError.recordNotFound(id)
    }

    /// Resolve a required identifier (non-nil).
    public func resolveRequired(_ identifier: String) throws -> DEVONthinkRecord {
        return try resolve(identifier)
    }

    /// Resolve a destination group from an identifier.
    public func resolveGroup(_ identifier: String) throws -> DEVONthinkParent {
        let record = try resolveRequired(identifier)
        guard let group = record as? DEVONthinkParent else {
            throw CliError.groupRequired(identifier)
        }
        return group
    }

    // MARK: - Private

    private func currentSelection() throws -> DEVONthinkRecord {
        guard let arr = app.selectedRecords() as? [DEVONthinkRecord],
              let first = arr.first else {
            throw CliError.noSelection
        }
        return first
    }

    private func isUUID(_ s: String) -> Bool {
        guard s.count == 36 else { return false }
        let dashes: Set<Int> = [8, 13, 18, 23]
        for (i, c) in s.enumerated() {
            if dashes.contains(i) {
                guard c == "-" else { return false }
            } else {
                guard c.isHexDigit else { return false }
            }
        }
        return true
    }
}

// MARK: - App access helper

/// Returns a connected DEVONthinkApplication instance, verifying it is running.
public func requireApp() throws -> DEVONthinkApplication {
    guard let app = DEVONthinkApplication(bundleIdentifier: "com.devon-technologies.think") else {
        throw CliError.commandFailed("Could not connect to DEVONthink via ScriptingBridge.")
    }
    guard app.isRunning else {
        throw CliError.devonthinkNotRunning
    }
    return app
}
