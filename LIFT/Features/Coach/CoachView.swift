import SwiftUI

/// AI Coach screen: live processing status, insight feed, quick questions.
struct CoachView: View {

    let telemetry: DailyTelemetry
    private let np = LIFTTheme.screenPadding
    @State private var insights = AIInsight.demo
    @State private var messageText = ""
    @State private var conversation: [ChatMessage] = []
    @State private var appeared = false

    private let quickQuestions = [
        "What should I train today?",
        "Why is my HRV up?",
        "How's my sleep quality?",
        "Build me a deload week"
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    statusCard.reveal(appeared)

                    insightFeed.reveal(appeared, delay: 0.05)

                    quickQuestionsSection.reveal(appeared, delay: 0.10)
                }
                .padding(.horizontal, np)
                .padding(.top, 6)
                .padding(.bottom, 32)
            }
            .background(ScreenBackground())
            .navigationTitle("AI Coach")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .bottom) {
                inputBar
            }
        }
        .onAppear {
            withAnimation(.reveal) { appeared = true }
        }
    }

    // MARK: - Live Status Card

    private var statusCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LIFTTheme.electricBlue.opacity(0.14))
                    .frame(width: 52, height: 52)

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(LIFTTheme.electricBlue)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    StatusDot(color: LIFTTheme.electricBlue)

                    Text("Analyzing your telemetry")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(LIFTTheme.textPrimary)
                }

                Text("Sleep • Steps • HRV • Heart rate")
                    .font(.system(size: 12))
                    .foregroundStyle(LIFTTheme.textSecondary)
            }

            Spacer()
        }
        .padding(16)
        .surface(cornerRadius: 10)
    }

    // MARK: - Insight Feed

    private var insightFeed: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Insights")

            VStack(spacing: 12) {
                ForEach(insights) { insight in
                    insightCard(insight)
                }

                ForEach(conversation) { message in
                    messageRow(message)
                }
            }
        }
    }

    private func insightCard(_ insight: AIInsight) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(insight.accent.color.opacity(0.15))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: insight.icon)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(insight.accent.color)
                    )

                Text(insight.category.rawValue.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(insight.accent.color)

                Spacer()

                Text(insight.timeAgo)
                    .font(.system(size: 11))
                    .foregroundStyle(LIFTTheme.textTertiary)
            }

            Text(insight.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(LIFTTheme.textPrimary)

            Text(insight.message)
                .font(.system(size: 13))
                .foregroundStyle(LIFTTheme.textSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .surface(cornerRadius: 10)
    }

    // MARK: - Quick Questions

    private var quickQuestionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Ask your coach")

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 165), spacing: 8)],
                alignment: .leading,
                spacing: 8
            ) {
                ForEach(quickQuestions, id: \.self) { question in
                    Button {
                        messageText = question
                    } label: {
                        Text(question)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(LIFTTheme.electricBlue)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(LIFTTheme.electricBlue.opacity(0.10))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(LIFTTheme.electricBlue.opacity(0.25), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask LIFT AI anything…", text: $messageText)
                .font(.system(size: 14))
                .foregroundStyle(LIFTTheme.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(LIFTTheme.mutedSurface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(LIFTTheme.cardStroke, lineWidth: 1)
                )

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(LIFTTheme.electricBlue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, np)
        .padding(.top, 12)
        .padding(.bottom, 6)
        .background(.ultraThinMaterial)
    }

    private func sendMessage() {
        let question = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }

        conversation.append(ChatMessage(text: question, isUser: true))
        messageText = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            conversation.append(
                ChatMessage(
                    text: "Based on your current recovery, keep today's session controlled and stop if your form drops.",
                    isUser: false
                )
            )
        }
    }

    private func messageRow(_ message: ChatMessage) -> some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }

            Text(message.text)
                .font(.body)
                .foregroundStyle(LIFTTheme.textPrimary)
                .padding(12)
                .background(message.isUser ? LIFTTheme.electricBlue : LIFTTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if !message.isUser { Spacer(minLength: 40) }
        }
    }
}

private struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// MARK: - Preview

#Preview {
    CoachView(telemetry: .demo)
}