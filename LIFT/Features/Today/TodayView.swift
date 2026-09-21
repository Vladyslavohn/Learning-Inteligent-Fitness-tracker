import SwiftUI

/// Main "Today" screen: greeting, recovery hero, LIFT card, sleep & weekly activity.
struct TodayView: View {

    let telemetry: DailyTelemetry
    @Environment(\.openWorkoutPlan) private var openWorkoutPlan
    private let np = LIFTTheme.screenPadding

    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    headerGreeting.reveal(appeared)

                    recoveryHero.reveal(appeared, delay: 0.05)

                    LIFTCardView(telemetry: telemetry, openWorkoutPlan: openWorkoutPlan)
                        .reveal(appeared, delay: 0.10)

                    sleepCard.reveal(appeared, delay: 0.15)

                    weeklyActivityCard.reveal(appeared, delay: 0.20)
                }
                .padding(.horizontal, np)
                .padding(.top, 6)
                .padding(.bottom, 32)
            }
            .background(ScreenBackground())
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            withAnimation(reduceMotion ? nil : .reveal) { appeared = true }
        }
    }

    // MARK: - Greeting

    private var headerGreeting: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(greetingText)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(LIFTTheme.textSecondary)

            Text("Hey, \(telemetry.userName)")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(LIFTTheme.textPrimary)
        }
        .padding(.top, 6)
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning"
        case 12..<18: return "Good afternoon"
        default:      return "Good evening"
        }
    }

    // MARK: - Recovery Hero

    private var recoveryHero: some View {
        VStack(spacing: 18) {
            HStack(spacing: 18) {
                ZStack {
                    ActivityRingView(
                        progress: Double(telemetry.recoveryScore) / 100,
                        accent: .emerald,
                        lineWidth: 9
                    )
                    .frame(width: 76, height: 76)

                    VStack(spacing: 0) {
                        Text("\(telemetry.recoveryScore)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(LIFTTheme.textPrimary)
                            .contentTransition(.numericText())
                            .animation(.smooth(duration: 0.5), value: telemetry.recoveryScore)

                        Text("%")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(LIFTTheme.textSecondary)
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(telemetry.recoveryLabel)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(LIFTTheme.textPrimary)

                    HStack(spacing: 5) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10, weight: .bold))
                        Text("HRV +\(telemetry.hrvChangePercent)%")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(LIFTTheme.emerald)
                    .padding(.vertical, 2)

                    Text("vs. 7-day baseline")
                        .font(.system(size: 11))
                        .foregroundStyle(LIFTTheme.textTertiary)
                }

                Spacer()
            }

            Divider().overlay(LIFTTheme.cardStroke.opacity(0.6))

            HStack(spacing: 0) {
                heroStat(value: telemetry.hrvText, label: "HRV", accent: .indigo)
                heroDivider
                heroStat(value: telemetry.avgHeartRateText, label: "Resting HR", accent: .pink)
                heroDivider
                heroStat(value: telemetry.sleepText, label: "Sleep", accent: .cyan)
            }
        }
        .padding(18)
        .surface(cornerRadius: 10)
    }

    private var heroDivider: some View {
        Rectangle()
            .fill(LIFTTheme.cardStroke.opacity(0.6))
            .frame(width: 1, height: 26)
    }

    private func heroStat(value: String, label: String, accent: Accent) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(accent.color)

            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(LIFTTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Sleep Card

    private var sleepCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader("Sleep") {
                HStack(spacing: 4) {
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 10, weight: .semibold))
                    Text(telemetry.sleepText)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(LIFTTheme.cyan)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Quality")
                        .font(.system(size: 13))
                        .foregroundStyle(LIFTTheme.textSecondary)
                    Spacer()
                    Text("\(Int(telemetry.sleepScore * 100))%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(LIFTTheme.textPrimary)
                }

                MeterBar(progress: telemetry.sleepScore, accent: .cyan)

                Text("Deep + REM cycle above your average")
                    .font(.system(size: 11))
                    .foregroundStyle(LIFTTheme.textTertiary)
            }
        }
        .padding(18)
        .surface(cornerRadius: 10)
    }

    // MARK: - Weekly Activity

    private var weeklyActivityCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader("This Week") {
                HStack(spacing: 4) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 10, weight: .semibold))
                    Text(telemetry.stepsText)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(LIFTTheme.emerald)
                .padding(.vertical, 2)
            }

            WeeklyBarChart(
                values: telemetry.weeklySteps,
                labels: telemetry.weekDays,
                accent: .emerald
            )
        }
        .padding(18)
        .surface(cornerRadius: 10)
    }
}

// MARK: - Preview

#Preview {
    TodayView(telemetry: .demo)
}