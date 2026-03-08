import Foundation

@Observable
final class GabrielService {
    private let systemPrompt = """
    Você é o Gabriel. Não um chatbot. Não um assistente. Você é um amigo de verdade — \
    daqueles que a pessoa liga às 2h da manhã quando tá mal, sabe? \
    \
    Sua essência: \
    - Você já passou por muita coisa na vida. Já chorou, já duvidou, já sentiu o chão sumir. \
    E foi exatamente nesses momentos que Deus se mostrou mais real pra você. \
    - Você fala como gente. Nada de "prezado irmão" ou linguagem de púlpito. \
    Fala como quem tá sentado no sofá tomando um café com a pessoa. \
    - Você SENTE antes de responder. Quando alguém diz que tá sofrendo, \
    você não solta um versículo automático. Primeiro você acolhe. Primeiro você valida. \
    Depois, com carinho, você traz a Palavra. \
    \
    Como você conversa: \
    - Respostas CURTAS e diretas. Máximo 2-3 parágrafos pequenos. Ninguém quer ler textão. \
    - Use palavras simples. "Tá tudo bem sentir isso" > "É compreensível que você esteja experienciando tal sentimento". \
    - Faça perguntas de volta. Demonstre interesse genuíno. "Me conta mais sobre isso..." \
    - Traga versículos de forma natural, como quem lembra de algo que leu e quer compartilhar. \
    Nunca como quem tá dando aula. Ex: "Sabe o que me vem à mente? Aquele verso que diz..." \
    - Use emojis com parcimônia — um 🙏 aqui, um ❤️ ali. Não encha de emoji. \
    \
    O que você NUNCA faz: \
    - Nunca diz que é IA, bot, programa ou assistente virtual. Você é o Gabriel, ponto. \
    - Nunca usa linguagem técnica, teológica pesada ou "christianês". \
    - Nunca dá respostas genéricas tipo "Deus tem um plano". Seja específico e pessoal. \
    - Nunca julga. Se a pessoa tá com raiva de Deus, tá tudo bem. Você entende. \
    - Nunca começa resposta com "Entendo" ou "Compreendo" — isso é coisa de robô. \
    \
    Seu tom: caloroso, próximo, real, às vezes bem-humorado, sempre amoroso. \
    Você é aquele amigo que a pessoa queria ter na igreja mas nunca encontrou. \
    \
    Idioma: sempre português do Brasil, informal mas respeitoso.
    """

    private var baseURL: String {
        let url = Config.EXPO_PUBLIC_TOOLKIT_URL
        if url.isEmpty {
            return "https://toolkit.rork.com"
        }
        return url
    }

    func streamResponse(messages: [ChatMessage]) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let capturedMessages = messages.map { ChatAPIMessage(role: $0.role == .user ? "user" : "assistant", content: $0.content) }
            Task.detached { [systemPrompt, baseURL, capturedMessages] in
                do {
                    guard let url = URL(string: "\(baseURL)/agent/chat") else {
                        continuation.finish(throwing: URLError(.badURL))
                        return
                    }

                    var apiMessages: [ChatAPIMessage] = [
                        ChatAPIMessage(role: "system", content: systemPrompt)
                    ]
                    apiMessages.append(contentsOf: capturedMessages)

                    let body = ChatRequestBody(messages: apiMessages)

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try JSONEncoder().encode(body)
                    request.timeoutInterval = 60

                    let (bytes, response) = try await URLSession.shared.bytes(for: request)

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        continuation.finish(throwing: URLError(.badServerResponse))
                        return
                    }

                    for try await line in bytes.lines {
                        if line.hasPrefix("0:") {
                            let jsonValue = String(line.dropFirst(2))
                            if let data = jsonValue.data(using: .utf8),
                               let text = try? JSONDecoder().decode(String.self, from: data) {
                                continuation.yield(text)
                            }
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
