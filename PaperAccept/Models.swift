import Foundation
import SwiftUI

enum VenueKind: String, CaseIterable, Identifiable, Codable {
    case conference = "会议"
    case journal = "期刊"

    var id: String { rawValue }
}

enum VenueTrack: String, CaseIterable, Identifiable, Codable {
    case all = "全部"
    case ai = "AI"
    case computerVision = "计算机视觉"
    case machineLearning = "机器学习"
    case naturalLanguage = "自然语言"
    case databaseMining = "数据库/数据挖掘"
    case graphicsMultimedia = "图形学/多媒体"
    case architectureStorage = "体系结构/存储"
    case networkSystem = "计算机网络"
    case security = "网络与安全"
    case softwareSystem = "软件/系统"
    case theory = "计算机理论"
    case humanComputerInteraction = "人机交互"
    case interdisciplinary = "交叉/新兴"
    case journal = "期刊"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "全部"
        case .ai:
            return "人工智能"
        case .computerVision:
            return "计算机视觉"
        case .machineLearning:
            return "机器学习"
        case .naturalLanguage:
            return "自然语言"
        case .databaseMining:
            return "数据库/数据挖掘"
        case .graphicsMultimedia:
            return "图形学/多媒体"
        case .architectureStorage:
            return "体系结构/存储"
        case .networkSystem:
            return "计算机网络"
        case .security:
            return "网络与安全"
        case .softwareSystem:
            return "软件/系统"
        case .theory:
            return "计算机理论"
        case .humanComputerInteraction:
            return "人机交互"
        case .interdisciplinary:
            return "交叉/新兴"
        case .journal:
            return "期刊"
        }
    }

    var ccfCategoryCode: String? {
        switch self {
        case .ai:
            return "AI"
        case .databaseMining:
            return "DB"
        case .graphicsMultimedia:
            return "CG"
        case .architectureStorage:
            return "DS"
        case .networkSystem:
            return "NW"
        case .security:
            return "SC"
        case .softwareSystem:
            return "SE"
        case .theory:
            return "CT"
        case .humanComputerInteraction:
            return "HI"
        case .interdisciplinary:
            return "MX"
        default:
            return nil
        }
    }
}

enum VenueRankFilter: String, CaseIterable, Identifiable, Codable {
    case all = "全部"
    case a = "A"
    case b = "B"
    case c = "C"
    case n = "N"

    var id: String { rawValue }

    var compactTitle: String {
        self == .all ? "全部" : rawValue
    }

    var menuTitle: String {
        self == .all ? "全部分级" : "CCF \(rawValue)"
    }

    func matches(_ venue: Venue) -> Bool {
        guard venue.kind == .conference else {
            return self == .all
        }
        return self == .all || venue.normalizedCCFRank == rawValue
    }
}

enum VIPSubscriptionPlan: String, CaseIterable, Identifiable, Codable {
    case monthly
    case halfYear
    case yearly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .monthly:
            return "包月 VIP"
        case .halfYear:
            return "包半年 VIP"
        case .yearly:
            return "包年 VIP"
        }
    }

    var priceText: String {
        switch self {
        case .monthly:
            return "¥1.66"
        case .halfYear:
            return "¥6.88"
        case .yearly:
            return "¥15.88"
        }
    }

    var periodText: String {
        switch self {
        case .monthly:
            return "/ 月"
        case .halfYear:
            return " / 6 个月"
        case .yearly:
            return " / 年"
        }
    }

    var subtitle: String {
        switch self {
        case .monthly:
            return "免费体验 3 天，随时取消"
        case .halfYear:
            return "适合投稿季集中使用"
        case .yearly:
            return "全年接稿好运常驻"
        }
    }

    var badge: String? {
        switch self {
        case .monthly:
            return "试用"
        case .halfYear:
            return nil
        case .yearly:
            return "推荐"
        }
    }

    var productID: String {
        switch self {
        case .monthly:
            return "paperaccept.vip.monthly"
        case .halfYear:
            return "paperaccept.vip.halfyear"
        case .yearly:
            return "paperaccept.vip.yearly"
        }
    }

    func expirationDate(from startDate: Date, calendar: Calendar = .current) -> Date {
        let components: DateComponents
        switch self {
        case .monthly:
            components = DateComponents(month: 1)
        case .halfYear:
            components = DateComponents(month: 6)
        case .yearly:
            components = DateComponents(year: 1)
        }
        return calendar.date(byAdding: components, to: startDate) ?? startDate
    }
}

