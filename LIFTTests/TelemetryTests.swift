import XCTest
@testable import LIFT

final class TelemetryTests: XCTestCase {
    func testDemoTelemetryHasMatchingChartData() {
        let telemetry = DailyTelemetry.demo

        XCTAssertEqual(telemetry.weeklySteps.count, telemetry.weekDays.count)
        XCTAssertGreaterThanOrEqual(telemetry.recoveryScore, 0)
        XCTAssertLessThanOrEqual(telemetry.recoveryScore, 100)
        XCTAssertTrue((0...1).contains(telemetry.sleepScore))
    }

    func testWorkoutFixturesContainCompletedAndPlannedSessions() {
        let workouts = Workout.demo

        XCTAssertFalse(workouts.isEmpty)
        XCTAssertTrue(workouts.contains(where: \.isCompleted))
        XCTAssertTrue(workouts.contains(where: { !$0.isCompleted }))
    }

    func testInsightFixturesHaveReadableContent() {
        XCTAssertFalse(AIInsight.demo.isEmpty)
        XCTAssertTrue(AIInsight.demo.allSatisfy { !$0.title.isEmpty && !$0.message.isEmpty })
    }
}
