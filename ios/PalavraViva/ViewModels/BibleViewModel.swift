import SwiftUI

@Observable
final class BibleViewModel {
    let bibleService = BibleService()

    var selectedBook: BibleBook?
    var selectedChapterNumber: Int = 1
    var searchQuery: String = ""
    var searchResults: [BibleVerse] = []
    var bookmarks: [Bookmark] = []
    var readingProgress: ReadingProgress
    var readingStreak: ReadingStreak
    var fontSize: Double = 18
    var currentChapter: BibleChapter?
    var isLoadingChapter: Bool = false
    var chapterLoadError: String? = nil
    var isSearching: Bool = false

    private let bookmarksKey = "savedBookmarks"
    private let progressKey = "readingProgress"
    private let fontSizeKey = "fontSize"
    private let streakKey = "readingStreak"

    init() {
        readingProgress = ReadingProgress(chaptersRead: 0, totalChapters: 0)
        readingStreak = ReadingStreak(currentStreak: 0, longestStreak: 0, totalDaysRead: 0, chaptersReadToday: 0)
        loadBookmarks()
        loadProgress()
        loadFontSize()
        loadStreak()
    }

    var dailyVerse: DailyVerse {
        bibleService.getDailyVerse()
    }

    var canGoToPreviousChapter: Bool {
        selectedChapterNumber > 1
    }

    var canGoToNextChapter: Bool {
        guard let book = selectedBook else { return false }
        return selectedChapterNumber < book.chapterCount
    }

    func selectBook(_ book: BibleBook) {
        selectedBook = book
        selectedChapterNumber = 1
    }

    func loadCurrentChapter() async {
        guard let book = selectedBook else { return }
        isLoadingChapter = true
        chapterLoadError = nil
        let chapter = await bibleService.fetchChapter(bookId: book.id, chapterNumber: selectedChapterNumber)
        isLoadingChapter = false
        if let chapter {
            currentChapter = chapter
            chapterLoadError = nil
        } else {
            currentChapter = nil
            chapterLoadError = bibleService.loadError ?? "Erro ao carregar capítulo"
        }
    }

    func goToPreviousChapter() {
        guard canGoToPreviousChapter else { return }
        selectedChapterNumber -= 1
        Task { await loadCurrentChapter() }
    }

    func goToNextChapter() {
        guard canGoToNextChapter else { return }
        selectedChapterNumber += 1
        Task { await loadCurrentChapter() }
    }

    func markChapterRead() {
        guard let book = selectedBook else { return }

        readingProgress.lastBookId = book.id
        readingProgress.lastChapterNumber = selectedChapterNumber
        readingProgress.lastBookName = book.name
        readingProgress.chaptersRead += 1
        readingProgress.totalChapters = bibleService.totalChapters

        if !readingStreak.isActiveToday {
            if readingStreak.wasActiveYesterday {
                readingStreak.currentStreak += 1
            } else {
                readingStreak.currentStreak = 1
            }
            readingStreak.totalDaysRead += 1
        }
        readingStreak.lastReadDate = Date()
        readingStreak.chaptersReadToday += 1
        if readingStreak.currentStreak > readingStreak.longestStreak {
            readingStreak.longestStreak = readingStreak.currentStreak
        }

        saveProgress()
        saveStreak()
    }

    func performSearch() {
        let query = searchQuery
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        isSearching = true
        Task {
            let results = await bibleService.searchVerses(query: query)
            isSearching = false
            searchResults = results
        }
    }

    func isBookmarked(_ verse: BibleVerse) -> Bool {
        bookmarks.contains { $0.verse.id == verse.id }
    }

    func toggleBookmark(verse: BibleVerse, bookName: String) {
        if let index = bookmarks.firstIndex(where: { $0.verse.id == verse.id }) {
            bookmarks.remove(at: index)
        } else {
            let reference = "\(bookName) \(verse.chapterNumber):\(verse.verseNumber)"
            let bookmark = Bookmark(
                id: UUID().uuidString,
                verse: verse,
                bookName: bookName,
                reference: reference,
                dateAdded: Date(),
                note: "",
                highlightColor: "yellow"
            )
            bookmarks.append(bookmark)
        }
        saveBookmarks()
    }

    func removeBookmark(_ bookmark: Bookmark) {
        bookmarks.removeAll { $0.id == bookmark.id }
        saveBookmarks()
    }

    func bookNameForVerse(_ verse: BibleVerse) -> String {
        bibleService.getBook(id: verse.bookId)?.name ?? ""
    }

    private func saveBookmarks() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        }
    }

    private func loadBookmarks() {
        guard let data = UserDefaults.standard.data(forKey: bookmarksKey),
              let saved = try? JSONDecoder().decode([Bookmark].self, from: data) else { return }
        bookmarks = saved
    }

    private func saveProgress() {
        if let data = try? JSONEncoder().encode(readingProgress) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
    }

    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: progressKey),
              let saved = try? JSONDecoder().decode(ReadingProgress.self, from: data) else {
            readingProgress = ReadingProgress(
                chaptersRead: 0,
                totalChapters: bibleService.totalChapters
            )
            return
        }
        readingProgress = saved
        readingProgress.totalChapters = bibleService.totalChapters
    }

    private func saveStreak() {
        if let data = try? JSONEncoder().encode(readingStreak) {
            UserDefaults.standard.set(data, forKey: streakKey)
        }
    }

    private func loadStreak() {
        guard let data = UserDefaults.standard.data(forKey: streakKey),
              let saved = try? JSONDecoder().decode(ReadingStreak.self, from: data) else { return }
        readingStreak = saved

        if !saved.isActiveToday && !saved.wasActiveYesterday && saved.currentStreak > 0 {
            readingStreak.currentStreak = 0
            readingStreak.chaptersReadToday = 0
            saveStreak()
        }
        if !saved.isActiveToday {
            readingStreak.chaptersReadToday = 0
        }
    }

    private func loadFontSize() {
        let saved = UserDefaults.standard.double(forKey: fontSizeKey)
        if saved > 0 { fontSize = saved }
    }

    func saveFontSize() {
        UserDefaults.standard.set(fontSize, forKey: fontSizeKey)
    }
}
