import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: BibleViewModel
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var showSettings: Bool = false
    @State private var showBookmarks: Bool = false
    @State private var showGabriel: Bool = false
    @State private var selectedActivityFilter: Int = 0
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)
    private let activityFilters = ["Todos", "Destaques", "Anotações", "Planos"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    churchButton
                    actionButtons
                    statsCard
                    medalsCard
                    activitySection
                }
                .padding(.bottom, 32)
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        Button {} label: {
                            Image(systemName: "square.grid.2x2")
                                .foregroundStyle(.white)
                        }
                        Button { showSettings = true } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.white)
                        }
                        Button {} label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack {
                    SettingsView(viewModel: viewModel)
                }
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showBookmarks) {
                NavigationStack {
                    BookmarksView(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $showGabriel) {
                NavigationStack {
                    GabrielChatView()
                }
            }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Usuário")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                HStack(spacing: 12) {
                    Button {} label: {
                        Text("+ Amigos")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.22), in: Capsule())
                    }
                    Button {} label: {
                        Text("Seguindo 0")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.22), in: Capsule())
                    }
                }
            }

            Spacer()

            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .strokeBorder(Color(red: 0.3, green: 0.3, blue: 0.32), lineWidth: 3)
                        .frame(width: 72, height: 72)

                    let progress = min(Double(viewModel.readingProgress.chaptersRead) / 100.0, 1.0)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(accentRed, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))

                    Text("U")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }

                Button {} label: {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.22))
                            .frame(width: 28, height: 28)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(.white)
                    }
                }
                .offset(x: 2, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var churchButton: some View {
        Button {} label: {
            HStack(spacing: 10) {
                Image(systemName: "plus.square")
                    .font(.body)
                    .foregroundStyle(.white)
                Text("Adicionar sua igreja")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            profileActionButton(icon: "bookmark.fill", label: "Salvo") {
                showBookmarks = true
            }
            profileActionButton(icon: "hands.sparkles", label: "Oração") {
                showGabriel = true
            }
            profileActionButton(icon: "heart.fill", label: "Doar") {}
        }
        .padding(.horizontal, 16)
    }

    private func profileActionButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private var statsCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.readingStreak.currentStreak)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text("Perseverança no Aplicativo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "bolt.fill")
                .font(.title2)
                .foregroundStyle(accentRed)
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
    }

    private var medalsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(viewModel.readingProgress.chaptersRead)")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("Medalhas")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "medal")
                    .font(.title3)
                    .foregroundStyle(accentRed)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    medalBadge(icon: "book.closed.fill", label: "Leitor", color: accentRed)
                    medalBadge(icon: "flame.fill", label: "Constante", color: .orange)
                    medalBadge(icon: "star.fill", label: "Explorador", color: .yellow)
                    medalBadge(icon: "checkmark.seal.fill", label: "Dedicado", color: .green)
                }
            }
            .contentMargins(.horizontal, 0)

            HStack {
                pageIndicator(count: 3, current: 0)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
    }

    private func pageIndicator(count: Int, current: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current ? accentRed : Color(red: 0.3, green: 0.3, blue: 0.32))
                    .frame(width: index == current ? 16 : 6, height: 4)
            }
        }
    }

    private func medalBadge(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.body.bold())
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Atividade")
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(activityFilters.enumerated()), id: \.offset) { index, filter in
                        Button {
                            withAnimation(.snappy(duration: 0.2)) { selectedActivityFilter = index }
                        } label: {
                            HStack(spacing: 6) {
                                if index == 1 {
                                    Image(systemName: "pencil")
                                        .font(.caption2)
                                } else if index == 2 {
                                    Image(systemName: "text.alignleft")
                                        .font(.caption2)
                                } else if index == 3 {
                                    Image(systemName: "checkmark.square")
                                        .font(.caption2)
                                }
                                Text(filter)
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundStyle(selectedActivityFilter == index ? Color.black : Color.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background {
                                if selectedActivityFilter == index {
                                    Capsule().fill(.white)
                                } else {
                                    Capsule().fill(Color(red: 0.15, green: 0.15, blue: 0.17))
                                }
                            }
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 16)

            if viewModel.bookmarks.isEmpty && viewModel.readingProgress.chaptersRead == 0 {
                VStack(spacing: 12) {
                    Image(systemName: "clock")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("Nenhuma atividade ainda")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.bookmarks.prefix(3)) { bookmark in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(accentRed.opacity(0.15))
                                .frame(width: 36, height: 36)
                                .overlay {
                                    Image(systemName: "bookmark.fill")
                                        .font(.caption)
                                        .foregroundStyle(accentRed)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Salvou \(bookmark.reference)")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                Text(bookmark.dateAdded, format: .dateTime.day().month(.abbreviated))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("agora")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
