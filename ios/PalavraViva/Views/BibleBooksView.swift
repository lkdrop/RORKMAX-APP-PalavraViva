import SwiftUI

struct BibleBooksView: View {
    @Bindable var viewModel: BibleViewModel
    @State private var selectedTestament: Testament = .oldTestament
    @State private var showChapterPicker: Bool = false
    @State private var searchText: String = ""

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                testamentPicker
                booksList
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
            .navigationTitle("Bíblia")
            .sheet(isPresented: $showChapterPicker) {
                if let book = viewModel.selectedBook {
                    ChapterPickerSheet(book: book, viewModel: viewModel)
                }
            }
        }
    }

    private var testamentPicker: some View {
        HStack(spacing: 0) {
            ForEach([Testament.oldTestament, .newTestament], id: \.self) { testament in
                Button {
                    withAnimation(.snappy(duration: 0.25)) {
                        selectedTestament = testament
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(testament == .oldTestament ? "Antigo Testamento" : "Novo Testamento")
                            .font(.subheadline.bold())
                            .foregroundStyle(selectedTestament == testament ? Color.white : Color.secondary)
                        Rectangle()
                            .fill(selectedTestament == testament ? accentRed : .clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var booksList: some View {
        let categories = selectedTestament == .oldTestament
            ? viewModel.bibleService.oldTestamentCategories
            : viewModel.bibleService.newTestamentCategories

        return ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(categories, id: \.self) { category in
                    let booksInCategory = viewModel.bibleService.booksForCategory(category)
                        .filter { $0.testament == selectedTestament }

                    if !booksInCategory.isEmpty {
                        categorySection(category: category, books: booksInCategory)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.bottom, 16)
        }
    }

    private func categorySection(category: BookCategory, books: [BibleBook]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption.bold())
                    .foregroundStyle(colorForCategory(category))
                Text(category.rawValue.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .tracking(1)
            }
            .padding(.leading, 4)

            VStack(spacing: 0) {
                ForEach(books) { book in
                    Button {
                        viewModel.selectedBook = book
                        showChapterPicker = true
                    } label: {
                        HStack(spacing: 14) {
                            Text(book.abbreviation)
                                .font(.caption.bold())
                                .foregroundStyle(colorForCategory(book.category))
                                .frame(width: 36)

                            Text(book.name)
                                .font(.body)
                                .foregroundStyle(.white)

                            Spacer()

                            Text("\(book.chapterCount)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Image(systemName: "chevron.right")
                                .font(.caption2.bold())
                                .foregroundStyle(.quaternary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 13)
                    }
                    .buttonStyle(.plain)

                    if book.id != books.last?.id {
                        Divider()
                            .padding(.leading, 64)
                    }
                }
            }
            .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private func colorForCategory(_ category: BookCategory) -> Color {
        switch category {
        case .law: return Color(red: 0.85, green: 0.65, blue: 0.35)
        case .history: return .teal
        case .poetry: return .purple
        case .majorProphets: return .indigo
        case .minorProphets: return .cyan
        case .gospels: return accentRed
        case .paulineEpistles: return Color(red: 0.7, green: 0.4, blue: 0.4)
        case .generalEpistles: return Color(red: 0.4, green: 0.65, blue: 0.5)
        case .apocalyptic: return .pink
        }
    }
}

struct ChapterPickerSheet: View {
    let book: BibleBook
    @Bindable var viewModel: BibleViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToReader: Bool = false

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(book.name)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            Text("\(book.chapterCount) capítulos")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 20)

                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(1...book.chapterCount, id: \.self) { chapter in
                            Button {
                                viewModel.selectBook(book)
                                viewModel.selectedChapterNumber = chapter
                                navigateToReader = true
                            } label: {
                                Text("\(chapter)")
                                    .font(.body.weight(.medium))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(red: 0.15, green: 0.15, blue: 0.17))
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical)
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
            .navigationTitle("Capítulos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") { dismiss() }
                        .foregroundStyle(accentRed)
                }
            }
            .navigationDestination(isPresented: $navigateToReader) {
                ChapterReaderView(viewModel: viewModel)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationContentInteraction(.scrolls)
    }
}
