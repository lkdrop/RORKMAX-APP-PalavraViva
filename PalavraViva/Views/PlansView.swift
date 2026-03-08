import SwiftUI

struct PlansView: View {
    @State private var selectedFilter: Int = 1
    @State private var planProgress = PlanProgressManager.shared
    @State private var searchText: String = ""

    private let filters = ["Meus Planos", "Explorar", "Salvos", "Concluídos"]
    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private let featuredPlans: [ReadingPlan] = {
        let all = PlanCategory.allCases.flatMap { ReadingPlanProvider.plans(for: $0) }
        return Array(all.filter { $0.rating >= 4.9 }.prefix(5))
    }()

    private let topicTags = ["Novo", "Relacionamentos", "Louvor", "Família", "Juventude", "Mulheres", "Homens"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar

                ScrollView {
                    VStack(spacing: 24) {
                        switch selectedFilter {
                        case 0:
                            myPlansContent
                        case 1:
                            explorePlansContent
                        default:
                            emptyStateContent
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))
            .navigationDestination(for: PlanCategory.self) { category in
                PlanCategoryView(category: category)
            }
            .navigationDestination(for: ReadingPlan.self) { plan in
                PlanDetailView(plan: plan)
            }
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

    private var explorePlansContent: some View {
        VStack(spacing: 28) {
            featuredSection

            categoryGrid

            topicTagsSection

            popularSection
        }
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Destaques")
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(featuredPlans) { plan in
                        NavigationLink(value: plan) {
                            featuredCard(plan: plan)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
        }
    }

    private func featuredCard(plan: ReadingPlan) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Color(red: 0.18, green: 0.16, blue: 0.14)
                    .frame(height: 180)
                    .overlay {
                        categoryGradient(for: plan.category)
                            .allowsHitTesting(false)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: plan.category.icon)
                            .font(.system(size: 50))
                            .foregroundStyle(.white.opacity(0.12))
                            .padding(16)
                    }
                    .overlay(alignment: .topLeading) {
                        Text("\(plan.totalDays) Dias")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial, in: Capsule())
                            .padding(12)
                    }
                    .clipShape(.rect(cornerRadius: 14))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(plan.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: Double(i) < plan.rating ? "star.fill" : "star")
                            .font(.system(size: 9))
                            .foregroundStyle(accentRed)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 2)
        }
        .frame(width: 260)
    }

    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Categorias")
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(PlanCategory.allCases, id: \.rawValue) { category in
                    NavigationLink(value: category) {
                        VStack(spacing: 8) {
                            Image(systemName: category.icon)
                                .font(.title3)
                                .foregroundStyle(.white)
                            Text(category.rawValue)
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background {
                            categoryGradient(for: category)
                        }
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
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

    private var popularSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Populares")
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            let popular = PlanCategory.allCases.flatMap { ReadingPlanProvider.plans(for: $0) }.filter { $0.rating >= 4.9 }.prefix(8)

            ForEach(Array(popular)) { plan in
                NavigationLink(value: plan) {
                    planRow(plan: plan)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func planRow(plan: ReadingPlan) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.18, green: 0.16, blue: 0.15))
                    .frame(width: 80, height: 80)
                    .overlay {
                        categoryGradient(for: plan.category)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                Image(systemName: plan.category.icon)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("\(plan.totalDays) Dias")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(plan.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: Double(i) < plan.rating ? "star.fill" : "star")
                            .font(.system(size: 8))
                            .foregroundStyle(accentRed)
                    }
                }
            }

            Spacer()

            Button {
            } label: {
                Text("Iniciar")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(Color(red: 0.22, green: 0.22, blue: 0.24), in: Capsule())
            }
        }
        .padding(.horizontal, 16)
    }

    private var myPlansContent: some View {
        Group {
            let activeIds = Array(planProgress.activePlans.keys)
            if activeIds.isEmpty {
                emptyMyPlans
            } else {
                VStack(spacing: 16) {
                    let allPlans = PlanCategory.allCases.flatMap { ReadingPlanProvider.plans(for: $0) }
                    ForEach(activeIds, id: \.self) { planId in
                        if let plan = allPlans.first(where: { $0.id == planId }),
                           let progress = planProgress.progress(for: planId) {
                            NavigationLink(value: plan) {
                                activePlanRow(plan: plan, progress: progress)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }

    private func activePlanRow(plan: ReadingPlan, progress: ActivePlanProgress) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.18, green: 0.16, blue: 0.15))
                    .frame(width: 80, height: 80)
                    .overlay {
                        categoryGradient(for: plan.category)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                Image(systemName: plan.category.icon)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.square")
                        .font(.caption2)
                    Text("Dia \(progress.currentDay) de \(plan.totalDays)")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)

                Text(plan.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                ProgressView(value: Double(progress.currentDay - 1), total: Double(plan.totalDays))
                    .tint(accentRed)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private var emptyMyPlans: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 60)
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
                Text("Explorar Planos")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(accentRed, in: Capsule())
            }
        }
    }

    private var emptyStateContent: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 60)
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

    private func categoryGradient(for category: PlanCategory) -> some View {
        let colors: [Color] = {
            switch category {
            case .amor: return [Color(red: 0.91, green: 0.28, blue: 0.33), Color(red: 0.78, green: 0.16, blue: 0.22)]
            case .cura: return [Color(red: 0.36, green: 0.66, blue: 0.55), Color(red: 0.24, green: 0.48, blue: 0.38)]
            case .esperanca: return [Color(red: 0.96, green: 0.64, blue: 0.38), Color(red: 0.88, green: 0.48, blue: 0.23)]
            case .ansiedade: return [Color(red: 0.48, green: 0.41, blue: 0.68), Color(red: 0.35, green: 0.29, blue: 0.54)]
            case .raiva: return [Color(red: 0.84, green: 0.25, blue: 0.27), Color(red: 0.64, green: 0.19, blue: 0.21)]
            case .depressao: return [Color(red: 0.42, green: 0.48, blue: 0.58), Color(red: 0.29, green: 0.33, blue: 0.41)]
            case .fe: return [Color(red: 0.83, green: 0.63, blue: 0.35), Color(red: 0.72, green: 0.53, blue: 0.18)]
            case .familia: return [Color(red: 0.31, green: 0.8, blue: 0.77), Color(red: 0.21, green: 0.7, blue: 0.67)]
            case .oracao: return [Color(red: 0.61, green: 0.49, blue: 0.85), Color(red: 0.48, green: 0.37, blue: 0.72)]
            }
        }()
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension ReadingPlan: Hashable {
    nonisolated static func == (lhs: ReadingPlan, rhs: ReadingPlan) -> Bool {
        lhs.id == rhs.id
    }
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


