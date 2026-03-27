import SwiftUI

struct PlanCategoryView: View {
    let category: PlanCategory
    @State private var searchText: String = ""
    @State private var showSearch: Bool = false

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private var plans: [ReadingPlan] {
        let all = ReadingPlanProvider.plans(for: category)
        if searchText.isEmpty { return all }
        return all.filter { $0.title.localizedStandardContains(searchText) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(plans) { plan in
                    NavigationLink(value: plan) {
                        planListRow(plan: plan)
                    }
                    .buttonStyle(.plain)

                    if plan.id != plans.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.06))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.top, 8)
        }
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation { showSearch.toggle() }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                }
            }
        }
        .searchable(text: $searchText, isPresented: $showSearch, prompt: "Buscar planos...")
    }

    private func planListRow(plan: ReadingPlan) -> some View {
        HStack(spacing: 14) {
            Color(red: 0.18, green: 0.16, blue: 0.15)
                .frame(width: 90, height: 90)
                .overlay {
                    AsyncImage(url: URL(string: plan.imageURL ?? plan.category.imageURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .transition(.opacity.animation(.easeOut(duration: 0.3)))
                        }
                    }
                    .allowsHitTesting(false)
                }
                .overlay {
                    Color.black.opacity(0.2).allowsHitTesting(false)
                }
                .overlay {
                    Image(systemName: plan.category.icon)
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {
                Text("\(plan.totalDays) Dias")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(plan.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if plan.rating > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { i in
                            Image(systemName: Double(i) < plan.rating ? "star.fill" : "star")
                                .font(.system(size: 9))
                                .foregroundStyle(accentRed)
                        }
                    }
                }
            }

            Spacer()

            Button {
            } label: {
                Text("Começar")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(Color(red: 0.22, green: 0.22, blue: 0.24), in: Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
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

