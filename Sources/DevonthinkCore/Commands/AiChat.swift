import ArgumentParser
import Foundation

/// Send a chat message to DEVONthink AI.
struct AiChat: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ai-chat",
        abstract: "Send a message to the DEVONthink AI chat engine."
    )

    @Argument(help: "The message to send.")
    var message: String

    @Option(name: .long, parsing: .upToNextOption, help: "UUID or identifier of context record(s). Can specify multiple.")
    var record: [String] = []

    @Option(name: .long, help: "AI model to use.")
    var model: String?

    @Option(name: .long, help: "System role / persona for the chat.")
    var role: String?

    @Option(name: .long, help: "AI engine: chatgpt, claude, gemini, mistral, apple-intelligence, perplexity, openrouter, openai-compatible, lmstudio, ollama, remote-ollama. Defaults to DEVONthink's current chat engine.")
    var engine: String?

    @Option(name: .long, help: "Temperature (0.0-2.0, default 0.7).")
    var temperature: Double = 0.7

    @Option(name: .long, help: "Response format: text (default), json, html.")
    var format: String = "text"

    func run() throws {
        let app = try requireApp()

        // Resolve context records
        var contextRecords: [DEVONthinkRecord] = []
        if !record.isEmpty {
            let resolver = RecordResolver(app: app)
            contextRecords = try record.map { try resolver.resolveRequired($0) }
        }

        let engineType = resolveEngine(engine, app: app)
        let modelName = resolveModel(model, explicitEngine: engine, app: app)

        // For single record, pass directly; for multiple, pass first and note limitation
        let contextRecord: DEVONthinkRecord? = contextRecords.first
        let mode: String? = contextRecord != nil ? "context" : nil

        let response = app.getChatResponse(
            forMessage: message,
            record: contextRecord,
            mode: mode,
            image: nil,
            url: nil,
            model: modelName,
            role: role,
            engine: engineType,
            temperature: temperature,
            thinking: true,
            toolCalls: true,
            usage: DEVONthinkChatUsageAuto,
            as: format == "json" ? "JSON" : (format == "html" ? "HTML" : "text")
        )

        if response == nil {
            throw CliError.operationFailed("Chat returned no result using \(describeEngine(engineType))\(modelName.map { " / \($0)" } ?? ""). Verify DEVONthink AI is enabled and the selected engine/model is available.")
        }

        if let text = response as? String {
            printResult(text)
        } else if let dict = response as? [String: Any] {
            printResult(dict)
        } else {
            printResult("\(response as Any)")
        }
    }

    private func parseEngine(_ value: String) -> DEVONthinkChatEngine {
        let v = value.lowercased()
        switch v {
        case "chatgpt", "gpt":                          return DEVONthinkChatEngineChatGPT
        case "claude":                                   return DEVONthinkChatEngineClaude
        case "gemini":                                   return DEVONthinkChatEngineGemini
        case "mistral":                                  return DEVONthinkChatEngineMistral
        case "apple-intelligence", "apple":              return DEVONthinkChatEngineAppleIntelligence
        case "perplexity":                               return DEVONthinkChatEnginePerplexity
        case "openrouter":                               return DEVONthinkChatEngineOpenRouter
        case "openai-compatible", "openai":              return DEVONthinkChatEngineOpenAICompatible
        case "lmstudio", "lm-studio":                    return DEVONthinkChatEngineLMStudio
        case "ollama":                                   return DEVONthinkChatEngineOllama
        case "remote-ollama", "remote_ollama":          return DEVONthinkChatEngineRemoteOllama
        default:                                         return DEVONthinkChatEngineChatGPT
        }
    }

    private func resolveEngine(_ explicitValue: String?, app: DEVONthinkApplication) -> DEVONthinkChatEngine {
        if let explicitValue, !explicitValue.isEmpty {
            return parseEngine(explicitValue)
        }

        guard let descriptor = resolvedAny(app.currentChatEngine) as? NSAppleEventDescriptor else {
            return DEVONthinkChatEngineChatGPT
        }

        switch descriptor.enumCodeValue {
        case DEVONthinkChatEngineAppleIntelligence.rawValue: return DEVONthinkChatEngineAppleIntelligence
        case DEVONthinkChatEngineChatGPT.rawValue:           return DEVONthinkChatEngineChatGPT
        case DEVONthinkChatEngineClaude.rawValue:            return DEVONthinkChatEngineClaude
        case DEVONthinkChatEngineGemini.rawValue:            return DEVONthinkChatEngineGemini
        case DEVONthinkChatEngineMistral.rawValue:           return DEVONthinkChatEngineMistral
        case DEVONthinkChatEnginePerplexity.rawValue:        return DEVONthinkChatEnginePerplexity
        case DEVONthinkChatEngineOpenRouter.rawValue:        return DEVONthinkChatEngineOpenRouter
        case DEVONthinkChatEngineOpenAICompatible.rawValue:  return DEVONthinkChatEngineOpenAICompatible
        case DEVONthinkChatEngineLMStudio.rawValue:          return DEVONthinkChatEngineLMStudio
        case DEVONthinkChatEngineOllama.rawValue:            return DEVONthinkChatEngineOllama
        case DEVONthinkChatEngineRemoteOllama.rawValue:      return DEVONthinkChatEngineRemoteOllama
        default:                                             return DEVONthinkChatEngineChatGPT
        }
    }

    private func resolveModel(_ explicitValue: String?, explicitEngine: String?, app: DEVONthinkApplication) -> String? {
        if let explicitValue, !explicitValue.isEmpty {
            return explicitValue
        }

        guard explicitEngine == nil else { return nil }
        return resolvedString(app.currentChatModel)
    }

    private func describeEngine(_ engine: DEVONthinkChatEngine) -> String {
        switch engine {
        case DEVONthinkChatEngineAppleIntelligence: return "apple-intelligence"
        case DEVONthinkChatEngineChatGPT:           return "chatgpt"
        case DEVONthinkChatEngineClaude:            return "claude"
        case DEVONthinkChatEngineGemini:            return "gemini"
        case DEVONthinkChatEngineMistral:           return "mistral"
        case DEVONthinkChatEnginePerplexity:        return "perplexity"
        case DEVONthinkChatEngineOpenRouter:        return "openrouter"
        case DEVONthinkChatEngineOpenAICompatible:  return "openai-compatible"
        case DEVONthinkChatEngineLMStudio:          return "lmstudio"
        case DEVONthinkChatEngineOllama:            return "ollama"
        case DEVONthinkChatEngineRemoteOllama:      return "remote-ollama"
        default:                                    return "chatgpt"
        }
    }
}
