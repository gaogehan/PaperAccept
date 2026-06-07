import AVFoundation
import AudioToolbox
import Foundation
import SwiftUI
import UIKit
import UserNotifications
#if canImport(WidgetKit)
import WidgetKit
#endif

struct RemoteConfigService {
    private let url: URL

    init(url: URL = URL(string: "https://raw.githubusercontent.com/gaogehan/PaperAccept/main/remote-config.json")!) {
        self.url = url
    }

    func fetchConfig() async throws -> PaperAcceptRemoteConfig {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(PaperAcceptRemoteConfig.self, from: data)
    }
}

@MainActor
final class PaperAcceptViewModel: ObservableObject {
    private static let widgetSuiteName = "group.com.gaogehan.PaperAccept"
    private static let vipUnlockedKey = "vipUnlocked"
    private static let vipPlanIDKey = "vipPlanID"
    private static let vipExpiresAtKey = "vipExpiresAt"
    private static let remoteCommentTemplatesKey = "remoteCommentTemplates"
    private static let defaultRemoteCommentLimit = 200

    @Published var acceptCount: Int {
        didSet { UserDefaults.standard.set(acceptCount, forKey: "acceptCount") }
    }
    @Published var communityAcceptedUserCount: Int {
        didSet { UserDefaults.standard.set(communityAcceptedUserCount, forKey: "communityAcceptedUserCount") }
    }
    @Published private var venueAcceptCounts: [String: Int] = [:] {
        didSet { Self.saveVenueAcceptCounts(venueAcceptCounts) }
    }
    @Published var vipUnlocked: Bool {
        didSet { UserDefaults.standard.set(vipUnlocked, forKey: Self.vipUnlockedKey) }
    }
    @Published private(set) var vipPlanID: String? {
        didSet {
            if let vipPlanID {
                UserDefaults.standard.set(vipPlanID, forKey: Self.vipPlanIDKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.vipPlanIDKey)
            }
        }
    }
    @Published private(set) var vipExpiresAt: Date? {
        didSet {
            if let vipExpiresAt {
                UserDefaults.standard.set(vipExpiresAt, forKey: Self.vipExpiresAtKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.vipExpiresAtKey)
            }
        }
    }
    @Published private(set) var venues: [Venue] = ConferenceData.initialVenues
    @Published var selectedTrack: VenueTrack = .all
    @Published var selectedRankFilter: VenueRankFilter = .a
    @Published var isRefreshing = false
    @Published var refreshMessage = "数据来自 CCFDDL / 内置精选"
    @Published var reminderMessage = "可设置开奖前通知"
    @Published var lastAdvancedAccept: Date?
    @Published private(set) var remoteConfig = PaperAcceptRemoteConfig.fallback
    @Published private(set) var remoteCommentTemplates: [String] {
        didSet { Self.saveRemoteCommentTemplates(remoteCommentTemplates) }
    }

    private let ccfddlService: CCFDDLService
    private let remoteConfigService: RemoteConfigService
    private let speech = AVSpeechSynthesizer()
    @Published private var selectedVenueID: String {
        didSet { UserDefaults.standard.set(selectedVenueID, forKey: "selectedVenueID") }
    }

    init(
        ccfddlService: CCFDDLService = CCFDDLService(),
        remoteConfigService: RemoteConfigService = RemoteConfigService()
    ) {
        self.ccfddlService = ccfddlService
        self.remoteConfigService = remoteConfigService
        self.acceptCount = UserDefaults.standard.integer(forKey: "acceptCount")
        self.communityAcceptedUserCount = Self.loadCommunityAcceptedUserCount()
        self.venueAcceptCounts = Self.loadVenueAcceptCounts()
        self.vipUnlocked = UserDefaults.standard.bool(forKey: Self.vipUnlockedKey)
        self.vipPlanID = UserDefaults.standard.string(forKey: Self.vipPlanIDKey)
        self.vipExpiresAt = UserDefaults.standard.object(forKey: Self.vipExpiresAtKey) as? Date
        self.remoteCommentTemplates = Self.loadRemoteCommentTemplates()
        self.venues = ConferenceData.initialVenues + Self.loadCustomVenues()
        self.selectedVenueID = UserDefaults.standard.string(forKey: "selectedVenueID") ?? "neurips"
        refreshVIPStatus()
        ensureSelectedVenueMatchesFilters()
    }

