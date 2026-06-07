import SwiftUI
import WidgetKit

private let paperAcceptWidgetKind = "PaperAcceptWidget"
private let paperAcceptAppGroup = "group.com.gaogehan.PaperAccept"

struct PaperAcceptWidgetEntry: TimelineEntry {
    let date: Date
    let venueName: String
    let resultDate: Date?
    let isEnabled: Bool
}

struct PaperAcceptWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> PaperAcceptWidgetEntry {
        PaperAcceptWidgetEntry(
            date: .now,
            venueName: "ICLR",
            resultDate: Calendar.current.date(byAdding: .day, value: 3, to: .now),
            isEnabled: true
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PaperAcceptWidgetEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PaperAcceptWidgetEntry>) -> Void) {
        let entry = currentEntry()
        let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: entry.date) ?? entry.date
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    private func currentEntry() -> PaperAcceptWidgetEntry {
        let defaults = UserDefaults(suiteName: paperAcceptAppGroup) ?? .standard
        let venueName = defaults.string(forKey: "widgetVenueName") ?? "ICLR"
        let resultDate = defaults.object(forKey: "widgetResultDate") as? Date
            ?? Calendar.current.date(byAdding: .day, value: 3, to: .now)

        return PaperAcceptWidgetEntry(
            date: .now,
            venueName: venueName,
            resultDate: resultDate,
            isEnabled: defaults.bool(forKey: "widgetPreviewEnabled")
        )
    }
}

struct PaperAcceptWidgetEntryView: View {
    let entry: PaperAcceptWidgetEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        VStack(alignment: .leading, spacing: family == .systemSmall ? 8 : 10) {
            HStack {
                Text("接论文中稿")
                    .font(.caption.weight(.black))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: entry.isEnabled ? "checkmark.seal.fill" : "timer")
                    .foregroundStyle(entry.isEnabled ? Color(red: 0.18, green: 0.70, blue: 0.56) : .secondary)
            }

            Text(entry.venueName)
                .font(.system(size: family == .systemSmall ? 24 : 28, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.08, blue: 0.09))
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Text(statusText)
                .font(.headline.weight(.black))
                .foregroundStyle(Color(red: 0.93, green: 0.30, blue: 0.42))
                .lineLimit(2)
                .minimumScaleFactor(0.72)

            if family != .systemSmall {
                Text("accept +1")
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color(red: 0.96, green: 0.70, blue: 0.22))
            }
        }
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.97, blue: 0.94),
                    Color(red: 0.93, green: 0.98, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var statusText: String {
        guard let resultDate = entry.resultDate else {
            return "等待开奖时间"
        }

        let interval = Int(resultDate.timeIntervalSince(entry.date))
        if interval <= 0 {
            return "已开奖"
        }

        let days = interval / 86_400
        if days > 0 {
            return "距离出结果还有 \(days) 天"
        }

        let hours = max(0, interval / 3_600)
        let minutes = max(0, (interval % 3_600) / 60)
        return "还有 \(hours) 小时 \(minutes) 分"
    }
}

@main
struct PaperAcceptWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: paperAcceptWidgetKind, provider: PaperAcceptWidgetProvider()) { entry in
            PaperAcceptWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("接论文中稿")
        .description("显示当前论文项目的开奖倒计时。")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}
