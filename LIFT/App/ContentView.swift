import SwiftUI

/// Root tab bar navigation — native iOS style with 4 tabs.
struct ContentView: View {

    let telemetry = DailyTelemetry.demo
    @AppStorage("darkModeOnly") private var darkModeOnly = true
    @State private var selectedTab: Tab = .today

    private enum Tab: Hashable {
        case today
        case workouts
        case coach
        case profile
    }

    init() {
        Self.configureTabBarAppearance(isDark: true)
    }

    var body: some View {
        ZStack {
                TabView(selection: $selectedTab) {
                TodayView(telemetry: telemetry)
                    .tabItem {
                        Label("Today", systemImage: "house.fill")
                    }
                    .tag(Tab.today)
                    .environment(\.openWorkoutPlan) {
                        selectedTab = .workouts
                    }

                WorkoutsView(telemetry: telemetry)
                    .tabItem {
                        Label("Workouts", systemImage: "dumbbell.fill")
                    }
                    .tag(Tab.workouts)

                CoachView(telemetry: telemetry)
                    .tabItem {
                        Label("AI Coach", systemImage: "sparkles")
                    }
                    .tag(Tab.coach)

                ProfileView(telemetry: telemetry)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(Tab.profile)
            }

        }
        .tint(LIFTTheme.textPrimary)
        .preferredColorScheme(darkModeOnly ? .dark : .light)
        .onAppear {
            Self.configureTabBarAppearance(isDark: darkModeOnly)
        }
        .onChange(of: darkModeOnly) { _, isDark in
            Self.configureTabBarAppearance(isDark: isDark)
        }
    }

    private static func configureTabBarAppearance(isDark: Bool) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = isDark
            ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1)
            : UIColor(red: 0.98, green: 0.98, blue: 1, alpha: 1)
        appearance.shadowColor = isDark
            ? UIColor(white: 1, alpha: 0.08)
            : UIColor(white: 0, alpha: 0.16)

        let item = appearance.stackedLayoutAppearance
        let secondary = isDark ? UIColor(white: 0.55, alpha: 1) : UIColor(white: 0.35, alpha: 1)
        item.normal.iconColor = secondary
        item.normal.titleTextAttributes = [.foregroundColor: secondary]
        item.selected.iconColor = UIColor(LIFTTheme.emerald)
        item.selected.titleTextAttributes = [.foregroundColor: UIColor(LIFTTheme.emerald)]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
