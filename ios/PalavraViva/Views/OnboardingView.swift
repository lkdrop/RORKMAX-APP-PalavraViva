import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage: Int = 0
    @State private var animateContent: Bool = false

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "book.fill",
            iconColor: Color(red: 0.95, green: 0.3, blue: 0.35),
            title: "Sua Bíblia\nsempre com você",
            subtitle: "Leia, ouça e medite na Palavra de Deus a qualquer momento. Toda a Bíblia em português, gratuita."
        ),
        OnboardingPage(
            icon: "sparkle",
            iconColor: Color(red: 0.6, green: 0.5, blue: 0.9),
            title: "Conheça o\nGabriel",
            subtitle: "Seu companheiro espiritual com IA. Ele conversa, acolhe e compartilha sabedoria bíblica como um amigo de verdade."
        ),
        OnboardingPage(
            icon: "sun.and.horizon.fill",
            iconColor: Color(red: 0.95, green: 0.7, blue: 0.3),
            title: "Devocional\ntodo dia",
            subtitle: "Reflexões diárias, orações guiadas e versículos selecionados para alimentar sua fé todos os dias."
        ),
        OnboardingPage(
            icon: "headphones",
            iconColor: Color(red: 0.4, green: 0.7, blue: 0.6),
            title: "Ouça a\nPalavra",
            subtitle: "Narração em áudio para cada versículo, capítulo e devocional. Perfeito para meditação e momentos de reflexão."
        ),
    ]

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.08)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                pageContent

                Spacer()

                pageIndicator
                    .padding(.bottom, 32)

                actionButton
                    .padding(.horizontal, 28)
                    .padding(.bottom, 16)

                if currentPage < pages.count - 1 {
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("Pular")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 20)
                } else {
                    Spacer().frame(height: 52)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }

    private var pageContent: some View {
        let page = pages[currentPage]

        return VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(
                        .radialGradient(
                            colors: [page.iconColor.opacity(0.2), page.iconColor.opacity(0.05), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)

                ZStack {
                    Circle()
                        .fill(page.iconColor.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Image(systemName: page.icon)
                        .font(.system(size: 40))
                        .foregroundStyle(page.iconColor)
                        .symbolEffect(.breathe)
                }
                .scaleEffect(animateContent ? 1 : 0.5)
                .opacity(animateContent ? 1 : 0)
            }

            VStack(spacing: 14) {
                Text(page.title)
                    .font(.system(.largeTitle, design: .default, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 16)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 12)
            }
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? accentRed : Color(.tertiaryLabel))
                    .frame(width: index == currentPage ? 28 : 8, height: 8)
                    .animation(.snappy(duration: 0.3), value: currentPage)
            }
        }
    }

    private var actionButton: some View {
        let isLast = currentPage == pages.count - 1

        return Button {
            if isLast {
                completeOnboarding()
            } else {
                animateContent = false
                withAnimation(.snappy(duration: 0.3)) {
                    currentPage += 1
                }
                withAnimation(.easeOut(duration: 0.6).delay(0.15)) {
                    animateContent = true
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(isLast ? "Começar" : "Continuar")
                    .font(.headline)
                if !isLast {
                    Image(systemName: "arrow.right")
                        .font(.subheadline.bold())
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(accentRed, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: accentRed.opacity(0.3), radius: 12, y: 6)
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: currentPage)
    }

    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.3)) {
            hasCompletedOnboarding = true
        }
    }
}

nonisolated struct OnboardingPage: Sendable {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
}
