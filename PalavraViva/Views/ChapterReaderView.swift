import SwiftUI
import UIKit

struct ChapterReaderView: View {
    @Bindable var viewModel: BibleViewModel
    @State private var hasMarkedRead: Bool = false
    @State private var audioService = AudioService()
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var showVersionPicker: Bool = false

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        Group {
            if viewModel.isLoadingChapter {
                loadingView
            } else if let error = viewModel.chapterLoadError {
                errorView(error)
            } else if let chapter = viewModel.currentChapter, let book = viewModel.selectedBook {
                chapterContent(chapter: chapter, book: book)
            } else {
                ContentUnavailableView(
                    "Selecione um Capítulo",
                    systemImage: "book.closed",
                    description: Text("Escolha um livro e capítulo para começar a ler.")
                )
            }
        }
        .task {
            await viewModel.loadCurrentChapter()
        }
        .onChange(of: viewModel.selectedChapterNumber) { _, _ in
            hasMarkedRead = false
            audioService.stop()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .tint(accentRed)
                .scaleEffect(1.2)
            Text("Carregando capítulo...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
    }

    private func errorView(_ error: String) -> some View {
        ContentUnavailableView {
            Label("Erro ao Carregar", systemImage: "wifi.exclamationmark")
        } description: {
            Text(error)
        } actions: {
            Button {
                Task { await viewModel.loadCurrentChapter() }
            } label: {
                Text("Tentar Novamente")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(accentRed, in: Capsule())
            }
        }
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
    }

    private func chapterContent(chapter: BibleChapter, book: BibleBook) -> some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 28) {
                        ForEach(groupVersesBySection(chapter.verses, bookId: book.id)) { section in
                            VStack(alignment: .leading, spacing: 16) {
                                if let heading = section.heading {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(heading)
                                            .font(.title2.bold())
                                            .foregroundStyle(.white)
                                        if let subheading = section.subheading {
                                            Text(subheading)
                                                .font(.subheadline)
                                                .italic()
                                                .foregroundStyle(accentRed.opacity(0.8))
                                        }
                                    }
                                    .padding(.top, 8)
                                }

                                ForEach(section.verses) { verse in
                                    VerseRow(
                                        verse: verse,
                                        bookName: book.name,
                                        fontSize: viewModel.fontSize,
                                        isBookmarked: viewModel.isBookmarked(verse),
                                        isPlaying: audioService.isSpeakingText(verse.text),
                                        isPaused: audioService.isPaused && audioService.isSpeakingText(verse.text),
                                        onToggleBookmark: {
                                            viewModel.toggleBookmark(verse: verse, bookName: book.name)
                                        },
                                        onSpeak: {
                                            audioService.speak(verse.text)
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 28)

                    if !hasMarkedRead {
                        markReadButton
                    }

                    Spacer().frame(height: audioService.isSpeaking ? 100 : 20)
                }
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))

            VStack(spacing: 0) {
                if audioService.isSpeaking {
                    floatingAudioPlayer
                }
                chapterNavigation
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 8) {
                    Text("\(book.name) \(chapter.number)")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.18, green: 0.18, blue: 0.2), in: Capsule())

