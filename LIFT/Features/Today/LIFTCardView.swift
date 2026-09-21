import SwiftUI

/// The core LIFT card: header, telemetry grid, and the AI coach insight.
struct LIFTCardView: View {

    let telemetry: DailyTelemetry
    let openWorkoutPlan: () -> Void
    @State private var isButtonPressed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            telemetryGrid
            aiInsightSection
        }
        .padding(LIFTTheme.cardPadding)
        .surface()
    }

    // MARK: - 1. Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 7) {
                StatusDot()

                Text("LIFT • AI INSIGHT")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(LIFTTheme.textSecondary)
            }

            Text("Daily Recovery & Readiness")
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(LIFTTheme.textPrimary)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }

    // MARK: - 2. Telemetry Grid

    private var telemetryGrid: some View {
        HStack(spacing: 9) {
            metricBlock(icon: "moon.zzz.fill", value: telemetry.sleepText, label: "Sleep")
            metricBlock(icon: "figure.walk", value: telemetry.stepsText, label: "Steps")
            heartRateBlock
        }
    }

    private func metricBlock(icon: String, value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(LIFTTheme.emerald)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LIFTTheme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(LIFTTheme.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LIFTTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.clear, lineWidth: 0)
        )
    }

    private var heartRateBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(LIFTTheme.emerald)

                SparklineView(data: telemetry.heartRateSparkline)
                    .stroke(
                        LIFTTheme.emerald,
                        style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)
                    )
                    .frame(height: 13)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(height: 16)

            VStack(alignment: .leading, spacing: 2) {
                Text(telemetry.avgHeartRateText)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LIFTTheme.textPrimary)

                Text("Avg HR")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(LIFTTheme.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LIFTTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.clear, lineWidth: 0)
        )
    }

    // MARK: - 3. AI Coach Insight

    private var aiInsightSection: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 7) {
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(LIFTTheme.electricBlue)

                Text("AI COACH")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(LIFTTheme.electricBlue)

                Spacer()
            }

            Text(telemetry.aiInsight)
                .font(.system(size: 14))
                .foregroundStyle(LIFTTheme.textPrimary.opacity(0.92))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            actionButton
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LIFTTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.clear, lineWidth: 0)
        )
    }

    private var actionButton: some View {
        Button(action: openWorkoutPlan) {
            HStack(spacing: 6) {
                Text("View AI Workout Plan")
                    .font(.system(size: 14, weight: .semibold))

                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(LIFTTheme.electricBlue)
            )
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isButtonPressed))
    }
}

// MARK: - Preview

#Preview("LIFT Card") {
    LIFTCardView(telemetry: .demo, openWorkoutPlan: {})
        .padding(20)
        .background(LIFTTheme.background)
}