import ArgumentParser
import Foundation

/// Root command for the DEVONthink CLI.
/// Provides `dt` and `devonthink` binaries with identical functionality.
public struct DTCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "dt",
        abstract: "DEVONthink CLI — interact with DEVONthink 4 from the terminal.",
        discussion: """
        All commands communicate with DEVONthink via ScriptingBridge.
        DEVONthink must be running, except for `is-running`.

        Use --json for machine-readable output on any command.
        Use --help on any subcommand for detailed usage.
        """,
        version: "1.0.0",
        subcommands: [
            // Application state
            IsRunning.self,

            // Database
            CurrentDatabase.self,
            OpenDatabases.self,

            // Record read
            GetRecordByIdentifier.self,
            GetRecordProperties.self,
            GetRecordContent.self,
            GetSelectedRecords.self,
            ListGroupContent.self,
            LookupRecord.self,
            Search.self,

            // Record write
            CreateRecord.self,
            CreateFromUrl.self,
            UpdateRecordContent.self,
            SetRecordProperties.self,
            RenameRecord.self,
            MoveRecord.self,
            ReplicateRecord.self,
            DuplicateRecord.self,
            DeleteRecord.self,
            ConvertRecord.self,
            AddTags.self,
            RemoveTags.self,
            Classify.self,
            Compare.self,

            // AI
            AiSummarize.self,
            AiChat.self,
            AiSuggestTags.self,
        ],
        defaultSubcommand: nil
    )

    @Flag(name: .long, help: "Output results as JSON.")
    public var json: Bool = false

    public init() {}

    public func validate() throws {
        // Set global output format before subcommand runs
        currentOutputFormat = json ? .json : .human
    }

    public func run() throws {
        // No default subcommand — print help
        print(DTCommand.helpMessage())
    }
}