                    Button {
                        showVersionPicker = true
                    } label: {
                        Text("ARA")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.18, green: 0.18, blue: 0.2), in: Capsule())
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        if let chapter = viewModel.currentChapter {
                            let allText = chapter.verses.map { $0.text }.joined(separator: " ")
                            audioService.speak(allText)
                        }
                    } label: {
                        Image(systemName: audioService.isSpeaking ? "pause.fill" : "speaker.wave.2")
                            .foregroundStyle(audioService.isSpeaking ? accentRed : .white)
                            .contentTransition(.symbolEffect(.replace))
                    }

                    Button {} label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                    }

                    Button {} label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.07, green: 0.07, blue: 0.08), for: .navigationBar)
    }

    private var floatingAudioPlayer: some View {
        HStack(spacing: 14) {
            Button {
                audioService.speak(audioService.currentText)
            } label: {
                Image(systemName: audioService.isPaused ? "play.circle.fill" : "pause.circle.fill")
                    .font(.title2)
                    .foregroundStyle(accentRed)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Narração do capítulo")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.1))
                            .frame(height: 3)
                        Capsule()
                            .fill(accentRed)
                            .frame(width: max(0, geo.size.width * audioService.progress), height: 3)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                .frame(height: 10)
            }

            Button {
                audioService.stop()
            } label: {
                Image(systemName: "stop.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var markReadButton: some View {
        Button {
            viewModel.markChapterRead()
            hasMarkedRead = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("Marcar como lido")
                    .font(.subheadline.bold())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(accentRed, in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
        .sensoryFeedback(.success, trigger: hasMarkedRead)
    }

    private var chapterNavigation: some View {
        HStack {
            Button {
                withAnimation(.snappy) { viewModel.goToPreviousChapter() }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: "chevron.left")
                        .font(.body.bold())
                        .foregroundStyle(viewModel.canGoToPreviousChapter ? Color.white : Color.secondary)
                }
            }
            .disabled(!viewModel.canGoToPreviousChapter)

            Spacer()

            Button {
                if let chapter = viewModel.currentChapter {
                    let allText = chapter.verses.map { $0.text }.joined(separator: " ")
                    audioService.speak(allText)
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.2))
                        .frame(width: 56, height: 56)
                    Image(systemName: audioService.isSpeaking ? "pause.fill" : "play.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }

            Spacer()

            Button {
                withAnimation(.snappy) { viewModel.goToNextChapter() }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: "chevron.right")
                        .font(.body.bold())
                        .foregroundStyle(viewModel.canGoToNextChapter ? Color.white : Color.secondary)
                }
            }
            .disabled(!viewModel.canGoToNextChapter)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color(red: 0.07, green: 0.07, blue: 0.08).opacity(0.95))
    }

    private func groupVersesBySection(_ verses: [BibleVerse], bookId: String) -> [VerseSection] {
        [VerseSection(id: "main", heading: nil, subheading: nil, verses: verses)]
    }
}

nonisolated struct VerseSection: Identifiable, Sendable {
    let id: String
    let heading: String?
    let subheading: String?
    let verses: [BibleVerse]
}

struct VerseRow: View {
    let verse: BibleVerse
    let bookName: String
    let fontSize: Double
    let isBookmarked: Bool
    let isPlaying: Bool
    let isPaused: Bool
    let onToggleBookmark: () -> Void
    let onSpeak: () -> Void

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("\(verse.verseNumber)")
                .font(.system(size: fontSize * 0.55, weight: .bold))
                .foregroundStyle(.secondary)
                .frame(width: 20, alignment: .trailing)

            Text(verse.text)
                .font(.system(size: fontSize, design: .serif))
                .lineSpacing(fontSize * 0.5)
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 4)
        .background {
            if isBookmarked {
                RoundedRectangle(cornerRadius: 4)
                    .fill(accentRed.opacity(0.08))
            }
            if isPlaying {
                RoundedRectangle(cornerRadius: 4)
                    .fill(accentRed.opacity(0.05))
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(accentRed.opacity(0.4))
                            .frame(width: 2)
                    }
            }
        }
        .contextMenu {
            Button {
                onSpeak()
            } label: {
                Label(
                    isPlaying ? (isPaused ? "Continuar Áudio" : "Pausar Áudio") : "Ouvir Versículo",
                    systemImage: isPlaying ? (isPaused ? "play.fill" : "pause.fill") : "speaker.wave.2"
                )
            }

            Button {
                onToggleBookmark()
            } label: {
                Label(
                    isBookmarked ? "Remover Marcador" : "Adicionar Marcador",
                    systemImage: isBookmarked ? "bookmark.slash" : "bookmark"
                )
            }

            ShareLink(item: "\(verse.text)\n— \(bookName) \(verse.chapterNumber):\(verse.verseNumber)") {
                Label("Compartilhar", systemImage: "square.and.arrow.up")
            }

            Button {
                UIPasteboard.general.string = "\(verse.text)\n— \(bookName) \(verse.chapterNumber):\(verse.verseNumber)"
            } label: {
                Label("Copiar", systemImage: "doc.on.doc")
            }
        }
        .sensoryFeedback(.selection, trigger: isBookmarked)
    }
}
