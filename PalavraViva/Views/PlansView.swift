import SwiftUI

struct PlansView: View {
    @State private var selectedFilter: Int = 1
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var featuredIndex: Int = 0

    private let filters = ["Meus Planos", "Encontrar Planos", "Salvo", "Concluídos"]
    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private let categories: [(name: String, color: Color)] = [
        ("AMOR", Color(red: 0.9, green: 0.3, blue: 0.35)),
        ("CURA", Color(red: 0.95, green: 0.25, blue: 0.25)),
        ("ESPERANÇA", Color(red: 0.3, green: 0.7, blue: 0.5)),
        ("ANSIEDADE", Color(red: 0.85, green: 0.5, blue: 0.2)),
        ("RAIVA", Color(red: 0.6, green: 0.2, blue: 0.2)),
        ("DEPRESSÃO", Color(red: 0.4, green: 0.35, blue: 0.6)),
    ]

    private let topicTags = ["Novo", "Relacionamentos", "Ouça e Assista", "Família", "Juventude"]

    private let featuredPlans: [PlanItem] = [
        PlanItem(title: "Ainda Não É o Fim – 30 Dias para Redescobrir o Autor da Sua História", days: 30, icon: "book.pages"),
        PlanItem(title: "Bíblia em Um Ano", days: 365, icon: "calendar"),
        PlanItem(title: "Renovando Sua Mente", days: 21, icon: "brain.head.profile"),
    ]

    private let sectionPlans: [(section: String, plans: [PlanItem])] = [
        ("Quaresma & Páscoa", [
            PlanItem(title: "Seguindo os Últimos Passos de Jesus", days: 10, icon: "figure.walk"),
            PlanItem(title: "Das Feridas Abertas Às Cicatrizes De Esperança", days: 4, icon: "heart.circle"),
            PlanItem(title: "A Cruz e o Amor De Deus", days: 4, icon: "cross"),
        ]),
        ("João", [
            PlanItem(title: "Jesus: A Verdadeira Luz do Mundo", days: 7, icon: "sun.max.fill"),
            PlanItem(title: "João", days: 10, icon: "person.fill"),
            PlanItem(title: "O Maior Amor Que Existe", days: 4, icon: "heart.fill"),
        ]),
        ("Novo na Fé", [
            PlanItem(title: "Primeiros Passos com Deus", days: 15, icon: "figure.walk"),
            PlanItem(title: "Entendendo a Bíblia", days: 7, icon: "book.fill"),
            PlanItem(title: "Oração para Iniciantes", days: 5, icon: "hands.sparkles"),
        ]),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar

                ScrollView {
                    VStack(spacing: 24) {
                        if selectedFilter == 1 {
                            findPlansContent
                        } else if selectedFilter == 0 {
                            myPlansContent
                        } else {
                            emptyFilterContent
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(filters.enumerated()), id: \.offset) { index, filter in
                    Button {
                        withAnimation(.snappy(duration: 0.25)) { selectedFilter = index }
                    } label: {
                        Text(filter)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(selectedFilter == index ? .white : .secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background {
                                if selectedFilter == index {
                                    Capsule().fill(Color(red: 0.2, green: 0.2, blue: 0.22))
                                        .overlay {
                                            Capsule().strokeBorder(accentRed.opacity(0.5), lineWidth: 1)
                                        }
                                } else {
                                    Capsule().fill(Color(red: 0.15, green: 0.15, blue: 0.17))
                                }
                            }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var findPlansContent: some View {
        VStack(spacing: 24) {
            featuredCarousel

            categoryChips

            topicTagsSection

            ForEach(sectionPlans, id: \.section) { section in
                planSection(title: section.section, plans: section.plans)
            }
        }
    }

    private var featuredCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(Array(featuredPlans.enumerated()), id: \.offset) { index, plan in
                    Button {} label: {
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .bottomLeading) {
                                Color(red: 0.18, green: 0.16, blue: 0.14)
                                    .frame(height: 200)
                                    .overlay {
                                        ZStack {
                                            featuredGradient(for: index)
                                            VStack {
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    Image(systemName: plan.icon)
                                                        .font(.system(size: 60))
                                                        .foregroundStyle(.white.opacity(0.1))
                                                        .padding(20)
                                                }
                                            }
                                        }
                                        .allowsHitTesting(false)
                                    }
                                    .clipShape(.rect(cornerRadius: 14))
                            }

                            Text(plan.title)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .padding(.top, 10)
                                .padding(.horizontal, 4)
                        }
                        .frame(width: 280)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }

    private func featuredGradient(for index: Int) -> some View {
        let colors: [(Color, Color)] = [
            (Color(red: 0.85, green: 0.75, blue: 0.6), Color(red: 0.6, green: 0.5, blue: 0.35)),
            (Color(red: 0.4, green: 0.5, blue: 0.7), Color(red: 0.25, green: 0.3, blue: 0.5)),
            (Color(red: 0.6, green: 0.35, blue: 0.35), Color(red: 0.4, green: 0.2, blue: 0.2)),
        ]
        let pair = colors[index % colors.count]
        return LinearGradient(
            colors: [pair.0, pair.1],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var categoryChips: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            ForEach(categories, id: \.name) { category in
                Button {} label: {
                    Text(category.name)
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(category.color, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var topicTagsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(topicTags, id: \.self) { tag in
                    Button {} label: {
                        Text(tag)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: Capsule())
                    }
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }

    private func planSection(title: String, plans: [PlanItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Spacer()
                Button {} label: {
                    HStack(spacing: 4) {
                        Text("Ver Todos")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)

            ForEach(plans, id: \.title) { plan in
                planRow(plan: plan)
            }
        }
    }

    private func planRow(plan: PlanItem) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.18, green: 0.16, blue: 0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: plan.icon)
                    .font(.title3)
                    .foregroundStyle(accentRed)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(plan.days) Dias")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(plan.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(accentRed)
                    }
                }
            }

            Spacer()

            Button {} label: {
                Text("Começar")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.2, green: 0.2, blue: 0.22), in: Capsule())
            }
        }
        .padding(.horizontal, 16)
    }

    private var myPlansContent: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            Image(systemName: "checkmark.square")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Nenhum plano ativo")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Encontre planos de leitura para\ncrescer na sua fé.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                withAnimation { selectedFilter = 1 }
            } label: {
                Text("Encontrar Planos")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(accentRed, in: Capsule())
            }
        }
    }

    private var emptyFilterContent: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            Image(systemName: "bookmark")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Nada aqui ainda")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Salve ou complete planos para\nvê-los aqui.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

nonisolated struct PlanItem: Sendable {
    let title: String
    let days: Int
    let icon: String
}
