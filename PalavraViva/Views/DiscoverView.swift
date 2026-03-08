import SwiftUI

struct DiscoverView: View {
    @Bindable var viewModel: BibleViewModel
    @State private var navigateToReader: Bool = false

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private let quickLinks: [(icon: String, title: String)] = [
        ("checkmark.square", "Planos"),
        ("play.rectangle", "Vídeos"),
        ("building.columns", "Igrejas"),
        ("globe", "Parceiros"),
    ]

    private let topics: [(name: String, color: Color)] = [
        ("Amor", Color(red: 0.85, green: 0.55, blue: 0.4)),
        ("Ansiedade", Color(red: 0.9, green: 0.2, blue: 0.5)),
        ("Raiva", Color(red: 0.7, green: 0.35, blue: 0.3)),
        ("Esperança", Color(red: 0.55, green: 0.55, blue: 0.4)),
        ("Depressão", Color(red: 0.45, green: 0.35, blue: 0.35)),
        ("Paz", Color(red: 0.4, green: 0.65, blue: 0.7)),
        ("Medo", Color(red: 0.6, green: 0.4, blue: 0.3)),
        ("Estresse", Color(red: 0.3, green: 0.55, blue: 0.5)),
        ("Paciência", Color(red: 0.5, green: 0.55, blue: 0.45)),
        ("Tentação", Color(red: 0.5, green: 0.35, blue: 0.4)),
        ("Perdão", Color(red: 0.6, green: 0.5, blue: 0.7)),
        ("Gratidão", Color(red: 0.65, green: 0.6, blue: 0.35)),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    searchBar

                    quickLinksGrid

                    topicsGrid
                }
                .padding(.bottom, 32)
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
            .navigationDestination(isPresented: $navigateToReader) {
                ChapterReaderView(viewModel: viewModel)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.body)
                .foregroundStyle(.secondary)
            Text("Pesquisar")
                .font(.body)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var quickLinksGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            ForEach(quickLinks, id: \.title) { link in
                Button {} label: {
                    HStack(spacing: 10) {
                        Image(systemName: link.icon)
                            .font(.body)
                            .foregroundStyle(.white)
                        Text(link.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(16)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var topicsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            ForEach(topics, id: \.name) { topic in
                Button {
                    viewModel.searchQuery = topic.name
                    viewModel.performSearch()
                } label: {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [topic.color, topic.color.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 100)

                        Text(topic.name)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                            .padding(14)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
