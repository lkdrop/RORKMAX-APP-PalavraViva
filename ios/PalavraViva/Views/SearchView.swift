import SwiftUI

struct SearchView: View {
    @Bindable var viewModel: BibleViewModel

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.searchQuery.isEmpty && viewModel.searchResults.isEmpty {
                    emptyState
                } else if viewModel.isSearching {
                    VStack(spacing: 16) {
                        Spacer()
                        ProgressView()
                            .tint(accentRed)
                        Text("Buscando...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchQuery)
                } else {
                    resultsList
                }
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
            .navigationTitle("Pesquisar")
            .searchable(text: $viewModel.searchQuery, prompt: "Buscar versículos...")
            .onSubmit(of: .search) {
                viewModel.performSearch()
            }
            .onChange(of: viewModel.searchQuery) { _, newValue in
                if newValue.count >= 3 {
                    viewModel.performSearch()
                } else if newValue.isEmpty {
                    viewModel.searchResults = []
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(accentRed.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: "text.magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundStyle(accentRed)
            }

            VStack(spacing: 6) {
                Text("Pesquise na Bíblia")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("Encontre versículos por palavras-chave")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(["amor", "fé", "esperança", "paz", "luz", "graça", "perdão"], id: \.self) { suggestion in
                        Button {
                            viewModel.searchQuery = suggestion
                            viewModel.performSearch()
                        } label: {
                            Text(suggestion)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(accentRed)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(accentRed.opacity(0.1), in: Capsule())
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                HStack {
                    Text("\(viewModel.searchResults.count) resultado(s)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 20)

                ForEach(viewModel.searchResults) { verse in
                    SearchResultCard(verse: verse, viewModel: viewModel)
                }
            }
            .padding(.vertical, 12)
        }
    }
}

struct SearchResultCard: View {
    let verse: BibleVerse
    @Bindable var viewModel: BibleViewModel
    @State private var audioService = AudioService()

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private var bookName: String {
        viewModel.bookNameForVerse(verse)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(bookName) \(verse.chapterNumber):\(verse.verseNumber)")
                    .font(.caption.bold())
                    .foregroundStyle(accentRed)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(accentRed.opacity(0.1), in: Capsule())

                Spacer()

                Button {
                    audioService.speak(verse.text)
                } label: {
                    Image(systemName: audioService.isSpeakingText(verse.text) ? (audioService.isPaused ? "play.fill" : "pause.fill") : "speaker.wave.2")
                        .font(.subheadline)
                        .foregroundStyle(audioService.isSpeakingText(verse.text) ? accentRed : .secondary)
                        .contentTransition(.symbolEffect(.replace))
                }

                Button {
                    viewModel.toggleBookmark(verse: verse, bookName: bookName)
                } label: {
                    Image(systemName: viewModel.isBookmarked(verse) ? "bookmark.fill" : "bookmark")
                        .font(.subheadline)
                        .foregroundStyle(viewModel.isBookmarked(verse) ? accentRed : .secondary)
                        .contentTransition(.symbolEffect(.replace))
                }
            }

            Text(verse.text)
                .font(.system(.body, design: .serif))
                .lineSpacing(5)
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
    }
}
