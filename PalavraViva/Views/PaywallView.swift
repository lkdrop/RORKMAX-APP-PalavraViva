import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PlanType = .annual
    @State private var animateFeatures: Bool = false
    @State private var subscriptionManager = SubscriptionManager.shared

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    nonisolated enum PlanType: String, CaseIterable {
        case monthly
        case annual
    }

    private let features: [(icon: String, title: String, description: String)] = [
        ("sparkle", "Gabriel IA", "Seu companheiro espiritual pessoal com inteligência artificial"),
        ("sun.and.horizon.fill", "Devocional Diário", "Reflexões e orações exclusivas todos os dias"),
        ("speaker.wave.2.fill", "Narração em Áudio", "Ouça a Bíblia e devocional com voz natural"),
        ("bookmark.fill", "Marcadores", "Salve e organize seus versículos favoritos"),
        ("chart.bar.fill", "Estatísticas", "Acompanhe seu progresso de leitura detalhado"),
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    featuresSection
                    planSelector
                    ctaButton
                    legalSection
                }
                .padding(.bottom, 40)
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                animateFeatures = true
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        .radialGradient(
                            colors: [accentRed.opacity(0.25), accentRed.opacity(0.05), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)

                ZStack {
                    Circle()
                        .fill(accentRed)
                        .frame(width: 80, height: 80)
                        .shadow(color: accentRed.opacity(0.4), radius: 20, y: 8)

                    Image(systemName: "crown.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                        .symbolEffect(.breathe)
                }
            }
            .padding(.top, 40)

            VStack(spacing: 8) {
                Text("Palavra Viva")
                    .font(.system(.title2, design: .default, weight: .bold))
                    .foregroundStyle(.white)
                HStack(spacing: 6) {
                    Text("PRO")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(accentRed, in: Capsule())
                }
            }

            Text("Desbloqueie toda a experiência espiritual")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var featuresSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(accentRed.opacity(0.1))
                            .frame(width: 44, height: 44)
                        Image(systemName: feature.icon)
                            .font(.body.bold())
                            .foregroundStyle(accentRed)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(feature.title)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        Text(feature.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(accentRed)
                        .font(.body)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .opacity(animateFeatures ? 1 : 0)
                .offset(x: animateFeatures ? 0 : 20)
                .animation(.spring(duration: 0.5, bounce: 0.3).delay(Double(index) * 0.08), value: animateFeatures)

                if index < features.count - 1 {
                    Divider()
                        .padding(.leading, 84)
                }
            }
        }
        .padding(.vertical, 20)
    }

    private var planSelector: some View {
        VStack(spacing: 12) {
            planCard(
                type: .annual,
                title: "Anual",
                price: "R$ 99,90",
                period: "/ano",
                savings: "Economize 50%",
                pricePerMonth: "R$ 8,33/mês"
            )

            planCard(
                type: .monthly,
                title: "Mensal",
                price: "R$ 16,90",
                period: "/mês",
                savings: nil,
                pricePerMonth: nil
            )
        }
        .padding(.horizontal, 24)
    }

    private func planCard(type: PlanType, title: String, price: String, period: String, savings: String?, pricePerMonth: String?) -> some View {
        let isSelected = selectedPlan == type

        return Button {
            withAnimation(.spring(duration: 0.3)) {
                selectedPlan = type
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? accentRed : Color(.tertiaryLabel), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(accentRed)
                            .frame(width: 14, height: 14)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        if let savings {
                            Text(savings)
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.green, in: Capsule())
                        }
                    }
                    if let pricePerMonth {
                        Text(pricePerMonth)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(price)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(period)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.14))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(isSelected ? accentRed : .clear, lineWidth: 2)
                    }
            }
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedPlan)
    }

    private var ctaButton: some View {
        Button {
            subscriptionManager.unlock()
            dismiss()
        } label: {
            Text("Começar Agora")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(accentRed, in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: accentRed.opacity(0.3), radius: 12, y: 6)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    private var legalSection: some View {
        VStack(spacing: 8) {
            Button("Restaurar Compras") {
                subscriptionManager.unlock()
                dismiss()
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(.secondary)

            Text("Cancele quando quiser. Sem compromisso.")
                .font(.caption2)
                .foregroundStyle(.quaternary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
        .padding(.horizontal, 32)
    }
}
