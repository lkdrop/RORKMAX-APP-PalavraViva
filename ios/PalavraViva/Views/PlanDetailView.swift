import SwiftUI

struct PlanDetailView: View {
    let plan: ReadingPlan
    @State private var planProgress = PlanProgressManager.shared
    @State private var selectedDay: Int = 1
    @State private var showDevotional: Bool = false
    @State private var selectedTask: PlanTask?
    @Environment(\.dismiss) private var dismiss

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private var isActive: Bool {
        planProgress.isActive(plan.id)
    }

    private var currentDayData: PlanDay? {
        plan.days.first { $0.dayNumber == selectedDay }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    heroImage

                    daySelector
                        .padding(.top, 16)

                    dayContent
                        .padding(.top, 20)

                    Spacer().frame(height: 100)
                }
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.08))

            bottomButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(plan.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if isActive {
                        Button(role: .destructive) {
                            planProgress.removePlan(plan.id)
                            dismiss()
                        } label: {
                            Label("Abandonar Plano", systemImage: "xmark.circle")
                        }
                    }
                    Button {} label: {
                        Label("Compartilhar", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            if let progress = planProgress.progress(for: plan.id) {
                selectedDay = progress.currentDay
            }
        }
        .sheet(item: $selectedTask) { task in
            NavigationStack {
                PlanReadingView(
                    plan: plan,
                    task: task,
                    dayNumber: selectedDay,
                    totalTasks: currentDayData?.tasks.count ?? 1,
                    taskIndex: (currentDayData?.tasks.firstIndex(where: { $0.id == task.id }) ?? 0) + 1
                )
            }
        }
    }

    private var heroImage: some View {
        Color(red: 0.15, green: 0.13, blue: 0.12)
            .frame(height: 240)
            .overlay {
                AsyncImage(url: URL(string: plan.imageURL ?? plan.category.imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .transition(.opacity.animation(.easeOut(duration: 0.4)))
                    }
                }
                .allowsHitTesting(false)
            }
            .overlay {
                LinearGradient(
                    colors: [.black.opacity(0.1), .black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
            }
            .clipShape(.rect(cornerRadius: 16))
            .overlay(alignment: .bottom) {
                VStack(spacing: 8) {
                    Image(systemName: plan.category.icon)
                        .font(.system(size: 32))
                        .foregroundStyle(.white.opacity(0.7))

                    Text(plan.description)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
    }

    private var daySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(plan.days) { day in
                    let isSelected = day.dayNumber == selectedDay
                    let isCompleted = planProgress.allDayTasksCompleted(planId: plan.id, tasks: day.tasks)
                    let startDate = planProgress.progress(for: plan.id)?.startDate ?? Date()
                    let dayDate = Calendar.current.date(byAdding: .day, value: day.dayNumber - 1, to: startDate) ?? Date()

                    Button {
                        withAnimation(.snappy(duration: 0.2)) { selectedDay = day.dayNumber }
                    } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                if isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption2)
                                        .foregroundStyle(accentRed)
                                }
                                if !isCompleted {
                                    Text("\(day.dayNumber)")
                                        .font(.headline.bold())
                                        .foregroundStyle(isSelected ? Color.white : Color.secondary)
                                }
                            }

                            Text(dayDate.formatted(.dateTime.day().month(.abbreviated)))
                                .font(.caption2)
                                .foregroundStyle(isSelected ? Color.white.opacity(0.7) : Color.secondary)
                        }
                        .frame(width: 64, height: 64)
                        .background {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.white, lineWidth: 1.5)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.13, green: 0.13, blue: 0.15))
                            }
                        }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }

    private var dayContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Dia \(selectedDay) de \(plan.totalDays)")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer()

                if isActive {
                    let allDone = currentDayData.map { planProgress.allDayTasksCompleted(planId: plan.id, tasks: $0.tasks) } ?? false
                    Text(allDone ? "Concluído!" : "Em dia!")
                        .font(.caption.bold())
                        .foregroundStyle(allDone ? Color.green : Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            (allDone ? Color.green : Color.white).opacity(0.15),
                            in: Capsule()
                        )
                }
            }

            if let dayData = currentDayData {
                ForEach(dayData.tasks) { task in
                    taskRow(task: task)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func taskRow(task: PlanTask) -> some View {
        let isCompleted = planProgress.isTaskCompleted(planId: plan.id, taskId: task.id)

        return HStack(spacing: 14) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    if isCompleted {
                        planProgress.uncompleteTask(planId: plan.id, taskId: task.id)
                    } else {
                        planProgress.completeTask(planId: plan.id, taskId: task.id)
                    }
                }
            } label: {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isCompleted ? accentRed : .secondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }

            Button {
                selectedTask = task
            } label: {
                HStack(spacing: 0) {
                    Text(task.title)
                        .font(.body)
                        .foregroundStyle(isCompleted ? .secondary : .white)
                        .strikethrough(isCompleted, color: .secondary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 10)
        .sensoryFeedback(.selection, trigger: isCompleted)
    }

    private var bottomButton: some View {
        Button {
            if !isActive {
                planProgress.startPlan(plan)
                selectedDay = 1
            } else if let dayData = currentDayData, let firstIncomplete = dayData.tasks.first(where: { !planProgress.isTaskCompleted(planId: plan.id, taskId: $0.id) }) {
                selectedTask = firstIncomplete
            } else {
                if selectedDay < plan.totalDays {
                    withAnimation {
                        selectedDay += 1
                        planProgress.setCurrentDay(planId: plan.id, day: selectedDay)
                    }
                }
            }
        } label: {
            Text(bottomButtonTitle)
                .font(.body.bold())
                .foregroundStyle(Color(red: 0.07, green: 0.07, blue: 0.08))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.white, in: RoundedRectangle(cornerRadius: 28))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background {
            LinearGradient(
                colors: [Color(red: 0.07, green: 0.07, blue: 0.08).opacity(0), Color(red: 0.07, green: 0.07, blue: 0.08)],
                startPoint: .top,
                endPoint: .center
            )
            .frame(height: 100)
            .allowsHitTesting(false)
        }
    }

    private var bottomButtonTitle: String {
        if !isActive {
            return "Começar o Plano"
        }
        if let dayData = currentDayData, dayData.tasks.allSatisfy({ planProgress.isTaskCompleted(planId: plan.id, taskId: $0.id) }) {
            if selectedDay < plan.totalDays {
                return "Próximo Dia"
            }
            return "Plano Concluído"
        }
        return "Começar a leitura"
    }

    private var categoryGradient: some View {
        let colors: [Color] = {
            switch plan.category {
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

