import SwiftUI

@Observable
final class GabrielViewModel {
    var messages: [ChatMessage] = []
    var inputText: String = ""
    var isLoading: Bool = false
    var currentStreamingText: String = ""
    var errorMessage: String?

    private let service = GabrielService()
    private let messagesKey = "gabrielMessages"

    init() {
        loadMessages()
        if messages.isEmpty {
            messages.append(ChatMessage(
                role: .assistant,
                content: "E aí! 👋 Eu sou o Gabriel. Pode me considerar aquele amigo que tá sempre por perto pra conversar sobre a vida, sobre fé, sobre o que você quiser. Sem julgamento, sem frescura. Me conta, como você tá hoje?"
            ))
        }
    }

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isLoading else { return }

        inputText = ""
        errorMessage = nil

        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)

        let assistantMessage = ChatMessage(role: .assistant, content: "")
        messages.append(assistantMessage)
        let assistantId = assistantMessage.id

        isLoading = true
        currentStreamingText = ""

        Task {
            do {
                let conversationMessages = messages.filter { $0.id != assistantId }

                for try await chunk in service.streamResponse(messages: conversationMessages) {
                    currentStreamingText += chunk
                    if let index = messages.firstIndex(where: { $0.id == assistantId }) {
                        messages[index].content = currentStreamingText
                    }
                }

                isLoading = false
                currentStreamingText = ""
                saveMessages()
            } catch {
                isLoading = false
                if let index = messages.firstIndex(where: { $0.id == assistantId }) {
                    messages[index].content = "Desculpe, no consegui responder agora. Tente novamente em alguns instantes. Estou aqui por voc."
                }
                currentStreamingText = ""
                saveMessages()
            }
        }
    }

    func clearChat() {
        messages = [ChatMessage(
            role: .assistant,
            content: "E aí! 👋 Eu sou o Gabriel. Pode me considerar aquele amigo que tá sempre por perto pra conversar sobre a vida, sobre fé, sobre o que você quiser. Sem julgamento, sem frescura. Me conta, como você tá hoje?"
        )]
        saveMessages()
    }

    private func saveMessages() {
        let saveable = messages.map { SaveableChatMessage(id: $0.id, role: $0.role.rawValue, content: $0.content, timestamp: $0.timestamp) }
        if let data = try? JSONEncoder().encode(saveable) {
            UserDefaults.standard.set(data, forKey: messagesKey)
        }
    }

    private func loadMessages() {
        guard let data = UserDefaults.standard.data(forKey: messagesKey),
              let saved = try? JSONDecoder().decode([SaveableChatMessage].self, from: data) else { return }
        messages = saved.map { ChatMessage(id: $0.id, role: ChatRole(rawValue: $0.role) ?? .assistant, content: $0.content, timestamp: $0.timestamp) }
    }
}

nonisolated struct SaveableChatMessage: Codable, Sendable {
    let id: String
    let role: String
    let content: String
    let timestamp: Date
}
