import SwiftUI

struct SectionHeader<Trailing: View>: View {
    let title: String
    let trailing: () -> Trailing

    init(_ title: String, @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }) {
        self.title = title
        self.trailing = trailing
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(LIFTTheme.textPrimary)

            Spacer()

            trailing()
        }
    }
}

struct StatusDot: View {
    var color: Color = LIFTTheme.emerald
    var body: some View {
        Circle().fill(color).frame(width: 7, height: 7)
    }
}

struct SparklineView: Shape {
    let data: [Double]

    func path(in rect: CGRect) -> Path {
        guard data.count > 1 else { return Path() }

        let minValue = data.min() ?? 0
        let maxValue = data.max() ?? 1
        let range = max(maxValue - minValue, .ulpOfOne)

        var path = Path()
        for (index, value) in data.enumerated() {
            let x = rect.width * CGFloat(index) / CGFloat(data.count - 1)
            let y = rect.height * (1 - CGFloat((value - minValue) / range))
            let point = CGPoint(x: x, y: y)
            index == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        return path
    }
}

struct ActivityRingView: View {
    let progress: Double
    var accent: Accent = .emerald
    var lineWidth: CGFloat = 10

    @State private var animatedProgress: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Circle()
                .stroke(LIFTTheme.controlTrack, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    accent.color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .onAppear {
            let animation = reduceMotion
                ? nil
                : Animation.progress.delay(0.15)
            withAnimation(animation) {
                animatedProgress = min(max(progress, 0), 1)
            }
        }
        .onChange(of: progress) { _, value in
            withAnimation(reduceMotion ? nil : .progress) {
                animatedProgress = min(max(value, 0), 1)
            }
        }
    }
}

struct WeeklyBarChart: View {
    let values: [Double]
    let labels: [String]
    var accent: Accent = .emerald

    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(Array(zip(values, labels).enumerated()), id: \.offset) { index, pair in
                let value = pair.0
                let isToday = index == min(values.count, labels.count) - 1

                VStack(spacing: 8) {
                    Rectangle()
                        .fill(isToday ? AnyShapeStyle(accent.color) : AnyShapeStyle(LIFTTheme.controlTrack))
                        .frame(height: max(8, CGFloat(value) * 64))
                        .scaleEffect(y: appeared || reduceMotion ? 1 : 0.2, anchor: .bottom)
                        .animation(
                            reduceMotion ? nil : .chart.delay(Double(index) * 0.045),
                            value: appeared
                        )

                    Text(pair.1)
                        .font(.system(size: 10, weight: isToday ? .bold : .medium))
                        .foregroundStyle(isToday ? accent.color : LIFTTheme.textTertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 92, alignment: .bottom)
        .onAppear { appeared = true }
    }
}

struct MeterBar: View {
    let progress: Double
    var accent: Accent = .emerald

    @State private var animated: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(LIFTTheme.controlTrack)

                Rectangle()
                    .fill(accent.color)
                    .frame(width: max(6, geo.size.width * animated))
            }
        }
        .frame(height: 7)
        .onAppear {
            withAnimation(reduceMotion ? nil : .reveal.delay(0.15)) {
                animated = min(max(progress, 0), 1)
            }
        }
        .onChange(of: progress) { _, value in
            withAnimation(reduceMotion ? nil : .reveal) {
                animated = min(max(value, 0), 1)
            }
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.65 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.reveal, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, pressed in
                isPressed = pressed
                if pressed {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
    }
}

struct ScreenBackground: View {
    var body: some View {
        LIFTTheme.background.ignoresSafeArea()
    }
}

extension Animation {
    static let reveal = easeOut(duration: 0.32)
    static let progress = interpolatingSpring(stiffness: 90, damping: 16)
    static let chart = spring(response: 0.55, dampingFraction: 0.82)
}

extension View {
    func reveal(_ visible: Bool, delay: Double = 0) -> some View {
        opacity(visible ? 1 : 0)
            .animation(.reveal.delay(delay), value: visible)
    }

    func surface(cornerRadius: CGFloat = LIFTTheme.cardCornerRadius) -> some View {
        modifier(SurfaceModifier(cornerRadius: cornerRadius))
    }
}

private struct SurfaceModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(LIFTTheme.surface)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}