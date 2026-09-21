import SwiftUI

/// Workouts screen: AI plan, week summary, filterable history.
struct WorkoutsView: View {

    let telemetry: DailyTelemetry
    private let np = LIFTTheme.screenPadding
    @State private var workouts = Workout.demo
    @State private var filter: Filter = .all
    @State private var appeared = false
    @State private var activeWorkout: Workout?

    enum Filter: String, CaseIterable {
        case all = "All"
        case completed = "Completed"
        case planned = "Planned"
    }

    private var filteredWorkouts: [Workout] {
        switch filter {
        case .all:       return workouts
        case .completed: return workouts.filter { $0.isCompleted }
        case .planned:   return workouts.filter { !$0.isCompleted }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    aiPlanCard.reveal(appeared)

                    weekSummaryRow.reveal(appeared, delay: 0.05)

                    filterControl.reveal(appeared, delay: 0.10)

                    historySection.reveal(appeared, delay: 0.15)
                }
                .padding(.horizontal, np)
                .padding(.top, 6)
                .padding(.bottom, 32)
            }
            .background(ScreenBackground())
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .onAppear {
            withAnimation(.reveal) { appeared = true }
        }
    }

    // MARK: - AI Plan Card

    private var aiPlanCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 7) {
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(LIFTTheme.electricBlue)

                Text("AI RECOMMENDED TODAY")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(LIFTTheme.electricBlue)

                Spacer()
            }

            Text("Heavy Lower Body")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(LIFTTheme.textPrimary)

            Text("Your recovery is at \(telemetry.recoveryScore)% — perfect conditions for squats and deadlifts. 4 compound exercises, progressive overload included.")
                .font(.system(size: 13))
                .foregroundStyle(LIFTTheme.textSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                statPill(icon: "clock", text: "52 min")
                statPill(icon: "flame.fill", text: "430 kcal")
                statPill(icon: "dumbbell.fill", text: "6 exercises")
            }

            Button {
                activeWorkout = workouts.first(where: { !$0.isCompleted })
            } label: {
                HStack(spacing: 6) {
                    Text("Start Workout")
                        .font(.system(size: 15, weight: .semibold))

                    Image(systemName: "play.fill")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(LIFTTheme.electricBlue)
                )
            }
            .buttonStyle(.plain)
        }
        .sheet(item: $activeWorkout) { workout in
            WorkoutSessionView(workout: workout)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LIFTTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.clear, lineWidth: 0)
        )
    }

    private struct WorkoutSessionView: View {
        let workout: Workout
        @Environment(\.dismiss) private var dismiss
        @State private var isComplete = false

        var body: some View {
            NavigationStack {
                VStack(spacing: 24) {
                    Image(systemName: workout.icon)
                        .font(.system(size: 52))
                        .foregroundStyle(workout.accent.color)

                    Text(workout.title)
                        .font(.title2.bold())

                    Text(workout.subtitle)
                        .foregroundStyle(.secondary)

                    Button(isComplete ? "Done" : "Finish Workout") {
                        if isComplete {
                            dismiss()
                        } else {
                            withAnimation(.reveal) {
                                isComplete = true
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .navigationTitle("Workout")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    private func statPill(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundStyle(LIFTTheme.textPrimary.opacity(0.85))
        .padding(.horizontal, 4)
    }

    // MARK: - Week Summary

    private var weekSummaryRow: some View {
        HStack(spacing: 10) {
            summaryBlock(value: "4", label: "Workouts", icon: "checkmark.circle.fill", accent: .emerald)
            summaryBlock(value: "2h 17m", label: "Time", icon: "clock.fill", accent: .blue)
            summaryBlock(value: telemetry.caloriesText, label: "Kcal", icon: "flame.fill", accent: .orange)
        }
    }

    private func summaryBlock(value: String, label: String, icon: String, accent: Accent) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(accent.color)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(LIFTTheme.textPrimary)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(LIFTTheme.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LIFTTheme.mutedSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(LIFTTheme.cardStroke.opacity(0.6), lineWidth: 1)
        )
    }

    // MARK: - Filter

    private var filterControl: some View {
        Picker("Filter", selection: $filter) {
            ForEach(Filter.allCases, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Recent")

            VStack(spacing: 10) {
                ForEach(filteredWorkouts) { workout in
                    workoutRow(workout)
                }

                if filteredWorkouts.isEmpty {
                    emptyState
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 22))
                .foregroundStyle(LIFTTheme.textTertiary)
            Text("Nothing here yet")
                .font(.system(size: 13))
                .foregroundStyle(LIFTTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
    }

    private func workoutRow(_ workout: Workout) -> some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(workout.accent.color.opacity(0.15))
                .frame(width: 46, height: 46)
                .overlay(
                    Image(systemName: workout.icon)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(workout.accent.color)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(workout.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(LIFTTheme.textPrimary)

                Text(workout.subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(LIFTTheme.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(workout.duration)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(LIFTTheme.textPrimary.opacity(0.85))

                if workout.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(LIFTTheme.emerald)
                } else {
                    Text("Planned")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(LIFTTheme.electricBlue)
                }
            }
        }
        .padding(12)
        .surface(cornerRadius: 10)
    }
}

// MARK: - Preview

#Preview {
    WorkoutsView(telemetry: .demo)
}