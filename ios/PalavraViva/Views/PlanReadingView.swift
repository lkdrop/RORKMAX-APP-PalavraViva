import SwiftUI

struct PlanReadingView: View {
    let plan: ReadingPlan
    let task: PlanTask
    let dayNumber: Int
    let totalTasks: Int
    let taskIndex: Int

    @State private var audioService = AudioService()
    @State private var planProgress = PlanProgressManager.shared
    @Environment(\.dismiss) private var dismiss

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if task.type == .devotional {
                        devotionalContent
                    } else {
                        scriptureContent
                    }

                    Spacer().frame(height: 80)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }

            bottomBar
        }
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(task.type == .devotional ? "Devocional" : task.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {} label: {
                        Label("Compartilhar", systemImage: "square.and.arrow.up")
                    }
                    Button {} label: {
                        Label("Salvar", systemImage: "bookmark")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.white)
                }
            }
        }
        .onDisappear {
            audioService.stop()
        }
    }

    private var devotionalContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(devotionalTitle)
                .font(.title2.bold())
                .foregroundStyle(.white)

            ForEach(paragraphs, id: \.self) { paragraph in
                if paragraph.contains("**") {
                    formattedText(paragraph)
                } else {
                    Text(paragraph)
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineSpacing(8)
                }
            }

            Button {
                audioService.speak(task.content)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: audioService.isSpeakingText(task.content) ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(audioService.isSpeakingText(task.content) ? "Pausar Narração" : "Ouvir Devocional")
                            .font(.subheadline.bold())
                        Text("Narração em português")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .foregroundStyle(.white)
                .padding(14)
                .background(Color(red: 0.14, green: 0.14, blue: 0.16), in: RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 8)
        }
    }

    private var scriptureContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(task.title)
                .font(.title2.bold())
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: "book.fill")
                    .font(.title3)
                    .foregroundStyle(accentRed)

                Text("Leia a passagem bíblica abaixo e medite sobre as palavras.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineSpacing(6)

                Text(task.content)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 8)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private var bottomBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(plan.title)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
                Text("Dia \(dayNumber) • \(taskIndex) de \(totalTasks)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                planProgress.completeTask(planId: plan.id, taskId: task.id)
                dismiss()
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
    }

    private var devotionalTitle: String {
        let titles: [String: [String]] = [
            "amor": ["O Amor Eterno", "Amar Como Cristo", "Amor que Cobre", "Amor Sacrificial", "O Maior Mandamento", "Amor Incondicional", "Amor em Ação"],
            "cura": ["Cura que Restaura", "Pelas Suas Feridas", "O Médico da Alma", "Restauração Plena"],
            "ansiedade": ["Entregando o Peso", "Paz que Guarda", "Vivendo o Hoje", "Confiança Plena", "Mente Protegida"],
            "raiva": ["Processando a Ira", "Ouvir com Sabedoria", "Liberdade do Perdão"],
            "depressao": ["Você Não Está Só", "Deus Está Perto", "Luz na Escuridão", "Esperança Renovada"],
        ]
        let key = plan.category.rawValue.lowercased()
            .replacingOccurrences(of: "ã", with: "a")
            .replacingOccurrences(of: "ç", with: "c")
            .replacingOccurrences(of: "ê", with: "e")
        let list = titles[key] ?? ["Reflexão do Dia"]
        return list[(dayNumber - 1) % list.count]
    }

    private var paragraphs: [String] {
        task.content.components(separatedBy: "\n\n").filter { !$0.isEmpty }
    }

    private func formattedText(_ text: String) -> some View {
        var result = AttributedString()
        let parts = text.components(separatedBy: "**")
        for (index, part) in parts.enumerated() {
            var attr = AttributedString(part)
            if index % 2 == 1 {
                attr.font = .system(.body, design: .serif).bold()
            } else {
                attr.font = .system(.body, design: .serif)
            }
            result.append(attr)
        }
        return Text(result)
            .foregroundStyle(.white.opacity(0.9))
            .lineSpacing(8)
    }
}
