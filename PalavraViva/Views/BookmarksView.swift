import SwiftUI

struct BookmarksView: View {
    @Bindable var viewModel: BibleViewModel

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        Group {
            if viewModel.bookmarks.isEmpty {
                emptyState
            } else {
                bookmarksList
            }
        }
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
        .navigationTitle("Marcadores")
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(accentRed.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: "bookmark")
                    .font(.system(size: 32))
                    .foregroundStyle(accentRed)
            }

            VStack(spacing: 6) {
                Text("Nenhum Marcador")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("Mantenha pressionado um versículo\npara salvá-lo aqui.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var bookmarksList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                HStack {
                    Text("\(viewModel.bookmarks.count) marcador(es)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                ForEach(viewModel.bookmarks) { bookmark in
                    BookmarkCard(bookmark: bookmark, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct BookmarkCard: View {
    let bookmark: Bookmark
    @Bindable var viewModel: BibleViewModel
    @State private var audioService = AudioService()

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "bookmark.fill")
                        .font(.caption2)
                        .foregroundStyle(accentRed)
                    Text(bookmark.reference)
                        .font(.caption.bold())
                        .foregroundStyle(accentRed)
                }

                Spacer()

                Text(bookmark.dateAdded, format: .dateTime.day().month(.abbreviated))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Text("\u{201C}\(bookmark.verse.text)\u{201D}")
                .font(.system(.body, design: .serif))
                .lineSpacing(5)
                .foregroundStyle(.white.opacity(0.9))

            HStack(spacing: 16) {
                Spacer()

                Button {
                    audioService.speak(bookmark.verse.text)
                } label: {
                    Image(systemName: audioService.isSpeakingText(bookmark.verse.text) ? (audioService.isPaused ? "play.fill" : "pause.fill") : "speaker.wave.2")
                        .font(.caption)
                        .foregroundStyle(audioService.isSpeakingText(bookmark.verse.text) ? accentRed : .secondary)
                        .contentTransition(.symbolEffect(.replace))
                }

                ShareLink(item: "\u{201C}\(bookmark.verse.text)\u{201D}\n— \(bookmark.reference)") {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button {
                    UIPasteboard.general.string = "\u{201C}\(bookmark.verse.text)\u{201D}\n— \(bookmark.reference)"
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button(role: .destructive) {
                    withAnimation(.snappy) {
                        viewModel.removeBookmark(bookmark)
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundStyle(.red.opacity(0.7))
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.14))
                .overlay(alignment: .leading) {
                    UnevenRoundedRectangle(topLeadingRadius: 14, bottomLeadingRadius: 14)
                        .fill(accentRed.opacity(0.5))
                        .frame(width: 3)
                }
        }
    }
}
