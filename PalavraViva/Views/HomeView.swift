import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: BibleViewModel
    @State private var selectedHomeTab: Int = 0
    @State private var animateVerse: Bool = false
    @State private var navigateToReader: Bool = false
    @State private var audioService = AudioService()
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var showGabriel: Bool = false
    @State private var showDailyReminder: Bool = false
    @State private var isLiked: Bool = false

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Bom dia"
        case 12..<18: return "Boa tarde"
        default: return "Boa noite"
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerBar

                ScrollView {
                    VStack(spacing: 16) {
                        if selectedHomeTab == 0 {
                            todayContent
                        } else {
                            communityContent
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
            .navigationDestination(isPresented: $navigateToReader) {
                ChapterReaderView(viewModel: viewModel)
            }
            .sheet(isPresented: $showGabriel) {
                NavigationStack {
                    GabrielChatView()
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                    animateVerse = true
                }
            }
        }
    }

    private var headerBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                HStack(spacing: 24) {
                    Button {
                        withAnimation(.snappy(duration: 0.25)) { selectedHomeTab = 0 }
                    } label: {
                        VStack(spacing: 6) {
                            Text("Hoje")
                                .font(.title2.bold())
                                .foregroundStyle(selectedHomeTab == 0 ? .white : .secondary)
                            Rectangle()
                                .fill(selectedHomeTab == 0 ? Color(red: 0.95, green: 0.3, blue: 0.35) : .clear)
                                .frame(height: 2)
                        }
                    }

                    Button {
                        withAnimation(.snappy(duration: 0.25)) { selectedHomeTab = 1 }
                    } label: {
                        VStack(spacing: 6) {
                            Text("Comunidade")
                                .font(.title2.bold())
                                .foregroundStyle(selectedHomeTab == 1 ? .white : .secondary)
                            Rectangle()
                                .fill(selectedHomeTab == 1 ? Color(red: 0.95, green: 0.3, blue: 0.35) : .clear)
                                .frame(height: 2)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        showGabriel = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bolt.fill")
                                .font(.body)
                                .foregroundStyle(.white)
                            Text("1")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(3)
                                .background(Color(red: 0.95, green: 0.3, blue: 0.35), in: Circle())
                                .offset(x: 8, y: -6)
                        }
                    }

                    Button {} label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(.body)
                                .foregroundStyle(.white)
                            Circle()
                                .fill(Color(red: 0.95, green: 0.3, blue: 0.35))
                                .frame(width: 8, height: 8)
                                .offset(x: 2, y: -2)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private var todayContent: some View {
        VStack(spacing: 16) {
            greetingSection
            tipCard
            guidedPrayerCard
            verseOfDayCard
            guidedReadingCard
            activePlanCards
            devotionalCard
            continueReadingCard
            streakSection
            welcomeCard
        }
    }

    private var greetingSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(greeting)!")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                if viewModel.readingStreak.currentStreak > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("\(viewModel.readingStreak.currentStreak) dias de sequência")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var tipCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Você consegue!")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                Text("Confira estas quatro dicas para concluir seu Plano de Estudo Bíblico.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)

                HStack(spacing: 16) {
                    Button {} label: {
                        Text("Confira")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    }
                    Button {} label: {
                        Text("Descartar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 4)
            }

            Spacer()

            LazyVGrid(columns: [GridItem(.fixed(28), spacing: 4), GridItem(.fixed(28), spacing: 4)], spacing: 4) {
                Image(systemName: "text.book.closed.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color(red: 0.95, green: 0.5, blue: 0.3), in: RoundedRectangle(cornerRadius: 6))
                Image(systemName: "forward.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color(red: 0.95, green: 0.5, blue: 0.3), in: RoundedRectangle(cornerRadius: 6))
                Image(systemName: "speaker.wave.2.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color(red: 0.95, green: 0.5, blue: 0.3), in: RoundedRectangle(cornerRadius: 6))
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color(red: 0.95, green: 0.5, blue: 0.3), in: RoundedRectangle(cornerRadius: 6))
            }
            .frame(width: 64)
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private var guidedPrayerCard: some View {
        Button {
            if subscriptionManager.isPremium {
                showGabriel = true
            } else {
                subscriptionManager.showPaywall = true
            }
        } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Oração Guiada")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Sua amizade com Deus se desenvolve com a conversa.")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .lineSpacing(2)
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 8))
                        Text("4–6 minutos")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.55, green: 0.4, blue: 0.35), Color(red: 0.4, green: 0.3, blue: 0.28)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    Image(systemName: "hands.sparkles")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(16)
            .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private var verseOfDayCard: some View {
        let daily = viewModel.dailyVerse
        return VStack(alignment: .leading, spacing: 14) {
            Text("Versículo do Dia")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))

            Text(daily.reference)
                .font(.title3.bold())
                .foregroundStyle(.white)

            Text("\u{201C}\(daily.verse.text)\u{201D}")
                .font(.system(.body, design: .serif))
                .foregroundStyle(.white.opacity(0.9))
                .lineSpacing(6)
                .opacity(animateVerse ? 1 : 0)
                .offset(y: animateVerse ? 0 : 8)

            HStack(spacing: 24) {
                Button {
                    withAnimation(.spring(duration: 0.3)) { isLiked.toggle() }
                } label: {
                    actionButton(icon: isLiked ? "heart.fill" : "heart", count: "323,4 mil", highlighted: isLiked)
                }
                actionButton(icon: "bubble.right", count: "5.877")
                actionButton(icon: "square.and.arrow.up", count: "92,3 mil")
                
                Spacer()
                
                Button {
                    if subscriptionManager.isPremium {
                        audioService.speak(daily.verse.text)
                    } else {
                        subscriptionManager.showPaywall = true
                    }
                } label: {
                    Image(systemName: audioService.isSpeakingText(daily.verse.text) ? "pause.fill" : "speaker.wave.2")
                        .font(.caption)
                        .foregroundStyle(audioService.isSpeakingText(daily.verse.text) ? Color(red: 0.95, green: 0.3, blue: 0.35) : .white.opacity(0.6))
                }
            }
            .padding(.top, 4)

            HStack(spacing: 10) {
                Button {
                    showDailyReminder = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.caption)
                        Text("Envie-me Diariamente")
                            .font(.caption.bold())
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.white, in: Capsule())
                }

                Button {} label: {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .frame(width: 36, height: 36)
                        .background(Color(red: 0.2, green: 0.18, blue: 0.16), in: Circle())
                }
            }
        }
        .padding(20)
        .background {
            ZStack {
                Color(red: 0.15, green: 0.12, blue: 0.1)
                LinearGradient(
                    colors: [Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.6), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .clipShape(.rect(cornerRadius: 16))
        }
        .padding(.horizontal, 16)
        .sensoryFeedback(.selection, trigger: isLiked)
    }

    private func actionButton(icon: String, count: String, highlighted: Bool = false) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(highlighted ? Color(red: 0.95, green: 0.3, blue: 0.35) : .white.opacity(0.6))
            Text(count)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.5))
        }
    }

    private var guidedReadingCard: some View {
        Button {
            if let psalms = viewModel.bibleService.getBook(id: "psa") {
                viewModel.selectBook(psalms)
                viewModel.selectedChapterNumber = 23
                navigateToReader = true
            }
        } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "flame")
                            .font(.caption2)
                        Text("0")
                            .font(.caption.bold())
                    }
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.2, green: 0.2, blue: 0.22), in: Capsule())

                    Text("Leitura Guiada")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Sabedoria e Amor")
                        .font(.headline)
                        .foregroundStyle(.white)
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.caption2)
                        Text("2–5 minutos")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.25, green: 0.2, blue: 0.18))
                        .frame(width: 80, height: 80)
                    Image(systemName: "book.and.wrench")
                        .font(.title2)
                        .foregroundStyle(Color(red: 0.85, green: 0.65, blue: 0.35))
                }
            }
            .padding(16)
            .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private var activePlanCards: some View {
        VStack(spacing: 12) {
            ForEach(activePlans, id: \.title) { plan in
                Button {} label: {
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.square")
                                    .font(.caption2)
                                Text("Dia \(plan.currentDay)")
                                    .font(.caption)
                            }
                            .foregroundStyle(.secondary)

                            Text(plan.title)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .lineLimit(2)
                        }

                        Spacer()

                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(plan.color)
                                .frame(width: 72, height: 72)
                            Image(systemName: plan.icon)
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding(16)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private var activePlans: [ActivePlan] {
        [
            ActivePlan(title: "Entre os Anjos", currentDay: 3, icon: "sparkles", color: Color(red: 0.3, green: 0.25, blue: 0.6)),
            ActivePlan(title: "Entre os Anjos", currentDay: 3, icon: "sparkles", color: Color(red: 0.3, green: 0.25, blue: 0.6)),
        ]
    }

    private var devotionalCard: some View {
        Group {
            if subscriptionManager.isPremium {
                DevotionalCardView(devotional: DevotionalProvider.todaysDevotional())
                    .padding(.horizontal, 16)
            } else {
                Button {
                    subscriptionManager.showPaywall = true
                } label: {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Devocional do Dia")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(DevotionalProvider.todaysDevotional().title)
                                .font(.headline)
                                .foregroundStyle(.white)
                            HStack(spacing: 6) {
                                Image(systemName: "crown.fill")
                                    .font(.caption2)
                                    .foregroundStyle(Color(red: 0.95, green: 0.3, blue: 0.35))
                                Text("Premium")
                                    .font(.caption)
                                    .foregroundStyle(Color(red: 0.95, green: 0.3, blue: 0.35))
                            }
                        }
                        Spacer()
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
            }
        }
    }

    private var continueReadingCard: some View {
        let lastBookName = viewModel.readingProgress.lastBookName ?? "Gênesis"
        let lastChapter = viewModel.readingProgress.lastChapterNumber ?? 1
        let lastBookId = viewModel.readingProgress.lastBookId ?? "gen"

        return Button {
            if let book = viewModel.bibleService.getBook(id: lastBookId) {
                viewModel.selectedBook = book
                viewModel.selectedChapterNumber = lastChapter
                navigateToReader = true
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.95, green: 0.3, blue: 0.35).opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: "book.fill")
                        .font(.title3)
                        .foregroundStyle(Color(red: 0.95, green: 0.3, blue: 0.35))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Continuar Leitura")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(lastBookName) \(lastChapter)")
                        .font(.headline)
                        .foregroundStyle(.white)
                }

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color(red: 0.95, green: 0.3, blue: 0.35))
            }
            .padding(16)
            .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Medalhas")
                .font(.headline)
                .foregroundStyle(.white)

            HStack(spacing: 16) {
                medalItem(
                    icon: "flame.fill",
                    value: "\(viewModel.readingStreak.currentStreak)",
                    label: "Perseverança",
                    color: .orange
                )
                medalItem(
                    icon: "book.closed.fill",
                    value: "\(viewModel.readingProgress.chaptersRead)",
                    label: "Capítulos",
                    color: Color(red: 0.95, green: 0.3, blue: 0.35)
                )
                medalItem(
                    icon: "trophy.fill",
                    value: "\(viewModel.readingStreak.longestStreak)",
                    label: "Recorde",
                    color: .yellow
                )
            }

            Button {} label: {
                Text("Ver Todos")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.2, green: 0.2, blue: 0.22), in: Capsule())
            }
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private func medalItem(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
            }
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var welcomeCard: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Bem-vindo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Vamos explorar quatro maneiras pelas quais você pode se conectar com a Bíblia.")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineSpacing(2)

                HStack {
                    Button {} label: {
                        Text("Continuar")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.22), in: Capsule())
                    }
                    Spacer()
                    Text("1 / 4")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ZStack {
                Circle()
                    .fill(Color(red: 0.35, green: 0.15, blue: 0.2))
                    .frame(width: 64, height: 64)
                Image(systemName: "sun.max.fill")
                    .font(.title2)
                    .foregroundStyle(Color(red: 0.95, green: 0.3, blue: 0.35))
            }
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private var communityContent: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 20)

            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fique cercado\nde Amigos")
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        Text("A Bíblia é clara: Nós precisamos de amigos – para nos encorajar, inspirar, desafiar e amar. E seus amigos precisam de você também.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.22))
                            .frame(width: 56, height: 56)
                        Image(systemName: "person.3.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }

                Button {} label: {
                    Text("+ Amigos")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.15), in: Capsule())
                }
            }
            .padding(20)
            .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
        }
    }
}

struct ActivePlan {
    let title: String
    let currentDay: Int
    let icon: String
    let color: Color
}

struct QuickBookCard: View {
    let name: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Color(red: 0.95, green: 0.3, blue: 0.35))

                VStack(alignment: .leading, spacing: 3) {
                    Text(name)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 110, alignment: .leading)
            .padding(14)
            .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
