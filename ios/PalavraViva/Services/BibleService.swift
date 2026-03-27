import Foundation

nonisolated struct BibleAPIResponse: Codable, Sendable {
    let reference: String
    let verses: [BibleAPIVerse]
    let translation_id: String?
    let translation_name: String?
}

nonisolated struct BibleAPIVerse: Codable, Sendable {
    let book_id: String
    let book_name: String
    let chapter: Int
    let verse: Int
    let text: String
}

nonisolated struct ABibliaChapterResponse: Codable, Sendable {
    let chapter: ABibliaChapterData
    let verses: [ABibliaVerse]
}

nonisolated struct ABibliaChapterData: Codable, Sendable {
    let number: Int
}

nonisolated struct ABibliaVerse: Codable, Sendable {
    let number: Int
    let text: String
}

nonisolated struct ABibliaSearchResponse: Codable, Sendable {
    let verses: [ABibliaSearchVerse]
}

nonisolated struct ABibliaSearchVerse: Codable, Sendable {
    let book: ABibliaSearchBook
    let chapter: Int
    let number: Int
    let text: String
}

nonisolated struct ABibliaSearchBook: Codable, Sendable {
    let abbrev: ABibliaAbbrev
    let name: String
}

nonisolated struct ABibliaAbbrev: Codable, Sendable {
    let pt: String
}

@Observable
final class BibleService {
    private(set) var books: [BibleBook] = []
    private var cachedChapters: [String: BibleChapter] = [:]
    private(set) var isLoading: Bool = false
    private(set) var loadError: String? = nil

    private let primaryBaseURL = "https://bible-api.com"
    private let fallbackBaseURL = "https://www.abibliadigital.com.br/api"
    private let translation = "almeida"

    private var lastRequestTime: Date = .distantPast
    private let minRequestInterval: TimeInterval = 0.4

    init() {
        loadBooks()
    }

    private static let bookAPIIds: [String: String] = [
        "gen": "GEN", "exo": "EXO", "lev": "LEV", "num": "NUM", "deu": "DEU",
        "jos": "JOS", "jdg": "JDG", "rut": "RUT", "1sa": "1SA", "2sa": "2SA",
        "1ki": "1KI", "2ki": "2KI", "1ch": "1CH", "2ch": "2CH", "ezr": "EZR",
        "neh": "NEH", "est": "EST",
        "job": "JOB", "psa": "PSA", "pro": "PRO", "ecc": "ECC", "sng": "SNG",
        "isa": "ISA", "jer": "JER", "lam": "LAM", "ezk": "EZK", "dan": "DAN",
        "hos": "HOS", "jol": "JOL", "amo": "AMO", "oba": "OBA", "jon": "JON",
        "mic": "MIC", "nah": "NAH", "hab": "HAB", "zep": "ZEP", "hag": "HAG",
        "zec": "ZEC", "mal": "MAL",
        "mat": "MAT", "mrk": "MRK", "luk": "LUK", "jhn": "JHN", "act": "ACT",
        "rom": "ROM", "1co": "1CO", "2co": "2CO", "gal": "GAL", "eph": "EPH",
        "php": "PHP", "col": "COL", "1th": "1TH", "2th": "2TH", "1ti": "1TI",
        "2ti": "2TI", "tit": "TIT", "phm": "PHM",
        "heb": "HEB", "jas": "JAS", "1pe": "1PE", "2pe": "2PE", "1jn": "1JN",
        "2jn": "2JN", "3jn": "3JN", "jud": "JUD",
        "rev": "REV"
    ]

    private static let bookAbbrevPT: [String: String] = [
        "gen": "gn", "exo": "ex", "lev": "lv", "num": "nm", "deu": "dt",
        "jos": "js", "jdg": "jz", "rut": "rt", "1sa": "1sm", "2sa": "2sm",
        "1ki": "1rs", "2ki": "2rs", "1ch": "1cr", "2ch": "2cr", "ezr": "ed",
        "neh": "ne", "est": "et",
        "job": "jó", "psa": "sl", "pro": "pv", "ecc": "ec", "sng": "ct",
        "isa": "is", "jer": "jr", "lam": "lm", "ezk": "ez", "dan": "dn",
        "hos": "os", "jol": "jl", "amo": "am", "oba": "ob", "jon": "jn",
        "mic": "mq", "nah": "na", "hab": "hc", "zep": "sf", "hag": "ag",
        "zec": "zc", "mal": "ml",
        "mat": "mt", "mrk": "mc", "luk": "lc", "jhn": "jo", "act": "at",
        "rom": "rm", "1co": "1co", "2co": "2co", "gal": "gl", "eph": "ef",
        "php": "fp", "col": "cl", "1th": "1ts", "2th": "2ts", "1ti": "1tm",
        "2ti": "2tm", "tit": "tt", "phm": "fm",
        "heb": "hb", "jas": "tg", "1pe": "1pe", "2pe": "2pe", "1jn": "1jo",
        "2jn": "2jo", "3jn": "3jo", "jud": "jd",
        "rev": "ap"
    ]

