import SwiftUI

struct PremiumGateView: View {
    let icon: String
    let title: String
    let subtitle: String
    @State private var subscriptionManager = SubscriptionManager.shared

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        .radialGradient(
                            colors: [accentRed.opacity(0.15), accentRed.opacity(0.03), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 180, height: 180)

                ZStack {
                    Circle()
                        .fill(accentRed.opacity(0.1))
                        .frame(width: 88, height: 88)
                    Image(systemName: icon)
                        .font(.system(size: 36))
                        .foregroundStyle(accentRed)

                    Image(systemName: "lock.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(accentRed, in: Circle())
                        .offset(x: 28, y: 28)
                }
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button {
                subscriptionManager.showPaywall = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.subheadline)
                    Text("Desbloquear com PRO")
                        .font(.subheadline.bold())
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(accentRed, in: Capsule())
                .shadow(color: accentRed.opacity(0.3), radius: 12, y: 6)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.07, green: 0.07, blue: 0.08))
    }
}
