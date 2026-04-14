import ArgumentParser
import Foundation

/// Check whether DEVONthink is currently running.
struct IsRunning: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "is-running",
        abstract: "Check whether DEVONthink is currently running."
    )

    func run() throws {
        let running: Bool
        if let app = DEVONthinkApplication(bundleIdentifier: "com.devon-technologies.think") {
            running = app.isRunning
        } else {
            running = false
        }
        printResult(running)
    }
}
