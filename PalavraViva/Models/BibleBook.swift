import Foundation

nonisolated enum Testament: String, Codable, Sendable, CaseIterable {
    case oldTestament = "Antigo Testamento"
    case newTestament = "Novo Testamento"
}

nonisolated enum BookCategory: String, Codable, Sendable, CaseIterable {
    case law = "Lei"
    case history = "História"
    case poetry = "Poesia"
    case majorProphets = "Profetas Maiores"
    case minorProphets = "Profetas Menores"
    case gospels = "Evangelhos"
    case paulineEpistles = "Epístolas Paulinas"
    case generalEpistles = "Epístolas Gerais"
    case apocalyptic = "Apocalíptico"

    var icon: String {
        switch self {
        case .law: return "scroll"
        case .history: return "clock.arrow.circlepath"
        case .poetry: return "music.note"
        case .majorProphets: return "eye"
        case .minorProphets: return "megaphone"
        case .gospels: return "book.fill"
        case .paulineEpistles: return "envelope.fill"
        case .generalEpistles: return "paperplane.fill"
        case .apocalyptic: return "sparkle"
        }
    }

    var color: String {
        switch self {
        case .law: return "law"
        case .history: return "history"
        case .poetry: return "poetry"
        case .majorProphets: return "majorProphets"
        case .minorProphets: return "minorProphets"
        case .gospels: return "gospels"
        case .paulineEpistles: return "pauline"
        case .generalEpistles: return "general"
        case .apocalyptic: return "apocalyptic"
        }
    }
}

nonisolated struct BibleBook: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let name: String
    let abbreviation: String
    let testament: Testament
    let chapterCount: Int
    let icon: String
    let category: BookCategory
}

nonisolated struct BibleChapter: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let bookId: String
    let number: Int
    let verses: [BibleVerse]
}

nonisolated struct BibleVerse: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let bookId: String
    let chapterNumber: Int
    let verseNumber: Int
    let text: String
}

nonisolated struct DailyVerse: Identifiable, Codable, Sendable {
    let id: String
    let verse: BibleVerse
    let bookName: String
    let reference: String
}

nonisolated struct Bookmark: Identifiable, Codable, Sendable {
    let id: String
    let verse: BibleVerse
    let bookName: String
    let reference: String
    let dateAdded: Date
    var note: String
    var highlightColor: String
}

nonisolated struct ReadingStreak: Codable, Sendable {
    var currentStreak: Int
    var longestStreak: Int
    var lastReadDate: Date?
    var totalDaysRead: Int
    var chaptersReadToday: Int

    var isActiveToday: Bool {
        guard let last = lastReadDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    var wasActiveYesterday: Bool {
        guard let last = lastReadDate else { return false }
        return Calendar.current.isDateInYesterday(last)
    }
}

nonisolated struct ReadingProgress: Codable, Sendable {
    var lastBookId: String?
    var lastChapterNumber: Int?
    var lastBookName: String?
    var chaptersRead: Int
    var totalChapters: Int

    var percentage: Double {
        guard totalChapters > 0 else { return 0 }
        return Double(chaptersRead) / Double(totalChapters)
    }
}
