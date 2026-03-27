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

    private let topics: [(name: String, color: Color, imageURL: String)] = [
        ("Amor", Color(red: 0.85, green: 0.55, blue: 0.4), "https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=400&q=80"),
        ("Ansiedade", Color(red: 0.9, green: 0.2, blue: 0.5), "https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=400&q=80"),
        ("Raiva", Color(red: 0.7, green: 0.35, blue: 0.3), "https://images.unsplash.com/photo-1534088568595-a066f410bcda?w=400&q=80"),
        ("Esperança", Color(red: 0.55, green: 0.55, blue: 0.4), "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=400&q=80"),
        ("Depressão", Color(red: 0.45, green: 0.35, blue: 0.35), "https://images.unsplash.com/photo-1499346030926-9a72daac6c63?w=400&q=80"),
        ("Paz", Color(red: 0.4, green: 0.65, blue: 0.7), "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=400&q=80"),
        ("Medo", Color(red: 0.6, green: 0.4, blue: 0.3), "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&q=80"),
        ("Estresse", Color(red: 0.3, green: 0.55, blue: 0.5), "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80"),
        ("Paciência", Color(red: 0.5, green: 0.55, blue: 0.45), "https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=400&q=80"),
        ("Tentação", Color(red: 0.5, green: 0.35, blue: 0.4), "https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5?w=400&q=80"),
        ("Perdão", Color(red: 0.6, green: 0.5, blue: 0.7), "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400&q=80"),
        ("Gratidão", Color(red: 0.65, green: 0.6, blue: 0.35), "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=400&q=80"),
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
                    Color(red: 0.15, green: 0.13, blue: 0.12)
                        .frame(height: 100)
                        .overlay {
                            AsyncImage(url: URL(string: topic.imageURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .transition(.opacity.animation(.easeOut(duration: 0.3)))
                                }
                            }
                            .allowsHitTesting(false)
                        }
                        .overlay {
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.55)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .allowsHitTesting(false)
                        }
                        .clipShape(.rect(cornerRadius: 14))
                        .overlay(alignment: .bottomLeading) {
                            Text(topic.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.4), radius: 4, y: 2)
                                .padding(14)
                        }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