    var selectedVenue: Venue {
        get {
            venues.first(where: { $0.id == selectedVenueID }) ?? venues[0]
        }
        set {
            selectedVenueID = newValue.id
        }
    }

    var filteredVenues: [Venue] {
        venues
            .filter { $0.matches(track: selectedTrack) && selectedRankFilter.matches($0) }
            .sorted(by: Self.isVenueOrderedBefore)
    }

    var selectedVenueAcceptCount: Int {
        venueAcceptCounts[selectedVenue.id, default: 0]
    }

    var vipSubscriptionStatusText: String {
        guard vipUnlocked,
              let vipExpiresAt,
              vipExpiresAt > .now else {
            return "未开通 VIP"
        }
        let planName = VIPSubscriptionPlan(rawValue: vipPlanID ?? "")?.title
            ?? (vipPlanID?.hasPrefix("coupon.") == true ? "优惠码 VIP" : "VIP")
        return "\(planName) · \(Self.vipDateFormatter.string(from: vipExpiresAt)) 到期"
    }

    var vipBenefitTexts: [String] {
        let benefits = remoteConfig.vip?.benefits
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty } ?? []
        return benefits.isEmpty ? PaperAcceptRemoteConfig.fallback.vip?.benefits ?? [] : benefits
    }

    var vipPaywallNotice: String {
        let notice = remoteConfig.vip?.paywallNotice?.trimmingCharacters(in: .whitespacesAndNewlines)
        return notice?.isEmpty == false ? notice! : PaperAcceptRemoteConfig.fallback.vip?.paywallNotice ?? ""
    }

    var featuredCountdowns: [Venue] {
        let now = Date()
        let hotRanks = hotCountdownVenueRanks
        let candidates = venues
            .filter { venue in
                guard venue.kind == .conference,
                      venue.matches(track: selectedTrack),
                      selectedRankFilter.matches(venue),
                      venue.resultDate != nil || venue.paperDeadline != nil || venue.conferenceStart != nil else {
                    return false
                }
                return venue.nextMilestone(relativeTo: now).date > now
            }
        let popularCandidates = candidates.filter { hotRanks[$0.id] != nil }
        let pool = popularCandidates.count >= 5 ? popularCandidates : candidates

        return pool
            .sorted { first, second in
                let firstDate = first.nextMilestone(relativeTo: now).date
                let secondDate = second.nextMilestone(relativeTo: now).date
                if firstDate != secondDate {
                    return firstDate < secondDate
                }

                let firstHotRank = hotRanks[first.id] ?? Int.max
                let secondHotRank = hotRanks[second.id] ?? Int.max
                if firstHotRank != secondHotRank {
                    return firstHotRank < secondHotRank
                }

                return first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
            }
            .prefix(5)
            .map { $0 }
    }

    func select(_ venue: Venue) {
        selectedVenue = venue
    }

    func select(track: VenueTrack) {
        selectedTrack = track
        ensureSelectedVenueMatchesFilters()
    }

    func select(rankFilter: VenueRankFilter) {
        selectedRankFilter = rankFilter
        ensureSelectedVenueMatchesFilters()
    }

    func strikeWoodFish() {
        acceptCount += 1
        venueAcceptCounts[selectedVenue.id, default: 0] += 1
        AudioServicesPlaySystemSound(1104)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    func addCustomVenue(
        name: String,
        fullName: String,
        kind: VenueKind,
        track: VenueTrack,
        ccfRank: String,
        year: Int?,
        resultDate: Date?
    ) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let normalizedKind: VenueKind = kind
        let normalizedTrack: VenueTrack = normalizedKind == .journal ? .journal : (track == .journal || track == .all ? .machineLearning : track)
        let normalizedFullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedRank = ccfRank.trimmingCharacters(in: .whitespacesAndNewlines)
        let venue = Venue(
            id: makeCustomVenueID(from: trimmedName),
            name: trimmedName,
            fullName: normalizedFullName.isEmpty ? trimmedName : normalizedFullName,
            kind: normalizedKind,
            track: normalizedTrack,
            categoryCode: Self.categoryCode(for: normalizedKind, track: normalizedTrack),
            ccfRank: normalizedRank.isEmpty ? (normalizedKind == .conference ? "A" : "Journal") : normalizedRank,
            slug: nil,
            year: normalizedKind == .conference ? year : nil,
            paperDeadline: nil,
            resultDate: normalizedKind == .conference ? resultDate : nil,
            conferenceStart: nil,
            dateText: Self.dateText(for: normalizedKind, resultDate: resultDate),
            place: normalizedKind == .conference ? "TBD" : "Online",
            sourceURL: nil,
            note: normalizedKind == .conference ? "用户自定义会议，可用于接收倒计时与通知。" : "用户自定义期刊，按滚动审稿处理。"
        )

        venues.append(venue)
        saveCustomVenues()
        selectedTrack = normalizedTrack
        selectedVenue = venue
    }

    func updateCustomVenue(
        id: String,
        name: String,
        fullName: String,
        kind: VenueKind,
        track: VenueTrack,
        ccfRank: String,
        year: Int?,
        resultDate: Date?
    ) {
        guard let index = venues.firstIndex(where: { $0.id == id && $0.isCustom }) else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let normalizedKind: VenueKind = kind
        let normalizedTrack: VenueTrack = normalizedKind == .journal ? .journal : (track == .journal || track == .all ? .machineLearning : track)
        let normalizedFullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedRank = ccfRank.trimmingCharacters(in: .whitespacesAndNewlines)
        let venue = Venue(
            id: id,
            name: trimmedName,
            fullName: normalizedFullName.isEmpty ? trimmedName : normalizedFullName,
            kind: normalizedKind,
            track: normalizedTrack,
            categoryCode: Self.categoryCode(for: normalizedKind, track: normalizedTrack),
            ccfRank: normalizedRank.isEmpty ? (normalizedKind == .conference ? "A" : "Journal") : normalizedRank,
            slug: nil,
            year: normalizedKind == .conference ? year : nil,
            paperDeadline: nil,
            resultDate: normalizedKind == .conference ? resultDate : nil,
            conferenceStart: nil,
            dateText: Self.dateText(for: normalizedKind, resultDate: resultDate),
            place: normalizedKind == .conference ? "TBD" : "Online",
            sourceURL: nil,
            note: normalizedKind == .conference ? "用户自定义会议，可用于接收倒计时与通知。" : "用户自定义期刊，按滚动审稿处理。"
        )

        venues[index] = venue
        saveCustomVenues()
        selectedTrack = normalizedTrack
        selectedVenue = venue
    }

    func deleteCustomVenue(_ venue: Venue) {
        guard venue.isCustom else { return }
        venues.removeAll { $0.id == venue.id }
        venueAcceptCounts[venue.id] = nil
        saveCustomVenues()

        if selectedVenueID == venue.id {
            let fallback = venues.first(where: { $0.matches(track: selectedTrack) }) ?? venues.first
            if let fallback {
                selectedVenue = fallback
            }
        }
    }

    func scheduleResultNotification(daysBefore: Int) async {
        let venue = selectedVenue
        guard venue.kind == .conference, let resultDate = venue.resultDate else {
            reminderMessage = "期刊暂无固定开奖时间线"
            return
        }

        guard resultDate > .now else {
            reminderMessage = "\(venue.name) 已开奖"
            return
        }

        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            guard granted else {
                reminderMessage = "通知权限未开启"
                return
            }

            let preferredDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: resultDate) ?? resultDate
            let fireDate = preferredDate > .now ? preferredDate : Calendar.current.date(byAdding: .minute, value: 1, to: .now) ?? .now
            let content = UNMutableNotificationContent()
            content.title = "接论文中稿提醒"
            content.body = venue.notificationBody(relativeTo: fireDate) ?? "距离 \(venue.name) 出结果更近了"
            content.sound = .default

            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
            let requestID = "paper-result-\(venue.id)"
            let request = UNNotificationRequest(
                identifier: requestID,
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            )

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [requestID])
            try await UNUserNotificationCenter.current().add(request)
            reminderMessage = "已设置 \(venue.name) 开奖前 \(daysBefore) 天提醒"
        } catch {
            reminderMessage = "通知设置失败：\(error.localizedDescription)"
        }
    }

    func updateWidgetSelection(enabled: Bool) {
        let defaults = UserDefaults(suiteName: Self.widgetSuiteName) ?? .standard
        let venue = selectedVenue
        defaults.set(enabled, forKey: "widgetPreviewEnabled")
        defaults.set(venue.name, forKey: "widgetVenueName")
        defaults.set(venue.resultDate, forKey: "widgetResultDate")
        defaults.synchronize()

        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }

    @discardableResult
    func runAdvancedAccept(
        userName: String = "老板",
        phrase: String? = nil,
        rate: Float = 0.48,
        pitch: Float = 1.08
    ) -> Bool {
        refreshVIPStatus()
        guard vipUnlocked else { return false }

        acceptCount += 8
        venueAcceptCounts[selectedVenue.id, default: 0] += 8
        lastAdvancedAccept = .now
        UINotificationFeedbackGenerator().notificationOccurred(.success)

        let spokenPhrase = phrase ?? "Congratulations。恭喜\(userName)，即将中稿 \(selectedVenue.name)。审稿人三号已经被你感化。"
        let utterance = AVSpeechUtterance(string: spokenPhrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        if speech.isSpeaking {
            speech.stopSpeaking(at: .immediate)
        }
        speech.speak(utterance)
        return true
    }

    func activateVIP(plan: VIPSubscriptionPlan) {
        let now = Date()
        vipPlanID = plan.id
        vipExpiresAt = plan.expirationDate(from: now)
        vipUnlocked = true
    }

    func redeemCoupon(code: String) -> CouponRedemptionResult {
        let normalizedCode = Self.normalizedCouponCode(code)
        guard !normalizedCode.isEmpty else {
            return CouponRedemptionResult(isSuccess: false, message: "请输入优惠码")
        }

        guard let coupon = remoteConfig.vip?.coupons.first(where: { Self.normalizedCouponCode($0.code) == normalizedCode }) else {
            return CouponRedemptionResult(isSuccess: false, message: "优惠码不存在或暂未同步")
        }

        guard coupon.isEnabled else {
            return CouponRedemptionResult(isSuccess: false, message: "这个优惠码已停用")
        }

        if let expiresAt = coupon.expiresAt, expiresAt <= .now {
            return CouponRedemptionResult(isSuccess: false, message: "这个优惠码已过期")
        }

        guard coupon.durationDays > 0,
              let expirationDate = Calendar.current.date(byAdding: .day, value: coupon.durationDays, to: .now) else {
            return CouponRedemptionResult(isSuccess: false, message: "优惠码配置无效")
        }

        vipPlanID = coupon.planID ?? "coupon.\(coupon.normalizedCode.lowercased())"
        vipExpiresAt = expirationDate
        vipUnlocked = true
        return CouponRedemptionResult(isSuccess: true, message: "\(coupon.title) 已开通 \(coupon.durationDays) 天")
    }

    func remoteCommentTexts(for venue: Venue) -> [String] {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: .now) ?? 0
        let rendered = remoteCommentTemplates
            .map { Self.renderCommentTemplate($0, venue: venue) }
            .filter { !$0.isEmpty }
        return Self.shuffledUnique(rendered, seed: "\(venue.id)-remote-comments-\(day)")
    }

    @discardableResult
    func restoreLocalVIPSubscription() -> Bool {
        refreshVIPStatus()
        return vipUnlocked
    }

    func refreshVIPStatus(now: Date = .now) {
        guard let vipExpiresAt,
              vipExpiresAt > now else {
            if vipUnlocked || vipPlanID != nil || self.vipExpiresAt != nil {
                vipUnlocked = false
                vipPlanID = nil
                self.vipExpiresAt = nil
            }
            return
        }

        if !vipUnlocked {
            vipUnlocked = true
        }
    }

    func refreshRemoteConfig() async {
        do {
            let config = try await remoteConfigService.fetchConfig()
            apply(remoteConfig: config)
        } catch {
            apply(remoteConfig: PaperAcceptRemoteConfig.fallback)
        }
    }

    func refreshFromCCFDDL() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        do {
            let updates = try await ccfddlService.fetchUpdates()
            merge(updates: updates)
            refreshMessage = "已从 CCFDDL 刷新 \(updates.count) 个会议"
        } catch {
            refreshMessage = error.localizedDescription
        }
    }

    private func apply(remoteConfig config: PaperAcceptRemoteConfig) {
        remoteConfig = config

        if let count = config.homepage?.communityAcceptedUserCount,
           count > 0 {
            communityAcceptedUserCount = count
        }

        if let commentConfig = config.comments {
            let limit = max(1, min(commentConfig.maxItems ?? Self.defaultRemoteCommentLimit, Self.defaultRemoteCommentLimit))
            remoteCommentTemplates = Self.mergedRemoteCommentTemplates(
                incoming: commentConfig.templates,
                existing: remoteCommentTemplates,
                limit: limit
            )
        }
    }

    private func merge(updates: [VenueUpdate]) {
        venues = venues.map { venue in
            guard let update = updates.first(where: { $0.id == venue.id }) else {
                return venue
            }

            if let existingYear = venue.year,
               let updateYear = update.year,
               updateYear < existingYear {
                return venue
            }

            var next = venue
            next.year = update.year ?? venue.year
            next.paperDeadline = update.paperDeadline ?? venue.paperDeadline
            next.resultDate = Self.estimatedResultDate(deadline: next.paperDeadline, conferenceStart: update.conferenceStart ?? venue.conferenceStart) ?? venue.resultDate
            next.conferenceStart = update.conferenceStart ?? venue.conferenceStart
            next.dateText = update.dateText ?? venue.dateText
            next.place = update.place ?? venue.place
            next.sourceURL = update.sourceURL ?? venue.sourceURL
            next.categoryCode = update.categoryCode ?? venue.categoryCode
            if let rank = update.ccfRank {
                next.ccfRank = rank
            }
            return next
        }
    }

    private func ensureSelectedVenueMatchesFilters() {
        guard !selectedVenue.matches(track: selectedTrack) || !selectedRankFilter.matches(selectedVenue) else { return }
        if let firstVenue = filteredVenues.first {
            selectedVenue = firstVenue
        }
    }

    private static func categoryCode(for kind: VenueKind, track: VenueTrack) -> String? {
        guard kind == .conference else { return nil }
        switch track {
        case .machineLearning, .computerVision, .naturalLanguage:
            return "AI"
        default:
            return track.ccfCategoryCode
        }
    }

    private static func estimatedResultDate(deadline: Date?, conferenceStart: Date?) -> Date? {
        guard let deadline else { return nil }
        let calendar = Calendar.current
        let estimatedByDeadline = calendar.date(byAdding: .day, value: 90, to: deadline) ?? deadline
        guard let conferenceStart else {
            return estimatedByDeadline
        }

        let latestReasonableDate = calendar.date(byAdding: .day, value: -28, to: conferenceStart) ?? conferenceStart
        if latestReasonableDate > deadline {
            return min(estimatedByDeadline, latestReasonableDate)
        }
        return estimatedByDeadline
    }

    private static let vipDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    private static func isVenueOrderedBefore(_ first: Venue, _ second: Venue) -> Bool {
        let firstHotRank = hotCountdownVenueRanks[first.id] ?? Int.max
        let secondHotRank = hotCountdownVenueRanks[second.id] ?? Int.max
        if firstHotRank != secondHotRank {
            return firstHotRank < secondHotRank
        }

        let firstTrackRank = trackPriority(first.track)
        let secondTrackRank = trackPriority(second.track)
        if firstTrackRank != secondTrackRank {
            return firstTrackRank < secondTrackRank
        }

        let firstRank = rankPriority(first.normalizedCCFRank)
        let secondRank = rankPriority(second.normalizedCCFRank)
        if firstRank != secondRank {
            return firstRank < secondRank
        }

        return first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
    }

    private static func trackPriority(_ track: VenueTrack) -> Int {
        switch track {
        case .ai:
            return 0
        case .computerVision:
            return 1
        case .machineLearning:
            return 2
        case .naturalLanguage:
            return 3
        case .databaseMining:
            return 4
        case .graphicsMultimedia:
            return 5
        case .architectureStorage:
            return 6
        case .networkSystem:
            return 7
        case .security:
            return 8
        case .softwareSystem:
            return 9
        case .theory:
            return 10
        case .humanComputerInteraction:
            return 11
        case .interdisciplinary:
            return 12
        case .journal:
            return 13
        case .all:
            return 99
        }
    }

    private static func rankPriority(_ rank: String) -> Int {
        switch rank {
        case "A":
            return 0
        case "B":
            return 1
        case "C":
            return 2
        case "N":
            return 3
        default:
            return 4
        }
    }

    private var hotCountdownVenueIDs: [String] {
        let remoteIDs = remoteConfig.countdown?.hotVenueIDs
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty } ?? []
        return remoteIDs.isEmpty ? Self.defaultHotCountdownVenueIDs : remoteIDs
    }

    private var hotCountdownVenueRanks: [String: Int] {
        var ranks: [String: Int] = [:]
        for (index, id) in hotCountdownVenueIDs.enumerated() where ranks[id] == nil {
            ranks[id] = index
        }
        return ranks
    }

    private static let defaultHotCountdownVenueIDs = [
        "neurips", "icml", "iclr", "cvpr", "iccv", "eccv", "aaai", "ijcai",
        "acl", "emnlp", "naacl", "colm", "kdd", "sigmod", "vldb", "www",
        "sigir", "chi", "uist", "usenix-security", "ccs", "sosp", "osdi",
        "nsdi", "siggraph", "mm", "fse", "icse"
    ]

    private static let hotCountdownVenueRanks = Dictionary(
        uniqueKeysWithValues: defaultHotCountdownVenueIDs.enumerated().map { index, id in
            (id, index)
        }
    )

    private static func normalizedCouponCode(_ code: String) -> String {
        code
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
    }

    private static func renderCommentTemplate(_ template: String, venue: Venue) -> String {
        let replacements = [
            "{venue}": venue.name,
            "{fullName}": venue.fullName,
            "{track}": venue.track.title,
            "{category}": venue.categoryTitle,
            "{rank}": venue.displayRank,
            "{kind}": venue.kind.rawValue,
            "{year}": venue.year.map { String($0) } ?? "今年"
        ]

        let trimmed = template.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }
        return replacements.reduce(trimmed) { result, replacement in
            result.replacingOccurrences(of: replacement.key, with: replacement.value)
        }
    }

    private static func mergedRemoteCommentTemplates(
        incoming: [String],
        existing: [String],
        limit: Int
    ) -> [String] {
        var seen: Set<String> = []
        var merged: [String] = []

        for template in incoming + existing {
            let trimmed = template.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty,
                  seen.insert(trimmed).inserted else {
                continue
            }
            merged.append(trimmed)
            if merged.count >= limit {
                break
            }
        }

        return merged
    }

    private static func shuffledUnique(_ comments: [String], seed: String) -> [String] {
        var seen: Set<String> = []
        return comments
            .filter { seen.insert($0).inserted }
            .enumerated()
            .map { index, comment in
                (score: stableHash("\(seed)-\(index)-\(comment)"), comment: comment)
            }
            .sorted { first, second in
                if first.score == second.score {
                    return first.comment < second.comment
                }
                return first.score < second.score
            }
            .map(\.comment)
    }

    private static func stableHash(_ text: String) -> UInt64 {
        var hash: UInt64 = 1_469_598_103_934_665_603
        for byte in text.utf8 {
            hash ^= UInt64(byte)
            hash &*= 1_099_511_628_211
        }
        return hash
    }

    private func makeCustomVenueID(from name: String) -> String {
        let baseName = name
            .lowercased()
            .filter { $0.isLetter || $0.isNumber }
        let base = "custom-\(baseName.isEmpty ? String(UUID().uuidString.prefix(8)).lowercased() : baseName)"
        var candidate = base
        var suffix = 2
        while venues.contains(where: { $0.id == candidate }) {
            candidate = "\(base)-\(suffix)"
            suffix += 1
        }
        return candidate
    }

    private func saveCustomVenues() {
        Self.saveCustomVenues(venues.filter(\.isCustom))
    }

    private static func loadVenueAcceptCounts() -> [String: Int] {
        guard let data = UserDefaults.standard.data(forKey: "venueAcceptCounts"),
              let counts = try? JSONDecoder().decode([String: Int].self, from: data) else {
            return [:]
        }
        return counts
    }

    private static func loadCommunityAcceptedUserCount() -> Int {
        let key = "communityAcceptedUserCount"
        let defaults = UserDefaults.standard
        let storedCount = defaults.integer(forKey: key)
        if storedCount > 0 {
            return storedCount
        }

        let randomCount = Int.random(in: 980...3600)
        defaults.set(randomCount, forKey: key)
        return randomCount
    }

    private static func saveVenueAcceptCounts(_ counts: [String: Int]) {
        guard let data = try? JSONEncoder().encode(counts) else { return }
        UserDefaults.standard.set(data, forKey: "venueAcceptCounts")
    }

    private static func loadRemoteCommentTemplates() -> [String] {
        guard let data = UserDefaults.standard.data(forKey: remoteCommentTemplatesKey),
              let templates = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return Array(templates.prefix(defaultRemoteCommentLimit))
    }

    private static func saveRemoteCommentTemplates(_ templates: [String]) {
        guard let data = try? JSONEncoder().encode(Array(templates.prefix(defaultRemoteCommentLimit))) else { return }
        UserDefaults.standard.set(data, forKey: remoteCommentTemplatesKey)
    }

    private static func loadCustomVenues() -> [Venue] {
        guard let data = UserDefaults.standard.data(forKey: "customVenues"),
              let venues = try? JSONDecoder().decode([Venue].self, from: data) else {
            return []
        }
        return venues
    }

    private static func saveCustomVenues(_ venues: [Venue]) {
        guard let data = try? JSONEncoder().encode(venues) else { return }
        UserDefaults.standard.set(data, forKey: "customVenues")
    }

    private static func dateText(for kind: VenueKind, resultDate: Date?) -> String {
        guard kind == .conference else { return "Rolling submission" }
        guard let resultDate else { return "Result date TBD" }
        return "Result: \(resultDate.formatted(.dateTime.year().month(.abbreviated).day().hour().minute()))"
    }
}