struct PaperAcceptRemoteConfig: Codable {
    var schemaVersion: Int
    var updatedAt: Date?
    var homepage: RemoteHomepageConfig?
    var countdown: RemoteCountdownConfig?
    var comments: RemoteCommentsConfig?
    var vip: RemoteVIPConfig?
    var announcements: [RemoteAnnouncement]

    static let fallback = PaperAcceptRemoteConfig(
        schemaVersion: 1,
        updatedAt: nil,
        homepage: RemoteHomepageConfig(communityAcceptedUserCount: nil),
        countdown: RemoteCountdownConfig(hotVenueIDs: []),
        comments: RemoteCommentsConfig(maxItems: 200, templates: []),
        vip: RemoteVIPConfig(
            benefits: [
                "五种接收语音",
                "七种接收特效",
                "彩色 VIP 弹幕",
                "六款敲击图标"
            ],
            paywallNotice: "当前仍是产品原型的本地订阅状态；正式上架时会把这些套餐映射到 StoreKit 商品，过期和续订状态由苹果收据/订阅状态驱动。",
            coupons: [
                RemoteVIPCoupon(
                    code: "ACCEPT2026",
                    title: "内测 VIP",
                    planID: "coupon.accept2026",
                    durationDays: 30,
                    expiresAt: Date.distantFuture,
                    isEnabled: true
                )
            ]
        ),
        announcements: []
    )
}

struct RemoteHomepageConfig: Codable {
    var communityAcceptedUserCount: Int?
}

struct RemoteCountdownConfig: Codable {
    var hotVenueIDs: [String]
}

struct RemoteCommentsConfig: Codable {
    var maxItems: Int?
    var templates: [String]
}

struct RemoteVIPConfig: Codable {
    var benefits: [String]
    var paywallNotice: String?
    var coupons: [RemoteVIPCoupon]
}

struct RemoteVIPCoupon: Codable, Identifiable {
    var id: String { normalizedCode }
    let code: String
    let title: String
    let planID: String?
    let durationDays: Int
    let expiresAt: Date?
    let isEnabled: Bool

    var normalizedCode: String {
        code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }
}

struct RemoteAnnouncement: Codable, Identifiable {
    let id: String
    let title: String
    let body: String
    let isEnabled: Bool
}

struct CouponRedemptionResult {
    let isSuccess: Bool
    let message: String
}

enum MilestoneKind: String {
    case result = "结果公布"
    case paperDeadline = "投稿截止"
    case conferenceStart = "会议开始"
    case rollingReview = "下一轮审稿"
}

