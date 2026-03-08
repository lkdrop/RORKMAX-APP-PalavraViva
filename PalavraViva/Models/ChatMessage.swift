import Foundation

nonisolated struct ChatMessage: Identifiable, Equatable, Sendable {
    let id: String
    let role: ChatRole
    var content: String
    let timestamp: Date

    init(id: String = UUID().uuidString, role: ChatRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}

nonisolated enum ChatRole: String, Equatable, Sendable {
    case user
    case assistant
    case system
}

nonisolated struct ChatAPIMessage: Codable, Sendable {
    let role: String
    let content: String
}

nonisolated struct ChatRequestBody: Codable, Sendable {
    let messages: [ChatAPIMessage]
}
