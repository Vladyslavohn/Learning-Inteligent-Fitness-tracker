import SwiftUI

/// Profile screen: user card, health metrics, preferences (native iOS settings style).
struct ProfileView: View {

    let telemetry: DailyTelemetry
    @AppStorage("healthKitSync") private var healthKitSync = true
    @AppStorage("aiNotifications") private var aiNotifications = true
    @AppStorage("darkModeOnly") private var darkModeOnly = true
    @State private var presentedDocument: Document?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    userCard
                    healthMetricsCard
                    preferencesSection
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(ScreenBackground())
            .navigationTitle("Profile")
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    // MARK: - User Card

    private var userCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LIFTTheme.electricBlue)
                    .frame(width: 88, height: 88)

                Text(String(telemetry.userName.prefix(1)))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text(telemetry.userName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(LIFTTheme.textPrimary)

                Text("LIFT Pro • Member since 2025")
                    .font(.system(size: 12))
                    .foregroundStyle(LIFTTheme.textSecondary)
            }

            HStack(spacing: 0) {
                profileStat(value: "128", label: "Workouts")
                Divider().frame(height: 32).background(LIFTTheme.cardStroke)
                profileStat(value: "14", label: "Day streak")
                Divider().frame(height: 32).background(LIFTTheme.cardStroke)
                profileStat(value: "92%", label: "Goals hit")
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(LIFTTheme.surface)
            )
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .surface(cornerRadius: 10)
    }

    private func profileStat(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(LIFTTheme.textPrimary)

            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(LIFTTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Health Metrics

    private var healthMetricsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Health Data")

            VStack(spacing: 0) {
                metricRow(icon: "moon.zzz.fill", tint: .cyan, title: "Sleep", value: telemetry.sleepText)
                rowDivider
                metricRow(icon: "figure.walk", tint: .emerald, title: "Steps", value: telemetry.stepsText)
                rowDivider
                metricRow(icon: "heart.fill", tint: .pink, title: "Avg Heart Rate", value: telemetry.avgHeartRateText)
                rowDivider
                metricRow(icon: "waveform.path.ecg", tint: .indigo, title: "HRV", value: telemetry.hrvText)
            }
        }
        .padding(18)
        .surface(cornerRadius: 10)
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(LIFTTheme.cardStroke.opacity(0.5))
            .frame(height: 1)
            .padding(.leading, 46)
    }

    private func metricRow(icon: String, tint: Accent, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(tint.color)
                .frame(width: 22)

            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(LIFTTheme.textPrimary)

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(LIFTTheme.textSecondary)
        }
        .padding(.vertical, 10)
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Preferences")

            VStack(spacing: 0) {
                Toggle(isOn: $healthKitSync) {
                    toggleLabel(icon: "heart.text.square.fill", tint: .pink, text: "HealthKit Sync")
                }
                toggleDivider
                Toggle(isOn: $aiNotifications) {
                    toggleLabel(icon: "bell.badge.fill", tint: .indigo, text: "AI Coach Alerts")
                }
                toggleDivider
                Toggle(isOn: $darkModeOnly) {
                    toggleLabel(icon: "moon.fill", tint: .blue, text: "Dark Mode")
                }
            }
            .tint(LIFTTheme.emerald)
        }
        .padding(18)
        .surface(cornerRadius: 10)
    }

    private var toggleDivider: some View {
        Rectangle()
            .fill(LIFTTheme.cardStroke.opacity(0.5))
            .frame(height: 1)
            .padding(.leading, 46)
    }

    private func toggleLabel(icon: String, tint: Accent, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(tint.color)
                .frame(width: 22)

            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(LIFTTheme.textPrimary)
        }
        .padding(.vertical, 6)
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("About")

            VStack(spacing: 0) {
                aboutRow(icon: "shield.lock.fill", title: "Privacy Policy", accent: .emerald, document: .privacy)
                rowDivider
                aboutRow(icon: "doc.text.fill", title: "Terms of Use", accent: .blue, document: .terms)
                rowDivider
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(LIFTTheme.textSecondary)
                            .frame(width: 22)

                        Text("Version")
                            .font(.system(size: 15))
                            .foregroundStyle(LIFTTheme.textPrimary)
                    }
                    .sheet(item: $presentedDocument) { document in
                        NavigationStack {
                            Text(document.body)
                                .font(.body)
                                .foregroundStyle(LIFTTheme.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .navigationTitle(document.title)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                    }
                    Spacer()
                    Text("1.0.0")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(LIFTTheme.textSecondary)
                }
                .padding(.vertical, 10)
            }
        }
        .padding(18)
        .surface(cornerRadius: 10)
    }

    private func aboutRow(icon: String, title: String, accent: Accent, document: Document) -> some View {
        Button {
            presentedDocument = document
        } label: {
            HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(accent.color)
                .frame(width: 22)

            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(LIFTTheme.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(LIFTTheme.textSecondary.opacity(0.6))
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(LIFTTheme.textSecondary)
    }

    private enum Document: String, Identifiable {
        case privacy
        case terms

        var id: String { rawValue }
        var title: String { self == .privacy ? "Privacy Policy" : "Terms of Use" }
        var body: String {
            self == .privacy
                ? "LIFT stores your preferences on this device. Health data access will be requested only when the integration is enabled."
                : "LIFT is a fitness planning prototype. Training suggestions are informational and are not medical advice."
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView(telemetry: .demo)
}