struct Venue: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let fullName: String
    let kind: VenueKind
    let track: VenueTrack
    var categoryCode: String? = nil
    var ccfRank: String
    let slug: String?
    var year: Int?
    var paperDeadline: Date?
    var resultDate: Date?
    var conferenceStart: Date?
    var dateText: String
    var place: String
    var sourceURL: URL?
    var note: String

    var displayRank: String {
        guard kind == .conference else { return ccfRank }
        return normalizedCCFRank == "N" ? "CCF N" : "CCF \(normalizedCCFRank)"
    }

    var normalizedCCFRank: String {
        let uppercased = ccfRank.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if uppercased == "NONE" {
            return "N"
        }
        return ["A", "B", "C", "N"].contains(uppercased) ? uppercased : ccfRank
    }

    var categoryTitle: String {
        if kind == .journal {
            return VenueTrack.journal.title
        }
        if [.computerVision, .machineLearning, .naturalLanguage].contains(track) {
            return track.title
        }
        if let categoryCode,
           let track = VenueTrack.allCases.first(where: { $0.ccfCategoryCode == categoryCode }) {
            return track.title
        }
        return track.title
    }

    var isFromCCFDDL: Bool {
        slug != nil
    }

    var isCustom: Bool {
        id.hasPrefix("custom-")
    }

    func matches(track: VenueTrack) -> Bool {
        switch track {
        case .all:
            return true
        case .journal:
            return kind == .journal
        case .ai:
            return categoryCode == "AI" || self.track == .ai
        case .computerVision, .machineLearning, .naturalLanguage:
            return self.track == track
        default:
            return categoryCode == track.ccfCategoryCode || self.track == track
        }
    }

    func nextMilestone(relativeTo now: Date = .now) -> VenueMilestone {
        let candidates: [VenueMilestone?] = [
            resultDate.map {
                VenueMilestone(kind: .result, title: "论文出结果", date: $0, source: "预计结果日")
            },
            paperDeadline.map {
                VenueMilestone(kind: .paperDeadline, title: "投稿截止", date: $0, source: "CCFDDL")
            },
            conferenceStart.map {
                VenueMilestone(kind: .conferenceStart, title: "会议开始", date: $0, source: dateText)
            }
        ]

        if let upcoming = candidates.compactMap({ $0 })
            .filter({ $0.date > now })
            .sorted(by: { $0.date < $1.date })
            .first {
            return upcoming
        }

        if kind == .journal {
            let fallback = Calendar.current.date(byAdding: .day, value: 30, to: now) ?? now
            return VenueMilestone(kind: .rollingReview, title: "下一轮审稿祈福", date: fallback, source: "期刊滚动审稿")
        }

        return VenueMilestone(kind: .conferenceStart, title: "等待新一轮 CFP", date: now, source: "暂无未来节点")
    }

    func resultStatusText(relativeTo now: Date = .now) -> String? {
        guard kind == .conference, let resultDate else { return nil }
        let countdown = CountdownFormatter.value(until: resultDate, from: now)
        if countdown.isElapsed {
            return "已开奖"
        }
        return "距开奖 \(countdown.compactText)"
    }

    func notificationBody(relativeTo now: Date = .now) -> String? {
        guard kind == .conference, let resultDate else { return nil }
        let countdown = CountdownFormatter.value(until: resultDate, from: now)
        if countdown.isElapsed {
            return "\(name) 已开奖，快来接住好消息。"
        }
        if countdown.days > 0 {
            return "距离 \(name) 出结果还有 \(countdown.days) 天"
        }
        return "距离 \(name) 出结果还有 \(countdown.hours) 小时 \(countdown.minutes) 分"
    }
}

struct VenueMilestone: Equatable {
    let kind: MilestoneKind
    let title: String
    let date: Date
    let source: String
}

struct CountdownValue: Equatable {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    let isElapsed: Bool

    var compactText: String {
        if isElapsed {
            return "已到达"
        }
        if days > 0 {
            return "\(days)天 \(hours)小时 \(minutes)分"
        }
        return "\(hours)小时 \(minutes)分 \(seconds)秒"
    }

    var units: [(String, String)] {
        [
            ("天", String(days)),
            ("时", String(hours)),
            ("分", String(minutes)),
            ("秒", String(seconds))
        ]
    }
}

enum CountdownFormatter {
    static func value(until targetDate: Date, from now: Date = .now) -> CountdownValue {
        let interval = Int(targetDate.timeIntervalSince(now))
        if interval <= 0 {
            return CountdownValue(days: 0, hours: 0, minutes: 0, seconds: 0, isElapsed: true)
        }

        let days = interval / 86_400
        let hours = (interval % 86_400) / 3_600
        let minutes = (interval % 3_600) / 60
        let seconds = interval % 60
        return CountdownValue(days: days, hours: hours, minutes: minutes, seconds: seconds, isElapsed: false)
    }
}

extension Date {
    static func paperDate(
        _ year: Int,
        _ month: Int,
        _ day: Int,
        _ hour: Int = 23,
        _ minute: Int = 59,
        timeZone: TimeZone = .current
    ) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar.date(from: DateComponents(
            timeZone: timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )) ?? .now
    }
}

extension Color {
    static let paperInk = Color(red: 0.08, green: 0.08, blue: 0.09)
    static let paperSurface = Color(red: 0.98, green: 0.97, blue: 0.94)
    static let acceptGold = Color(red: 0.96, green: 0.70, blue: 0.22)
    static let acceptRose = Color(red: 0.93, green: 0.30, blue: 0.42)
    static let acceptMint = Color(red: 0.18, green: 0.70, blue: 0.56)
    static let acceptBlue = Color(red: 0.17, green: 0.43, blue: 0.78)
}
