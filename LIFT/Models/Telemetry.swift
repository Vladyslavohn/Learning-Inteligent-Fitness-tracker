import Foundation
import SwiftUI

// MARK: - Accent colors

/// Accent palette used across cards, icons, and charts.
enum Accent: String, CaseIterable {
    case emerald
    case blue
    case indigo
    case orange
    case pink
    case cyan

    var color: Color {
        switch self {
        case .emerald: return LIFTTheme.emerald
        case .blue:    return LIFTTheme.electricBlue
        case .indigo:  return LIFTTheme.indigo
        case .orange:  return Color(hex: 0xFF9F0A)
        case .pink:    return Color(hex: 0xFF375F)
        case .cyan:    return Color(hex: 0x64D2FF)
        }
    }
}

// MARK: - Daily Telemetry

/// Daily telemetry snapshot (mirrors HealthKit-style data).
struct DailyTelemetry {
    let userName: String
    let recoveryScore: Int
    let recoveryLabel: String
    let sleepText: String
    let sleepScore: Double
    let stepsText: String
    let avgHeartRateText: String
    let hrvText: String
    let caloriesText: String
    let heartRateSparkline: [Double]
    let weeklySteps: [Double]
    let weekDays: [String]
    let hrvChangePercent: Int
    let aiInsight: String
}

// MARK: - Workout

struct Workout: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let duration: String
    let calories: String
    let icon: String
    let accent: Accent
    let isCompleted: Bool
}

// MARK: - AI Insight

struct AIInsight: Identifiable {
    enum Category: String {
        case recovery = "Recovery"
        case training = "Training"
        case nutrition = "Nutrition"
        case sleep = "Sleep"
    }

    let id = UUID()
    let category: Category
    let title: String
    let message: String
    let timeAgo: String
    let icon: String
    let accent: Accent
}

// MARK: - Demo Data

extension DailyTelemetry {
    static let demo = DailyTelemetry(
        userName: "Bogdan",
        recoveryScore: 86,
        recoveryLabel: "Ready to train",
        sleepText: "7h 42m",
        sleepScore: 0.82,
        stepsText: "8,432",
        avgHeartRateText: "62 bpm",
        hrvText: "68 ms",
        caloriesText: "612",
        heartRateSparkline: [58, 61, 60, 64, 62, 66, 63, 62],
        weeklySteps: [0.55, 0.8, 0.42, 0.95, 0.65, 0.75, 0.85],
        weekDays: ["M", "T", "W", "T", "F", "S", "S"],
        hrvChangePercent: 12,
        aiInsight: "Optimal recovery detected. Your HRV is up 12% today—ideal window for a heavy strength session. Focus on compound lower body movements."
    )
}

extension Workout {
    static let demo: [Workout] = [
        Workout(title: "Heavy Lower Body", subtitle: "AI recommended • Squat focus", duration: "52 min", calories: "430 kcal", icon: "figure.strengthtraining.traditional", accent: .indigo, isCompleted: false),
        Workout(title: "Push Day", subtitle: "Chest • Shoulders • Triceps", duration: "45 min", calories: "380 kcal", icon: "figure.arms.open", accent: .blue, isCompleted: true),
        Workout(title: "Morning Run", subtitle: "Zone 2 • Outdoor", duration: "32 min", calories: "310 kcal", icon: "figure.run", accent: .emerald, isCompleted: true),
        Workout(title: "Mobility & Stretch", subtitle: "Recovery session", duration: "20 min", calories: "90 kcal", icon: "figure.flexibility", accent: .cyan, isCompleted: true),
        Workout(title: "Pull Day", subtitle: "Back • Biceps • Core", duration: "48 min", calories: "410 kcal", icon: "figure.strengthtraining.functional", accent: .orange, isCompleted: true)
    ]
}

extension AIInsight {
    static let demo: [AIInsight] = [
        AIInsight(
            category: .training,
            title: "Optimal window for heavy lifting",
            message: "Optimal recovery detected. Your HRV is up 12% today—ideal window for a heavy strength session. Focus on compound lower body movements.",
            timeAgo: "8 min ago",
            icon: "sparkles",
            accent: .indigo
        ),
        AIInsight(
            category: .recovery,
            title: "Recovery trending upward",
            message: "Your 7-day recovery trend is improving. Sleeping 30 min longer than your baseline added an estimated +6% to today's readiness.",
            timeAgo: "1 h ago",
            icon: "arrow.up.heart",
            accent: .emerald
        ),
        AIInsight(
            category: .nutrition,
            title: "Fuel your session",
            message: "Based on your planned workout intensity, aim for 25–30 g of protein within 90 minutes after training for optimal recovery.",
            timeAgo: "3 h ago",
            icon: "fork.knife",
            accent: .orange
        ),
        AIInsight(
            category: .sleep,
            title: "Consistent bedtime detected",
            message: "You've gone to bed within a 20-minute window for 5 nights straight. This consistency is boosting your deep sleep percentage.",
            timeAgo: "Yesterday",
            icon: "moon.zzz.fill",
            accent: .cyan
        )
    ]
}