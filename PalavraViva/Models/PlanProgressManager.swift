import SwiftUI

@Observable
@MainActor
class PlanProgressManager {
    static let shared = PlanProgressManager()

    var activePlans: [String: ActivePlanProgress] = [:]

    private let storageKey = "activePlanProgress"

    private init() {
        loadProgress()
    }

    func startPlan(_ plan: ReadingPlan) {
        let progress = ActivePlanProgress(
            planId: plan.id,
            currentDay: 1,
            completedTasks: [],
            startDate: Date()
        )
        activePlans[plan.id] = progress
        saveProgress()
    }

    func isActive(_ planId: String) -> Bool {
        activePlans[planId] != nil
    }

    func progress(for planId: String) -> ActivePlanProgress? {
        activePlans[planId]
    }

    func completeTask(planId: String, taskId: String) {
        guard var progress = activePlans[planId] else { return }
        if !progress.completedTasks.contains(taskId) {
            progress.completedTasks.append(taskId)
            activePlans[planId] = progress
            saveProgress()
        }
    }

    func uncompleteTask(planId: String, taskId: String) {
        guard var progress = activePlans[planId] else { return }
        progress.completedTasks.removeAll { $0 == taskId }
        activePlans[planId] = progress
        saveProgress()
    }

    func isTaskCompleted(planId: String, taskId: String) -> Bool {
        activePlans[planId]?.completedTasks.contains(taskId) ?? false
    }

    func setCurrentDay(planId: String, day: Int) {
        guard var progress = activePlans[planId] else { return }
        progress.currentDay = day
        activePlans[planId] = progress
        saveProgress()
    }

    func removePlan(_ planId: String) {
        activePlans.removeValue(forKey: planId)
        saveProgress()
    }

    func allDayTasksCompleted(planId: String, tasks: [PlanTask]) -> Bool {
        guard let progress = activePlans[planId] else { return false }
        return tasks.allSatisfy { progress.completedTasks.contains($0.id) }
    }

    private func saveProgress() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(activePlans) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        let decoder = JSONDecoder()
        if let loaded = try? decoder.decode([String: ActivePlanProgress].self, from: data) {
            activePlans = loaded
        }
    }
}

nonisolated struct ActivePlanProgress: Codable, Sendable {
    let planId: String
    var currentDay: Int
    var completedTasks: [String]
    let startDate: Date
}
