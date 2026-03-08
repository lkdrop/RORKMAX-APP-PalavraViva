import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: BibleViewModel
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @State private var subscriptionManager = SubscriptionManager.shared

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        Form {
            Section {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(accentRed)
                            .frame(width: 40, height: 40)
                        Image(systemName: "crown.fill")
                            .font(.body)
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Palavra Viva")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption2)
                                .foregroundStyle(.green)
                            Text("Gratuito")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }

            Section {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Tamanho da Fonte")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(Int(viewModel.fontSize))pt")
                            .font(.subheadline.bold())
                            .foregroundStyle(accentRed)
                            .monospacedDigit()
                    }

                    Slider(value: $viewModel.fontSize, in: 14...28, step: 1)
                        .tint(accentRed)
                        .onChange(of: viewModel.fontSize) { _, _ in
                            viewModel.saveFontSize()
                        }

                    Text("No princípio, criou Deus os céus e a terra.")
                        .font(.system(size: viewModel.fontSize, design: .serif))
                        .lineSpacing(viewModel.fontSize * 0.35)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            } header: {
                Label("Leitura", systemImage: "textformat.size")
            }

            Section {
                statsRow(icon: "flame.fill", color: .orange, title: "Sequência Atual", value: "\(viewModel.readingStreak.currentStreak) dias")
                statsRow(icon: "trophy.fill", color: .yellow, title: "Maior Sequência", value: "\(viewModel.readingStreak.longestStreak) dias")
                statsRow(icon: "book.closed.fill", color: accentRed, title: "Capítulos Lidos", value: "\(viewModel.readingProgress.chaptersRead)")
                statsRow(icon: "bookmark.fill", color: accentRed, title: "Marcadores", value: "\(viewModel.bookmarks.count)")
            } header: {
                Label("Estatísticas", systemImage: "chart.bar")
            }

            Section {
                HStack {
                    Text("Versão")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Tradução")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("ARA")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Label("Sobre", systemImage: "info.circle")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
        .navigationTitle("Ajustes")
        .tint(accentRed)

    }

    private func statsRow(icon: String, color: Color, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.12))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.caption.bold())
                    .foregroundStyle(color)
            }
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.white)
            Spacer()
            Text(value)
                .font(.body.bold())
                .foregroundStyle(color)
        }
    }
}
