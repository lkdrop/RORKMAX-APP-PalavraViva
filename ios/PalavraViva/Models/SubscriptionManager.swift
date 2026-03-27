import SwiftUI

@Observable
@MainActor
class SubscriptionManager {
    static let shared = SubscriptionManager()

    var isPremium: Bool = false
    var showPaywall: Bool = false

    private init() {
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
    }

    func unlock() {
        isPremium = true
        UserDefaults.standard.set(true, forKey: "isPremium")
    }

    func lock() {
        isPremium = false
        UserDefaults.standard.set(false, forKey: "isPremium")
    }

    func requirePremium() -> Bool {
        if isPremium { return true }
        showPaywall = true
        return false
    }
}
