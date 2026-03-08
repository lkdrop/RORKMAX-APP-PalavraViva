import SwiftUI

@main
struct PalavraVivaApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