    private static let singleChapterBooks: Set<String> = ["OBA", "PHM", "2JN", "3JN", "JUD"]

    private func throttle() async {
        let elapsed = Date().timeIntervalSince(lastRequestTime)
        if elapsed < minRequestInterval {
            let waitTime = minRequestInterval - elapsed
            try? await Task.sleep(for: .seconds(waitTime))
        }
        lastRequestTime = Date()
    }

    func fetchChapter(bookId: String, chapterNumber: Int) async -> BibleChapter? {
        let cacheKey = "\(bookId)-\(chapterNumber)"

        if let cached = cachedChapters[cacheKey] {
            return cached
        }

        isLoading = true
        loadError = nil
        defer { isLoading = false }

        if let chapter = await fetchFromPrimary(bookId: bookId, chapterNumber: chapterNumber, cacheKey: cacheKey) {
            return chapter
        }

        if let chapter = await fetchFromFallback(bookId: bookId, chapterNumber: chapterNumber, cacheKey: cacheKey) {
            return chapter
        }

        loadError = "Não foi possível carregar o capítulo. Tente novamente."
        return nil
    }

    private func fetchFromPrimary(bookId: String, chapterNumber: Int, cacheKey: String) async -> BibleChapter? {
        guard let apiId = Self.bookAPIIds[bookId] else { return nil }

        let urlString: String
        if Self.singleChapterBooks.contains(apiId) {
            urlString = "\(primaryBaseURL)/\(apiId)+1:1-200?translation=\(translation)"
        } else {
            urlString = "\(primaryBaseURL)/\(apiId)+\(chapterNumber)?translation=\(translation)"
        }
        guard let url = URL(string: urlString) else { return nil }

        for attempt in 0..<4 {
            await throttle()

            if attempt > 0 {
                let delay = Double(attempt) * 2.0
                try? await Task.sleep(for: .seconds(delay))
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                let code = (response as? HTTPURLResponse)?.statusCode ?? 0

                if code == 200 {
                    let apiResponse = try JSONDecoder().decode(BibleAPIResponse.self, from: data)
                    let verses = apiResponse.verses.map { apiVerse in
                        BibleVerse(
                            id: "\(bookId)-\(chapterNumber)-\(apiVerse.verse)",
                            bookId: bookId,
                            chapterNumber: chapterNumber,
                            verseNumber: apiVerse.verse,
                            text: apiVerse.text.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    }
                    let chapter = BibleChapter(id: cacheKey, bookId: bookId, number: chapterNumber, verses: verses)
                    cachedChapters[cacheKey] = chapter
                    return chapter
                }

                if code == 429 || code == 503 {
                    continue
                }

                return nil
            } catch {
                if attempt == 3 { return nil }
                continue
            }
        }

        return nil
    }

    private func fetchFromFallback(bookId: String, chapterNumber: Int, cacheKey: String) async -> BibleChapter? {
        guard let abbrev = Self.bookAbbrevPT[bookId] else { return nil }

        let urlString = "\(fallbackBaseURL)/verses/ra/\(abbrev)/\(chapterNumber)"
        guard let url = URL(string: urlString) else { return nil }

        for attempt in 0..<2 {
            if attempt > 0 {
                try? await Task.sleep(for: .seconds(2.0))
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                let code = (response as? HTTPURLResponse)?.statusCode ?? 0

                guard code == 200 else { continue }

                let fallbackResponse = try JSONDecoder().decode(ABibliaChapterResponse.self, from: data)
                let verses = fallbackResponse.verses.map { v in
                    BibleVerse(
                        id: "\(bookId)-\(chapterNumber)-\(v.number)",
                        bookId: bookId,
                        chapterNumber: chapterNumber,
                        verseNumber: v.number,
                        text: v.text.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                }
                let chapter = BibleChapter(id: cacheKey, bookId: bookId, number: chapterNumber, verses: verses)
                cachedChapters[cacheKey] = chapter
                return chapter
            } catch {
                continue
            }
        }

        return nil
    }

    func searchVerses(query: String) async -> [BibleVerse] {
        guard !query.isEmpty else { return [] }

        await throttle()

        let urlString = "\(primaryBaseURL)/search/\(query)?translation=\(translation)"
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded) else {
            return searchCachedVerses(query: query)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return await searchFallback(query: query)
            }
            let apiResponse = try JSONDecoder().decode(BibleAPIResponse.self, from: data)
            return apiResponse.verses.prefix(50).map { apiVerse in
                let internalId = Self.bookAPIIds.first(where: { $0.value == apiVerse.book_id })?.key ?? apiVerse.book_id.lowercased()
                return BibleVerse(
                    id: "\(internalId)-\(apiVerse.chapter)-\(apiVerse.verse)",
                    bookId: internalId,
                    chapterNumber: apiVerse.chapter,
                    verseNumber: apiVerse.verse,
                    text: apiVerse.text.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        } catch {
            return await searchFallback(query: query)
        }
    }

    private func searchFallback(query: String) async -> [BibleVerse] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(fallbackBaseURL)/verses/search?version=ra&search=\(encoded)") else {
            return searchCachedVerses(query: query)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return searchCachedVerses(query: query)
            }
            let searchResponse = try JSONDecoder().decode(ABibliaSearchResponse.self, from: data)
            return searchResponse.verses.prefix(50).map { sv in
                let internalId = Self.bookAbbrevPT.first(where: { $0.value == sv.book.abbrev.pt })?.key ?? sv.book.abbrev.pt
                return BibleVerse(
                    id: "\(internalId)-\(sv.chapter)-\(sv.number)",
                    bookId: internalId,
                    chapterNumber: sv.chapter,
                    verseNumber: sv.number,
                    text: sv.text.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        } catch {
            return searchCachedVerses(query: query)
        }
    }

    private func searchCachedVerses(query: String) -> [BibleVerse] {
        let lowered = query.lowercased()
        var results: [BibleVerse] = []
        for (_, chapter) in cachedChapters {
            results.append(contentsOf: chapter.verses.filter {
                $0.text.localizedStandardContains(lowered)
            })
        }
        return results
    }

    func getBook(id: String) -> BibleBook? {
        books.first { $0.id == id }
    }

    var oldTestamentBooks: [BibleBook] {
        books.filter { $0.testament == .oldTestament }
    }

    var newTestamentBooks: [BibleBook] {
        books.filter { $0.testament == .newTestament }
    }

    func booksForCategory(_ category: BookCategory) -> [BibleBook] {
        books.filter { $0.category == category }
    }

    var oldTestamentCategories: [BookCategory] {
        [.law, .history, .poetry, .majorProphets, .minorProphets]
    }

    var newTestamentCategories: [BookCategory] {
        [.gospels, .paulineEpistles, .generalEpistles, .apocalyptic]
    }

    func getDailyVerse() -> DailyVerse {
        let dailyVerses: [DailyVerse] = [
            DailyVerse(id: "dv1", verse: BibleVerse(id: "jer-29-11", bookId: "jer", chapterNumber: 29, verseNumber: 11, text: "Porque eu bem sei os planos que tenho a vosso favor, diz o Senhor; planos de paz e não de mal, para vos dar o fim que desejais."), bookName: "Jeremias", reference: "Jeremias 29:11"),
            DailyVerse(id: "dv2", verse: BibleVerse(id: "php-4-13", bookId: "php", chapterNumber: 4, verseNumber: 13, text: "Tudo posso naquele que me fortalece."), bookName: "Filipenses", reference: "Filipenses 4:13"),
            DailyVerse(id: "dv3", verse: BibleVerse(id: "psa-23-1", bookId: "psa", chapterNumber: 23, verseNumber: 1, text: "O Senhor é o meu pastor; nada me faltará."), bookName: "Salmos", reference: "Salmos 23:1"),
            DailyVerse(id: "dv4", verse: BibleVerse(id: "isa-41-10", bookId: "isa", chapterNumber: 41, verseNumber: 10, text: "Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus; eu te fortaleço, e te ajudo, e te sustento com a minha destra fiel."), bookName: "Isaías", reference: "Isaías 41:10"),
            DailyVerse(id: "dv5", verse: BibleVerse(id: "rom-8-28", bookId: "rom", chapterNumber: 8, verseNumber: 28, text: "Sabemos que todas as coisas cooperam para o bem daqueles que amam a Deus, daqueles que são chamados segundo o seu propósito."), bookName: "Romanos", reference: "Romanos 8:28"),
            DailyVerse(id: "dv6", verse: BibleVerse(id: "pro-3-5", bookId: "pro", chapterNumber: 3, verseNumber: 5, text: "Confia no Senhor de todo o teu coração e não te estribes no teu próprio entendimento."), bookName: "Provérbios", reference: "Provérbios 3:5"),
            DailyVerse(id: "dv7", verse: BibleVerse(id: "jhn-3-16", bookId: "jhn", chapterNumber: 3, verseNumber: 16, text: "Porque Deus amou ao mundo de tal maneira que deu o seu Filho unigênito, para que todo o que nele crê não pereça, mas tenha a vida eterna."), bookName: "João", reference: "João 3:16"),
        ]
        let dayIndex = Calendar.current.component(.day, from: Date()) % dailyVerses.count
        return dailyVerses[dayIndex]
    }

    var totalChapters: Int {
        books.reduce(0) { $0 + $1.chapterCount }
    }

    private func loadBooks() {
        books = [
            BibleBook(id: "gen", name: "Gênesis", abbreviation: "Gn", testament: .oldTestament, chapterCount: 50, icon: "globe.americas", category: .law),
            BibleBook(id: "exo", name: "Êxodo", abbreviation: "Êx", testament: .oldTestament, chapterCount: 40, icon: "figure.walk", category: .law),
            BibleBook(id: "lev", name: "Levítico", abbreviation: "Lv", testament: .oldTestament, chapterCount: 27, icon: "flame", category: .law),
            BibleBook(id: "num", name: "Números", abbreviation: "Nm", testament: .oldTestament, chapterCount: 36, icon: "number", category: .law),
            BibleBook(id: "deu", name: "Deuteronômio", abbreviation: "Dt", testament: .oldTestament, chapterCount: 34, icon: "scroll", category: .law),

            BibleBook(id: "jos", name: "Josué", abbreviation: "Js", testament: .oldTestament, chapterCount: 24, icon: "shield", category: .history),
            BibleBook(id: "jdg", name: "Juízes", abbreviation: "Jz", testament: .oldTestament, chapterCount: 21, icon: "scalemass", category: .history),
            BibleBook(id: "rut", name: "Rute", abbreviation: "Rt", testament: .oldTestament, chapterCount: 4, icon: "leaf", category: .history),
            BibleBook(id: "1sa", name: "1 Samuel", abbreviation: "1Sm", testament: .oldTestament, chapterCount: 31, icon: "crown", category: .history),
            BibleBook(id: "2sa", name: "2 Samuel", abbreviation: "2Sm", testament: .oldTestament, chapterCount: 24, icon: "crown.fill", category: .history),
            BibleBook(id: "1ki", name: "1 Reis", abbreviation: "1Rs", testament: .oldTestament, chapterCount: 22, icon: "building.columns", category: .history),
            BibleBook(id: "2ki", name: "2 Reis", abbreviation: "2Rs", testament: .oldTestament, chapterCount: 25, icon: "building.columns.fill", category: .history),
            BibleBook(id: "1ch", name: "1 Crônicas", abbreviation: "1Cr", testament: .oldTestament, chapterCount: 29, icon: "book", category: .history),
            BibleBook(id: "2ch", name: "2 Crônicas", abbreviation: "2Cr", testament: .oldTestament, chapterCount: 36, icon: "book.fill", category: .history),
            BibleBook(id: "ezr", name: "Esdras", abbreviation: "Ed", testament: .oldTestament, chapterCount: 10, icon: "hammer", category: .history),
            BibleBook(id: "neh", name: "Neemias", abbreviation: "Ne", testament: .oldTestament, chapterCount: 13, icon: "rectangle.stack.fill", category: .history),
            BibleBook(id: "est", name: "Ester", abbreviation: "Et", testament: .oldTestament, chapterCount: 10, icon: "sparkles", category: .history),

            BibleBook(id: "job", name: "Jó", abbreviation: "Jó", testament: .oldTestament, chapterCount: 42, icon: "heart", category: .poetry),
            BibleBook(id: "psa", name: "Salmos", abbreviation: "Sl", testament: .oldTestament, chapterCount: 150, icon: "music.note", category: .poetry),
            BibleBook(id: "pro", name: "Provérbios", abbreviation: "Pv", testament: .oldTestament, chapterCount: 31, icon: "lightbulb", category: .poetry),
            BibleBook(id: "ecc", name: "Eclesiastes", abbreviation: "Ec", testament: .oldTestament, chapterCount: 12, icon: "wind", category: .poetry),
            BibleBook(id: "sng", name: "Cânticos", abbreviation: "Ct", testament: .oldTestament, chapterCount: 8, icon: "heart.fill", category: .poetry),

            BibleBook(id: "isa", name: "Isaías", abbreviation: "Is", testament: .oldTestament, chapterCount: 66, icon: "eye", category: .majorProphets),
            BibleBook(id: "jer", name: "Jeremias", abbreviation: "Jr", testament: .oldTestament, chapterCount: 52, icon: "drop", category: .majorProphets),
            BibleBook(id: "lam", name: "Lamentações", abbreviation: "Lm", testament: .oldTestament, chapterCount: 5, icon: "drop.fill", category: .majorProphets),
            BibleBook(id: "ezk", name: "Ezequiel", abbreviation: "Ez", testament: .oldTestament, chapterCount: 48, icon: "bolt", category: .majorProphets),
            BibleBook(id: "dan", name: "Daniel", abbreviation: "Dn", testament: .oldTestament, chapterCount: 12, icon: "shield.fill", category: .majorProphets),

            BibleBook(id: "hos", name: "Oséias", abbreviation: "Os", testament: .oldTestament, chapterCount: 14, icon: "arrow.uturn.backward", category: .minorProphets),
            BibleBook(id: "jol", name: "Joel", abbreviation: "Jl", testament: .oldTestament, chapterCount: 3, icon: "cloud.bolt", category: .minorProphets),
            BibleBook(id: "amo", name: "Amós", abbreviation: "Am", testament: .oldTestament, chapterCount: 9, icon: "scalemass.fill", category: .minorProphets),
            BibleBook(id: "oba", name: "Obadias", abbreviation: "Ob", testament: .oldTestament, chapterCount: 1, icon: "mountain.2", category: .minorProphets),
            BibleBook(id: "jon", name: "Jonas", abbreviation: "Jn", testament: .oldTestament, chapterCount: 4, icon: "water.waves", category: .minorProphets),
            BibleBook(id: "mic", name: "Miquéias", abbreviation: "Mq", testament: .oldTestament, chapterCount: 7, icon: "figure.stand", category: .minorProphets),
            BibleBook(id: "nah", name: "Naum", abbreviation: "Na", testament: .oldTestament, chapterCount: 3, icon: "cloud.heavyrain", category: .minorProphets),
            BibleBook(id: "hab", name: "Habacuque", abbreviation: "Hc", testament: .oldTestament, chapterCount: 3, icon: "questionmark.circle", category: .minorProphets),
            BibleBook(id: "zep", name: "Sofonias", abbreviation: "Sf", testament: .oldTestament, chapterCount: 3, icon: "bell", category: .minorProphets),
            BibleBook(id: "hag", name: "Ageu", abbreviation: "Ag", testament: .oldTestament, chapterCount: 2, icon: "house", category: .minorProphets),
            BibleBook(id: "zec", name: "Zacarias", abbreviation: "Zc", testament: .oldTestament, chapterCount: 14, icon: "star", category: .minorProphets),
            BibleBook(id: "mal", name: "Malaquias", abbreviation: "Ml", testament: .oldTestament, chapterCount: 4, icon: "envelope", category: .minorProphets),

            BibleBook(id: "mat", name: "Mateus", abbreviation: "Mt", testament: .newTestament, chapterCount: 28, icon: "person.fill", category: .gospels),
            BibleBook(id: "mrk", name: "Marcos", abbreviation: "Mc", testament: .newTestament, chapterCount: 16, icon: "hare", category: .gospels),
            BibleBook(id: "luk", name: "Lucas", abbreviation: "Lc", testament: .newTestament, chapterCount: 24, icon: "stethoscope", category: .gospels),
            BibleBook(id: "jhn", name: "João", abbreviation: "Jo", testament: .newTestament, chapterCount: 21, icon: "bird", category: .gospels),
            BibleBook(id: "act", name: "Atos", abbreviation: "At", testament: .newTestament, chapterCount: 28, icon: "flame.fill", category: .history),

            BibleBook(id: "rom", name: "Romanos", abbreviation: "Rm", testament: .newTestament, chapterCount: 16, icon: "building.columns", category: .paulineEpistles),
            BibleBook(id: "1co", name: "1 Coríntios", abbreviation: "1Co", testament: .newTestament, chapterCount: 16, icon: "envelope.fill", category: .paulineEpistles),
            BibleBook(id: "2co", name: "2 Coríntios", abbreviation: "2Co", testament: .newTestament, chapterCount: 13, icon: "envelope.badge", category: .paulineEpistles),
            BibleBook(id: "gal", name: "Gálatas", abbreviation: "Gl", testament: .newTestament, chapterCount: 6, icon: "figure.run", category: .paulineEpistles),
            BibleBook(id: "eph", name: "Efésios", abbreviation: "Ef", testament: .newTestament, chapterCount: 6, icon: "shield.checkered", category: .paulineEpistles),
            BibleBook(id: "php", name: "Filipenses", abbreviation: "Fp", testament: .newTestament, chapterCount: 4, icon: "face.smiling", category: .paulineEpistles),
            BibleBook(id: "col", name: "Colossenses", abbreviation: "Cl", testament: .newTestament, chapterCount: 4, icon: "crown", category: .paulineEpistles),
            BibleBook(id: "1th", name: "1 Tessalonicenses", abbreviation: "1Ts", testament: .newTestament, chapterCount: 5, icon: "clock", category: .paulineEpistles),
            BibleBook(id: "2th", name: "2 Tessalonicenses", abbreviation: "2Ts", testament: .newTestament, chapterCount: 3, icon: "clock.fill", category: .paulineEpistles),
            BibleBook(id: "1ti", name: "1 Timóteo", abbreviation: "1Tm", testament: .newTestament, chapterCount: 6, icon: "person.badge.key", category: .paulineEpistles),
            BibleBook(id: "2ti", name: "2 Timóteo", abbreviation: "2Tm", testament: .newTestament, chapterCount: 4, icon: "person.badge.key.fill", category: .paulineEpistles),
            BibleBook(id: "tit", name: "Tito", abbreviation: "Tt", testament: .newTestament, chapterCount: 3, icon: "list.bullet.rectangle", category: .paulineEpistles),
            BibleBook(id: "phm", name: "Filemom", abbreviation: "Fm", testament: .newTestament, chapterCount: 1, icon: "hand.raised", category: .paulineEpistles),

            BibleBook(id: "heb", name: "Hebreus", abbreviation: "Hb", testament: .newTestament, chapterCount: 13, icon: "cross", category: .generalEpistles),
            BibleBook(id: "jas", name: "Tiago", abbreviation: "Tg", testament: .newTestament, chapterCount: 5, icon: "hammer.fill", category: .generalEpistles),
            BibleBook(id: "1pe", name: "1 Pedro", abbreviation: "1Pe", testament: .newTestament, chapterCount: 5, icon: "key", category: .generalEpistles),
            BibleBook(id: "2pe", name: "2 Pedro", abbreviation: "2Pe", testament: .newTestament, chapterCount: 3, icon: "key.fill", category: .generalEpistles),
            BibleBook(id: "1jn", name: "1 João", abbreviation: "1Jo", testament: .newTestament, chapterCount: 5, icon: "heart.circle", category: .generalEpistles),
            BibleBook(id: "2jn", name: "2 João", abbreviation: "2Jo", testament: .newTestament, chapterCount: 1, icon: "heart.circle.fill", category: .generalEpistles),
            BibleBook(id: "3jn", name: "3 João", abbreviation: "3Jo", testament: .newTestament, chapterCount: 1, icon: "heart.square", category: .generalEpistles),
            BibleBook(id: "jud", name: "Judas", abbreviation: "Jd", testament: .newTestament, chapterCount: 1, icon: "exclamationmark.shield", category: .generalEpistles),

            BibleBook(id: "rev", name: "Apocalipse", abbreviation: "Ap", testament: .newTestament, chapterCount: 22, icon: "sparkle", category: .apocalyptic),
        ]
    }
}
