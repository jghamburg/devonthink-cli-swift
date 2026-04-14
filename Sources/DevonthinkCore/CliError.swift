import Foundation

/// Typed errors for the devonthink CLI with UNIX exit codes.
public enum CliError: Error, CustomStringConvertible {
    case devonthinkNotRunning
    case recordNotFound(String)
    case databaseNotFound(String)
    case noSelection
    case crossDatabaseReplicate
    case groupRequired(String)
    case invalidArgument(String)
    case operationFailed(String)
    case commandFailed(String)

    public var description: String {
        switch self {
        case .devonthinkNotRunning:
            return "DEVONthink is not running. Please launch it first."
        case .recordNotFound(let id):
            return "Record not found: \(id)"
        case .databaseNotFound(let id):
            return "Database not found: \(id)"
        case .noSelection:
            return "No record selected in DEVONthink and no identifier provided."
        case .crossDatabaseReplicate:
            return "Replication requires source and destination to be in the same database."
        case .groupRequired(let context):
            return "A group record is required for this operation: \(context)"
        case .invalidArgument(let msg):
            return "Invalid argument: \(msg)"
        case .operationFailed(let msg):
            return "Operation failed: \(msg)"
        case .commandFailed(let msg):
            return msg
        }
    }

    /// UNIX exit code for this error.
    public var exitCode: Int32 {
        switch self {
        case .devonthinkNotRunning: return 1
        case .recordNotFound:      return 2
        case .databaseNotFound:    return 3
        case .noSelection:         return 4
        case .crossDatabaseReplicate: return 5
        case .groupRequired:       return 6
        case .invalidArgument:     return 7
        case .operationFailed:     return 8
        case .commandFailed:       return 1
        }
    }
}
