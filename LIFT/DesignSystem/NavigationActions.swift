import SwiftUI

private struct OpenWorkoutPlanKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var openWorkoutPlan: () -> Void {
        get { self[OpenWorkoutPlanKey.self] }
        set { self[OpenWorkoutPlanKey.self] = newValue }
    }
}
