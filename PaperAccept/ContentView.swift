import SwiftUI

private struct AcceptBurst: Identifiable {
    let id = UUID()
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotation: Double
}

private struct PaperComment: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isVIP: Bool
    let styleIndex: Int
}

private enum VIPEffect: String, CaseIterable, Identifiable {
    case confetti
    case goldRain
    case fireworks
    case starfield
    case spotlight
    case acceptSeal
    case balloons

    var id: String { rawValue }

    var title: String {
        switch self {
        case .confetti:
            return "彩带"
        case .goldRain:
            return "金榜"
        case .fireworks:
            return "烟花"
        case .starfield:
            return "星河"
        case .spotlight:
            return "聚光"
        case .acceptSeal:
            return "盖章"
        case .balloons:
            return "气球"
        }
    }

    var icon: String {
        switch self {
        case .confetti:
            return "party.popper.fill"
        case .goldRain:
            return "trophy.fill"
        case .fireworks:
            return "sparkles"
        case .starfield:
            return "sparkle.magnifyingglass"
        case .spotlight:
            return "lightspectrum.horizontal"
        case .acceptSeal:
            return "checkmark.seal.fill"
        case .balloons:
            return "balloon.2.fill"
        }
    }
}

private enum AdvancedVoiceStyle: String, CaseIterable, Identifiable {
    case gentle
    case advisor
    case pcChair
    case reviewer
    case labmate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .gentle:
            return "温柔版"
        case .advisor:
            return "导师版"
        case .pcChair:
            return "PC Chair"
        case .reviewer:
            return "Reviewer"
        case .labmate:
            return "同门版"
        }
    }

    var icon: String {
        switch self {
        case .gentle:
            return "heart.fill"
        case .advisor:
            return "graduationcap.fill"
        case .pcChair:
            return "person.3.fill"
        case .reviewer:
            return "text.bubble.fill"
        case .labmate:
            return "person.2.fill"
        }
    }

    var rate: Float {
        switch self {
        case .gentle:
            return 0.43
        case .advisor:
            return 0.46
        case .pcChair:
            return 0.44
        case .reviewer:
            return 0.45
        case .labmate:
            return 0.52
        }
    }

    var pitch: Float {
        switch self {
        case .gentle:
            return 1.16
        case .advisor:
            return 0.94
        case .pcChair:
            return 1.00
        case .reviewer:
            return 0.98
        case .labmate:
            return 1.12
        }
    }

    func phrase(userName: String, venue: Venue) -> String {
        switch self {
        case .gentle:
            return "Congratulations。\(userName)，你的 \(venue.name) 论文正在被好运温柔托住，愿所有审稿人都看见它的闪光点。"
        case .advisor:
            return "Congratulations。\(userName)，\(venue.name) 这篇工作思路清楚，实验扎实，今晚不用加班，准备庆祝。"
        case .pcChair:
            return "Congratulations。Program Chair 通知，\(userName) 的 \(venue.name) 投稿讨论积极，最终决定正在向 accept 靠拢。"
        case .reviewer:
            return "Congratulations。Reviewer 三号表示，\(userName) 的 \(venue.name) 论文贡献明确，实验充分，我倾向接收。"
        case .labmate:
            return "Congratulations。同门们注意，\(userName) 的 \(venue.name) 要中了，奶茶先记账，camera ready 马上安排。"
        }
    }
}

private enum WoodFishStyle: String, CaseIterable, Identifiable {
    case classic
    case acceptSeal
    case rocket
    case trophy
    case scholar
    case magic

    var id: String { rawValue }

    var title: String {
        switch self {
        case .classic:
            return "木鱼"
        case .acceptSeal:
            return "中稿章"
        case .rocket:
            return "起飞"
        case .trophy:
            return "金杯"
        case .scholar:
            return "学术帽"
        case .magic:
            return "玄学棒"
        }
    }

    var symbol: String {
        switch self {
        case .classic:
            return "fish.fill"
        case .acceptSeal:
            return "checkmark.seal.fill"
        case .rocket:
            return "rocket.fill"
        case .trophy:
            return "trophy.fill"
        case .scholar:
            return "graduationcap.fill"
        case .magic:
            return "wand.and.stars"
        }
    }

    var caption: String {
        switch self {
        case .classic:
            return "accept"
        case .acceptSeal:
            return "accepted"
        case .rocket:
            return "ready"
        case .trophy:
            return "winner"
        case .scholar:
            return "camera ready"
        case .magic:
            return "blessing"
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .classic:
            return [
                Color(red: 0.90, green: 0.60, blue: 0.27),
                Color(red: 0.55, green: 0.28, blue: 0.14),
                Color(red: 0.30, green: 0.13, blue: 0.08)
            ]
        case .acceptSeal:
            return [
                Color(red: 0.96, green: 0.70, blue: 0.22),
                Color(red: 0.88, green: 0.32, blue: 0.28),
                Color(red: 0.48, green: 0.10, blue: 0.13)
            ]
        case .rocket:
            return [
                Color(red: 0.35, green: 0.77, blue: 0.96),
                Color(red: 0.17, green: 0.43, blue: 0.78),
                Color(red: 0.09, green: 0.13, blue: 0.32)
            ]
        case .trophy:
            return [
                Color(red: 1.00, green: 0.86, blue: 0.32),
                Color(red: 0.93, green: 0.46, blue: 0.18),
                Color(red: 0.44, green: 0.21, blue: 0.08)
            ]
        case .scholar:
            return [
                Color(red: 0.34, green: 0.82, blue: 0.66),
                Color(red: 0.13, green: 0.47, blue: 0.47),
                Color(red: 0.05, green: 0.17, blue: 0.22)
            ]
        case .magic:
            return [
                Color(red: 0.78, green: 0.56, blue: 0.98),
                Color(red: 0.45, green: 0.27, blue: 0.76),
                Color(red: 0.17, green: 0.10, blue: 0.31)
            ]
        }
    }

    var accentColor: Color {
        switch self {
        case .classic:
            return Color.acceptGold
        case .acceptSeal:
            return Color.acceptRose
        case .rocket:
            return Color.acceptBlue
        case .trophy:
            return Color.acceptGold
        case .scholar:
            return Color.acceptMint
        case .magic:
            return Color(red: 0.66, green: 0.44, blue: 0.92)
        }
    }
}

struct ContentView: View {
    @StateObject private var model = PaperAcceptViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("selectedWoodFishStyle") private var selectedWoodFishStyleRaw = WoodFishStyle.classic.rawValue
    @AppStorage("selectedVoiceStyle") private var selectedVoiceStyleRaw = AdvancedVoiceStyle.gentle.rawValue
    @AppStorage("widgetPreviewEnabled") private var widgetPreviewEnabled = false
    @AppStorage("notificationLeadDays") private var notificationLeadDays = 3
    @State private var woodFishPressed = false
    @State private var acceptBursts: [AcceptBurst] = []
    @State private var commentDraft = ""
    @State private var commentRevision = 0
    @State private var commentsByVenue: [String: [PaperComment]] = [:]
    @State private var vipUserName = ""
    @State private var selectedVIPEffect: VIPEffect = .confetti
    @State private var showAddVenue = false
    @State private var showVenueSearch = false
    @State private var venueScrollTargetID: String?
    @State private var editingVenue: Venue?
    @State private var showPaywall = false
    @State private var showCelebration = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        HeaderView(
                            acceptCount: model.acceptCount,
                            communityAcceptedUserCount: model.communityAcceptedUserCount,
                            selectedVenue: model.selectedVenue
                        )

                        TrackSelector(
                            selectedTrack: model.selectedTrack,
                            selectedRank: model.selectedRankFilter,
                            tracks: VenueTrack.allCases,
                            rankFilters: VenueRankFilter.allCases,
                            onSelect: model.select(track:),
                            onSearch: { showVenueSearch = true },
                            onSelectRank: model.select(rankFilter:)
                        )

                        VenuePickerView(
                            venues: model.filteredVenues,
                            selectedVenue: model.selectedVenue,
                            scrollTargetID: venueScrollTargetID,
                            onSelect: model.select,
                            onAdd: { showAddVenue = true },
                            onEdit: { editingVenue = $0 },
                            onScrollTargetHandled: { venueScrollTargetID = nil }
                        )

                        WoodFishSection(
                            venue: model.selectedVenue,
                            venueAcceptCount: model.selectedVenueAcceptCount,
                            style: model.vipUnlocked ? selectedWoodFishStyle : .classic,
                            isPressed: woodFishPressed,
                            acceptBursts: acceptBursts,
                            comments: comments(for: model.selectedVenue),
                            commentRevision: commentRevision,
                            commentDraft: $commentDraft,
                            onStrike: strikeWoodFish,
                            onSubmitComment: submitComment
                        )

                        PremiumAcceptPanel(
                            venue: model.selectedVenue,
                            isVIP: model.vipUnlocked,
                            vipStatusText: model.vipSubscriptionStatusText,
                            userName: $vipUserName,
                            selectedEffect: selectedVIPEffect,
                            selectedVoiceStyle: selectedVoiceStyle,
                            selectedWoodFishStyle: selectedWoodFishStyle,
                            onSelectEffect: { selectedVIPEffect = $0 },
                            onSelectVoiceStyle: { selectedVoiceStyleRaw = $0.rawValue },
                            onSelectWoodFishStyle: { selectedWoodFishStyleRaw = $0.rawValue },
                            onUnlock: { showPaywall = true },
                            onAdvancedAccept: runAdvancedAccept
                        )

                        ReminderWidgetPanel(
                            venue: model.selectedVenue,
                            reminderMessage: model.reminderMessage,
                            widgetPreviewEnabled: $widgetPreviewEnabled,
                            notificationLeadDays: $notificationLeadDays,
                            onScheduleNotification: {
                                Task {
                                    await model.scheduleResultNotification(daysBefore: notificationLeadDays)
                                }
                            },
                            onSaveWidget: {
                                withAnimation(.snappy) {
                                    widgetPreviewEnabled = true
                                }
                                model.updateWidgetSelection(enabled: true)
                            }
                        )

                        CountdownSection(
                            featuredVenues: model.featuredCountdowns,
                            selectedTrack: model.selectedTrack,
                            selectedRank: model.selectedRankFilter,
                            refreshMessage: model.refreshMessage
                        )
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 6)
                    .padding(.bottom, 32)
                }
                .refreshable {
                    await model.refreshRemoteConfig()
                    await model.refreshFromCCFDDL()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .task {
                model.refreshVIPStatus()
                await model.refreshRemoteConfig()
                await model.refreshFromCCFDDL()
                model.updateWidgetSelection(enabled: widgetPreviewEnabled)
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    model.refreshVIPStatus()
                }
            }
            .onChange(of: widgetPreviewEnabled) { _, enabled in
                model.updateWidgetSelection(enabled: enabled)
            }
            .onChange(of: model.selectedVenue) { _, _ in
                model.updateWidgetSelection(enabled: widgetPreviewEnabled)
            }
            .sheet(isPresented: $showPaywall) {
                VIPPaywallView(
                    venue: model.selectedVenue,
                    benefits: model.vipBenefitTexts,
                    paywallNotice: model.vipPaywallNotice,
                    onSubscribe: { plan in
                        model.activateVIP(plan: plan)
                        showPaywall = false
                    },
                    onRedeemCoupon: { code in
                        model.redeemCoupon(code: code)
                    },
                    onRestore: {
                        model.restoreLocalVIPSubscription()
                    }
                )
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showAddVenue) {
                AddVenueSheet(
                    mode: .add,
                    defaultTrack: model.selectedTrack,
                    onSave: { name, fullName, kind, track, ccfRank, year, resultDate in
                        model.addCustomVenue(
                            name: name,
                            fullName: fullName,
                            kind: kind,
                            track: track,
                            ccfRank: ccfRank,
                            year: year,
                            resultDate: resultDate
                        )
                    }
                )
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showVenueSearch) {
                VenueSearchSheet(
                    venues: model.venues,
                    onSelect: selectSearchResult,
                    onAddCustom: openCustomVenueFromSearch
                )
                .presentationDetents([.medium, .large])
            }
            .sheet(item: $editingVenue) { venue in
                AddVenueSheet(
                    mode: .edit(venue),
                    defaultTrack: venue.track,
                    onSave: { name, fullName, kind, track, ccfRank, year, resultDate in
                        model.updateCustomVenue(
                            id: venue.id,
                            name: name,
                            fullName: fullName,
                            kind: kind,
                            track: track,
                            ccfRank: ccfRank,
                            year: year,
                            resultDate: resultDate
                        )
                    },
                    onDelete: {
                        model.deleteCustomVenue(venue)
                        editingVenue = nil
                    }
                )
                .presentationDetents([.large])
            }
            .overlay {
                if showCelebration {
                    VIPCelebrationOverlay(
                        venueName: model.selectedVenue.name,
                        userName: vipDisplayName,
                        venueAcceptCount: model.selectedVenueAcceptCount,
                        effect: selectedVIPEffect,
                        isPresented: $showCelebration
                    )
                    .transition(.opacity.combined(with: .scale(scale: 1.04)))
                }
            }
        }
    }

    private func strikeWoodFish() {
        model.strikeWoodFish()
        let burst = AcceptBurst(
            xOffset: CGFloat.random(in: -72...72),
            yOffset: CGFloat.random(in: -20...24),
            rotation: Double.random(in: -10...10)
        )
        withAnimation(.spring(response: 0.18, dampingFraction: 0.48)) {
            woodFishPressed = true
            acceptBursts.append(burst)
        }
        Task {
            try? await Task.sleep(for: .milliseconds(220))
            await MainActor.run {
                withAnimation(.spring(response: 0.22, dampingFraction: 0.72)) {
                    woodFishPressed = false
                }
            }
            try? await Task.sleep(for: .milliseconds(1_050))
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.2)) {
                    acceptBursts.removeAll { $0.id == burst.id }
                }
            }
        }
    }

    private func comments(for venue: Venue) -> [PaperComment] {
        let localComments = commentsByVenue[venue.id] ?? []
        let remoteComments = model.remoteCommentTexts(for: venue).map {
            PaperComment(text: $0, isVIP: false, styleIndex: 0)
        }
        return localComments + Self.interleavedComments(
            primary: remoteComments,
            secondary: SampleComments.comments(for: venue)
        )
    }

    private static func interleavedComments(
        primary: [PaperComment],
        secondary: [PaperComment]
    ) -> [PaperComment] {
        guard !primary.isEmpty else { return secondary }
        guard !secondary.isEmpty else { return primary }

        var result: [PaperComment] = []
        let maxCount = max(primary.count, secondary.count)
        for index in 0..<maxCount {
            if index < primary.count {
                result.append(primary[index])
            }
            if index < secondary.count {
                result.append(secondary[index])
            }
        }
        return result
    }

    private func submitComment() {
        let message = commentDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        model.refreshVIPStatus()
        let comment = PaperComment(
            text: message,
            isVIP: model.vipUnlocked,
            styleIndex: Int.random(in: 0..<5)
        )
        commentsByVenue[model.selectedVenue.id, default: []].insert(comment, at: 0)
        commentRevision += 1
        commentDraft = ""
    }

    private func runAdvancedAccept() {
        let didRun = model.runAdvancedAccept(
            userName: vipDisplayName,
            phrase: selectedVoiceStyle.phrase(userName: vipDisplayName, venue: model.selectedVenue),
            rate: selectedVoiceStyle.rate,
            pitch: selectedVoiceStyle.pitch
        )
        guard didRun else {
            showPaywall = true
            return
        }
        withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
            showCelebration = true
        }
    }

    private func selectSearchResult(_ venue: Venue) {
        showVenueSearch = false
        withAnimation(.snappy) {
            model.select(track: .all)
            model.select(venue)
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(180))
            venueScrollTargetID = venue.id
        }
    }

    private func openCustomVenueFromSearch() {
        showVenueSearch = false
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(220))
            showAddVenue = true
        }
    }

    private var vipDisplayName: String {
        let trimmed = vipUserName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "老板" : trimmed
    }

    private var selectedWoodFishStyle: WoodFishStyle {
        WoodFishStyle(rawValue: selectedWoodFishStyleRaw) ?? .classic
    }

    private var selectedVoiceStyle: AdvancedVoiceStyle {
        AdvancedVoiceStyle(rawValue: selectedVoiceStyleRaw) ?? .gentle
    }
}

private struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                .paperSurface,
                Color(red: 0.93, green: 0.98, blue: 0.95),
                Color(red: 0.97, green: 0.92, blue: 0.88)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(alignment: .topTrailing) {
            Rectangle()
                .fill(Color.acceptGold.opacity(0.16))
                .frame(width: 140, height: 220)
                .rotationEffect(.degrees(18))
                .offset(x: 80, y: -80)
        }
        .ignoresSafeArea()
    }
}

private struct HeaderView: View {
    let acceptCount: Int
    let communityAcceptedUserCount: Int
    let selectedVenue: Venue

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("已有 \(communityAcceptedUserCount.formatted(.number.grouping(.automatic))) 个用户论文被接收")
                        .font(.caption.weight(.black))
                        .monospacedDigit()
                        .foregroundStyle(Color.acceptRose)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("接论文中稿")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(Color.paperInk)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    venueTitleLink
                }

                VStack(alignment: .trailing, spacing: 3) {
                    Text("ACCEPT")
                        .font(.caption2.weight(.black))
                        .foregroundStyle(Color.acceptRose)
                    Text("+\(acceptCount)")
                        .font(.system(size: 27, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(Color.paperInk)
                }
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(.white.opacity(0.84), in: RoundedRectangle(cornerRadius: 8))
            }

            HStack(spacing: 8) {
                Label(selectedVenue.displayRank, systemImage: "rosette")
                Label(selectedVenue.kind.rawValue, systemImage: selectedVenue.kind == .conference ? "person.3.fill" : "doc.text.fill")
                Label(selectedVenue.categoryTitle, systemImage: "tag.fill")
            }
            .font(.caption.weight(.bold))
            .foregroundStyle(Color.paperInk.opacity(0.78))
        }
    }

    @ViewBuilder
    private var venueTitleLink: some View {
        if let sourceURL = selectedVenue.sourceURL {
            Link(destination: sourceURL) {
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text(selectedVenue.fullName)
                        .lineLimit(2)
                    Image(systemName: "arrow.up.right")
                        .font(.caption.weight(.black))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        } else {
            Text(selectedVenue.fullName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct TrackSelector: View {
    let selectedTrack: VenueTrack
    let selectedRank: VenueRankFilter
    let tracks: [VenueTrack]
    let rankFilters: [VenueRankFilter]
    let onSelect: (VenueTrack) -> Void
    let onSearch: () -> Void
    let onSelectRank: (VenueRankFilter) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass")
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color.paperInk)
                        .frame(width: 30, height: 30)
                        .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("搜索会议或期刊")

                RankDropdownMenu(
                    selectedRank: selectedRank,
                    filters: rankFilters,
                    onSelect: onSelectRank
                )

                ForEach(tracks) { track in
                    Button {
                        withAnimation(.snappy) {
                            onSelect(track)
                        }
                    } label: {
                        Text(track.title)
                            .font(.caption.weight(.black))
                            .padding(.horizontal, 10)
                            .frame(height: 30)
                            .foregroundStyle(selectedTrack == track ? Color.white : Color.paperInk)
                            .background(
                                selectedTrack == track ? Color.paperInk : .white.opacity(0.78),
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct RankDropdownMenu: View {
    let selectedRank: VenueRankFilter
    let filters: [VenueRankFilter]
    let onSelect: (VenueRankFilter) -> Void

    var body: some View {
        Menu {
            ForEach(filters) { filter in
                Button {
                    withAnimation(.snappy) {
                        onSelect(filter)
                    }
                } label: {
                    if selectedRank == filter {
                        Label(filter.menuTitle, systemImage: "checkmark")
                    } else {
                        Text(filter.menuTitle)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedRank.compactTitle)
                    .monospacedDigit()

                Image(systemName: "chevron.down")
                    .font(.caption2.weight(.black))
            }
            .font(.caption.weight(.black))
            .foregroundStyle(Color.white)
            .padding(.horizontal, 9)
            .frame(height: 30)
            .background(Color.acceptRose, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("选择 CCF 分级")
    }
}

private struct VenuePickerView: View {
    let venues: [Venue]
    let selectedVenue: Venue
    let scrollTargetID: String?
    let onSelect: (Venue) -> Void
    let onAdd: () -> Void
    let onEdit: (Venue) -> Void
    let onScrollTargetHandled: () -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    addVenueButton
                        .id("add-venue")

                    ForEach(venues) { venue in
                        ZStack(alignment: .topTrailing) {
                            Button {
                                withAnimation(.snappy) {
                                    onSelect(venue)
                                }
                            } label: {
                                venueCard(for: venue)
                            }
                            .buttonStyle(.plain)

                            if venue.isCustom {
                                Button {
                                    onEdit(venue)
                                } label: {
                                    Image(systemName: "pencil")
                                        .font(.caption.weight(.black))
                                        .foregroundStyle(Color.paperInk)
                                        .frame(width: 28, height: 28)
                                        .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.paperInk.opacity(0.10), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(.plain)
                                .padding(7)
                            }
                        }
                        .id(venue.id)
                    }
                }
            }
            .onChange(of: scrollTargetID) { _, targetID in
                guard let targetID else { return }
                withAnimation(.snappy) {
                    proxy.scrollTo(targetID, anchor: .center)
                }
                onScrollTargetHandled()
            }
        }
    }

    private func venueCard(for venue: Venue) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(venue.name)
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color.paperInk)
                    .lineLimit(1)
                Spacer()
                Image(systemName: venue.kind == .conference ? "graduationcap.fill" : "newspaper.fill")
                    .foregroundStyle(color(for: venue))
                    .opacity(venue.isCustom ? 0.0 : 1.0)
            }
            Text(venue.fullName)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                Text(venue.displayRank)
                Spacer()
                Text(venue.year.map(String.init) ?? venue.categoryTitle)
            }
            .font(.caption2.weight(.black))
            .foregroundStyle(Color.paperInk.opacity(0.68))
        }
        .padding(10)
        .frame(width: 144, height: 104)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selectedVenue.id == venue.id ? color(for: venue) : .clear, lineWidth: 2)
        )
    }

    private var addVenueButton: some View {
        Button(action: onAdd) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .top) {
                    Text("自定义")
                        .font(.callout.weight(.black))
                        .foregroundStyle(Color.paperInk.opacity(0.72))
                        .frame(height: 30, alignment: .center)
                    Spacer()
                    Image(systemName: "plus")
                        .font(.callout.weight(.black))
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(Color.acceptRose, in: Circle())
                }

                Spacer(minLength: 2)

                Text("添加")
                    .font(.caption)
                    .foregroundStyle(Color.paperInk)
                Text("会议 / 期刊")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            .frame(width: 144, height: 104)
            .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.acceptMint.opacity(0.22), style: StrokeStyle(lineWidth: 1.2, dash: [5, 4]))
            )
        }
        .buttonStyle(.plain)
    }

    private func color(for venue: Venue) -> Color {
        switch venue.track {
        case .ai:
            return Color.acceptRose
        case .computerVision:
            return Color.acceptMint
        case .machineLearning:
            return Color.acceptBlue
        case .naturalLanguage:
            return Color.acceptGold
        case .databaseMining:
            return Color(red: 0.46, green: 0.36, blue: 0.78)
        case .graphicsMultimedia:
            return Color(red: 0.86, green: 0.42, blue: 0.24)
        case .architectureStorage, .networkSystem, .security, .softwareSystem, .theory, .humanComputerInteraction, .interdisciplinary:
            return Color.paperInk.opacity(0.72)
        case .journal:
            return .purple
        case .all:
            return Color.paperInk
        }
    }
}

private struct VenueSearchSheet: View {
    let venues: [Venue]
    let onSelect: (Venue) -> Void
    let onAddCustom: () -> Void

    @State private var query = ""

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var filteredVenues: [Venue] {
        let normalizedQuery = normalized(trimmedQuery)
        guard !normalizedQuery.isEmpty else { return venues }

        return venues
            .compactMap { venue -> (Venue, Int)? in
                guard let score = score(for: venue, query: normalizedQuery) else { return nil }
                return (venue, score)
            }
            .sorted { first, second in
                if first.1 == second.1 {
                    return first.0.name < second.0.name
                }
                return first.1 < second.1
            }
            .map(\.0)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("搜索会议 / 期刊")
                        .font(.title2.weight(.black))
                        .foregroundStyle(Color.paperInk)

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.callout.weight(.black))
                            .foregroundStyle(.secondary)
                        TextField("输入 ICLR、CVPR、TPAMI...", text: $query)
                            .font(.callout.weight(.semibold))
                            .textInputAutocapitalization(.never)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 8))
                }

                if filteredVenues.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("没有找到相似项目", systemImage: "questionmark.folder.fill")
                            .font(.headline.weight(.black))
                            .foregroundStyle(Color.paperInk)
                        Text("可以用左侧自定义卡片添加新的会议或期刊。")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)

                        Button(action: onAddCustom) {
                            Label("去自定义添加", systemImage: "plus.circle.fill")
                                .font(.callout.weight(.black))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.paperInk, in: RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 8))
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
                            ForEach(filteredVenues) { venue in
                                Button {
                                    onSelect(venue)
                                } label: {
                                    VenueSearchRow(venue: venue)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(18)
            .background(Color.paperSurface.ignoresSafeArea())
        }
    }

    private func score(for venue: Venue, query: String) -> Int? {
        let fields = searchableFields(for: venue)
        if normalized(venue.name) == query {
            return 0
        }
        if normalized(venue.name).hasPrefix(query) {
            return 1
        }
        if fields.contains(where: { $0.hasPrefix(query) }) {
            return 2
        }
        if fields.contains(where: { $0.contains(query) }) {
            return 3
        }

        let tokens = query.split(separator: " ").map(String.init)
        if !tokens.isEmpty,
           tokens.allSatisfy({ token in fields.contains(where: { $0.contains(token) }) }) {
            return 4
        }

        return nil
    }

    private func searchableFields(for venue: Venue) -> [String] {
        [
            venue.name,
            venue.fullName,
            venue.kind.rawValue,
            venue.track.title,
            venue.categoryTitle,
            venue.categoryCode ?? "",
            venue.displayRank,
            venue.year.map(String.init) ?? ""
        ]
        .map(normalized)
        .filter { !$0.isEmpty }
    }

    private func normalized(_ text: String) -> String {
        text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}

private struct VenueSearchRow: View {
    let venue: Venue

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: venue.kind == .conference ? "graduationcap.fill" : "newspaper.fill")
                .font(.headline.weight(.black))
                .foregroundStyle(iconColor)
                .frame(width: 34, height: 34)
                .background(iconColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(venue.name)
                        .font(.headline.weight(.black))
                        .foregroundStyle(Color.paperInk)
                    if venue.isCustom {
                        Text("自定义")
                            .font(.caption2.weight(.black))
                            .foregroundStyle(Color.acceptRose)
                            .padding(.horizontal, 6)
                            .frame(height: 18)
                            .background(Color.acceptRose.opacity(0.10), in: RoundedRectangle(cornerRadius: 6))
                    }
                }
                Text(venue.fullName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                HStack(spacing: 7) {
                    Text(venue.displayRank)
                    Text(venue.kind.rawValue)
                    Text(venue.categoryTitle)
                }
                .font(.caption2.weight(.black))
                .foregroundStyle(Color.paperInk.opacity(0.58))
            }

            Spacer()

            Image(systemName: "arrow.right")
                .font(.caption.weight(.black))
                .foregroundStyle(.secondary)
        }
        .padding(11)
        .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 8))
    }

    private var iconColor: Color {
        switch venue.track {
        case .ai:
            return Color.acceptRose
        case .computerVision:
            return Color.acceptMint
        case .machineLearning:
            return Color.acceptBlue
        case .naturalLanguage:
            return Color.acceptGold
        case .databaseMining:
            return Color(red: 0.46, green: 0.36, blue: 0.78)
        case .graphicsMultimedia:
            return Color(red: 0.86, green: 0.42, blue: 0.24)
        case .architectureStorage, .networkSystem, .security, .softwareSystem, .theory, .humanComputerInteraction, .interdisciplinary:
            return Color.paperInk.opacity(0.72)
        case .journal:
            return .purple
        case .all:
            return Color.paperInk
        }
    }
}

private enum SampleComments {
    static func comments(for venue: Venue) -> [PaperComment] {
        let comments = unique(commonComments(for: venue) + trackComments(for: venue))
        let day = Calendar.current.ordinality(of: .day, in: .era, for: .now) ?? 0
        return shuffled(comments, seed: "\(venue.id)-\(day)")
            .map(Self.standardComment)
    }

    private static func standardComment(_ text: String) -> PaperComment {
        PaperComment(text: text, isVIP: false, styleIndex: 0)
    }

    private static func commonComments(for venue: Venue) -> [String] {
        let openers = [
            "\(venue.name) 今天请给 accept",
            "\(venue.name) 审稿人请温柔一点",
            "敲一下 \(venue.name)",
            "给 \(venue.name) 加一层好运",
            "\(venue.name) 的 accept 正在加载",
            "求 \(venue.name) 给个好消息",
            "\(venue.name) 这轮稳住",
            "论文好运传到 \(venue.name)",
            "\(venue.name) 程序委员会看过来",
            "为 \(venue.name) 攒一口气",
            "\(venue.name) 玄学线程启动",
            "今天先给 \(venue.name) 上香",
            "\(venue.name) 不要卡我毕业",
            "愿 \(venue.name) reviewer 心情晴朗",
            "\(venue.name) 请相信这个 contribution",
            "给 \(venue.name) 的 meta-review 加点糖",
            "\(venue.name) 的 rebuttal 需要回响",
            "希望 \(venue.name) 分数开始上扬",
            "\(venue.name) 的讨论区请保持友善",
            "接住 \(venue.name) 的 camera ready"
        ]

        let endings = [
            "实验曲线已经很会说话",
            "rebuttal 字字有回响",
            "创新点请被准确看见",
            "审稿人今天一定手软",
            "老板说中了请喝奶茶",
            "显著性检验都站在我们这边",
            "ablation 表格已经排好队",
            "appendix 也在努力发光",
            "related work 写得很诚恳",
            "limitations 诚实但不致命",
            "代码开源会带来好运",
            "补实验速度已经拉满",
            "弱接收也是接收",
            "强接收也不是不可以",
            "meta reviewer 请给机会",
            "所有 typo 都自动消失",
            "figure 排版已经端正",
            "匿名身份稳如磐石",
            "讨论区气氛逐渐变好",
            "结果邮件请写 congratulations"
        ]

        let shortWishes = [
            "求一个 weak accept 也行",
            "求一个 strong accept 更好",
            "玄学先上，实验随后",
            "今天不看拒稿邮件",
            "先敲为敬，后补实验",
            "审稿意见请轻拿轻放",
            "分数别掉，排名别崩",
            "discussion 请往好处走",
            "rebuttal 已经尽力了",
            "投稿系统请善待我们",
            "camera ready 文件夹已创建",
            "ddl 前的努力都算数",
            "愿邮件标题出现 accepted",
            "愿老板今晚早睡",
            "愿同门都来蹭喜气",
            "愿 reviewer 二号忽然懂了",
            "愿 reviewer 三号改分",
            "愿 meta review 温柔收尾",
            "愿 rebuttal 句句命中",
            "愿 novelty 被认真看见"
        ]

        return combine(openers, endings, limit: 200) { "\($0)，\($1)" } + shortWishes
    }

    private static func trackComments(for venue: Venue) -> [String] {
        switch venue.track {
        case .machineLearning:
            return generatedTrackComments(
                venue: venue,
                subjects: [
                    "loss 曲线", "泛化误差", "收敛证明", "baseline 对比", "消融实验",
                    "超参搜索", "训练日志", "OpenReview 匿名区", "理论界限", "benchmark 排名",
                    "seed 稳定性", "scaling law"
                ],
                endings: [
                    "已经收敛到 accept", "看起来非常可信", "终于不再抖动", "正在给 reviewer 安心感",
                    "把 novelty 托起来了", "让 rebuttal 更有底气", "比昨晚更像中稿", "正在缓慢上分",
                    "展示出了真正贡献", "让 weak reject 变 weak accept", "正在说服 meta reviewer", "已经准备好 camera ready"
                ],
                extras: [
                    "OpenReview 匿名区请温柔一点",
                    "显著性检验都站在我们这边",
                    "训练曲线不要突然塌",
                    "每个 seed 都请站出来支持",
                    "理论和实验今天一起发力"
                ]
            )
        case .computerVision:
            return generatedTrackComments(
                venue: venue,
                subjects: [
                    "可视化图", "qualitative 结果", "ablation 表格", "backbone 对比", "检测框",
                    "分割 mask", "渲染效果", "数据增强", "SOTA 表", "supplementary 视频",
                    "failure case", "特征热力图"
                ],
                endings: [
                    "已经开始发光", "让 reviewer 多看两眼", "很适合放进 camera ready",
                    "正在提高说服力", "看起来不像调参事故", "把贡献讲清楚了",
                    "正在变成亮点", "让实验部分更稳", "正在守住 mAP",
                    "给定性结果加了分", "让模型显得更聪明", "正在冲向 accept"
                ],
                extras: [
                    "希望 reviewer 喜欢这张 qualitative",
                    "可视化图今天请自动变高清",
                    "SOTA 表格请稳住第一排",
                    "所有 demo 都一次跑通",
                    "图注写清楚就是胜利"
                ]
            )
        case .ai:
            return generatedTrackComments(
                venue: venue,
                subjects: [
                    "知识表示", "推理链", "智能体实验", "规划模块", "搜索策略",
                    "评测协议", "人类偏好", "对齐指标", "多智能体协作", "符号系统",
                    "任务泛化", "自动评测"
                ],
                endings: [
                    "正在保佑创新点", "请让 PC 看见价值", "已经讲通了故事",
                    "正在减少 reviewer 疑问", "让贡献更像贡献", "把系统能力撑起来了",
                    "正在靠近 accept", "让实验叙事更完整", "今天很有灵性",
                    "给 meta reviewer 递了台阶", "正在获得好评", "让讨论更顺滑"
                ],
                extras: [
                    "程序委员会请看见创新点",
                    "知识表示和推理都在保佑你",
                    "今天先敲，明天补实验",
                    "agent 不要在关键时刻掉线",
                    "评测脚本请给出漂亮数字"
                ]
            )
        case .naturalLanguage:
            return generatedTrackComments(
                venue: venue,
                subjects: [
                    "长文档实验", "人类评测", "BLEU 分数", "ROUGE 表格", "prompt 设计",
                    "语义一致性", "幻觉分析", "instruction tuning", "数据清洗", "case study",
                    "error analysis", "多语言实验"
                ],
                endings: [
                    "已经偏向 accept", "逻辑非常通顺", "请被认真阅读",
                    "让 reviewer 点头", "正在减少争议", "把贡献讲明白了",
                    "给 rebuttal 加了一分", "正在稳住结果", "很适合出现在主文",
                    "让故事更完整", "正在接近 camera ready", "今天语义一致"
                ],
                extras: [
                    "语义一致，逻辑通顺",
                    "人类评测已经偏向 accept",
                    "长文档 reviewer 请保持耐心",
                    "所有 hallucination 都请收敛",
                    "prompt 今天不要闹情绪"
                ]
            )
        case .databaseMining, .graphicsMultimedia, .architectureStorage, .networkSystem, .security, .softwareSystem, .theory, .humanComputerInteraction, .interdisciplinary:
            return generatedTrackComments(
                venue: venue,
                subjects: [
                    "\(venue.categoryTitle)审稿", "实验表格", "系统设计", "理论证明", "评测指标",
                    "投稿材料", "rebuttal 草稿", "appendix", "artifact", "presentation",
                    "相关工作", "贡献总结"
                ],
                endings: [
                    "正在靠近 accept", "请被认真读完", "让 reviewer 多给一分",
                    "正在变得更稳", "把贡献讲清楚了", "正在减少疑问",
                    "请给 meta reviewer 一个台阶", "今天看起来很有说服力",
                    "让结果更像好消息", "正在向 camera ready 前进"
                ],
                extras: [
                    "\(venue.categoryTitle)方向也要接住好消息",
                    "请让这个领域的 reviewer 今天很温柔",
                    "系统和实验都请稳住",
                    "相关工作已经引用得很完整",
                    "这篇论文值得一个 accept"
                ]
            )
        case .journal:
            return generatedTrackComments(
                venue: venue,
                subjects: [
                    "外审意见", "大修回复", "补充实验", "cover letter", "编辑决定",
                    "审稿周期", "引用格式", "最终版本", "方法细节", "理论分析",
                    "图表质量", "滚动审稿"
                ],
                endings: [
                    "正在慢慢点头", "请往接收方向走", "已经变得更稳",
                    "让编辑更放心", "正在抵达好消息", "不再像拒稿预告",
                    "请给一个 minor revision", "正在把大修变接收", "让论文更完整",
                    "今天请加速处理", "正在守住质量线", "最终会有回报"
                ],
                extras: [
                    "外审专家已经在点头",
                    "大修不是拒稿，是通往 accept 的桥",
                    "期刊滚动审稿也要滚向好消息",
                    "编辑请今天心情很好",
                    "minor revision 已经在路上"
                ]
            )
        case .all:
            return generatedTrackComments(
                venue: venue,
                subjects: [
                    "所有会议", "所有期刊", "所有 reviewer", "所有 meta review", "所有 rebuttal",
                    "所有实验", "所有 appendix", "所有图表", "所有邮件", "所有 ddl"
                ],
                endings: [
                    "都请偏向 accept", "都请温柔一点", "都在慢慢变好", "都在积攒好运",
                    "都不要再出 bug", "都请给毕业让路", "都在向好消息靠近", "都请写下 congratulations"
                ],
                extras: [
                    "今天全体论文都要有好消息",
                    "所有投稿系统都请稳定运行",
                    "所有 reviewer 都请读懂贡献",
                    "所有老板都请发出赞许",
                    "所有邮件都请写 accepted"
                ]
            )
        }
    }

    private static func generatedTrackComments(
        venue: Venue,
        subjects: [String],
        endings: [String],
        extras: [String]
    ) -> [String] {
        combine(subjects, endings, limit: 160) { subject, ending in
            "\(venue.name) 的\(subject)\(ending)"
        } + extras
    }

    private static func combine(
        _ left: [String],
        _ right: [String],
        limit: Int,
        builder: (String, String) -> String
    ) -> [String] {
        var result: [String] = []
        for item in left {
            for suffix in right {
                guard result.count < limit else { return result }
                result.append(builder(item, suffix))
            }
        }
        return result
    }

    private static func unique(_ comments: [String]) -> [String] {
        var seen: Set<String> = []
        return comments.filter { seen.insert($0).inserted }
    }

    private static func shuffled(_ comments: [String], seed: String) -> [String] {
        comments
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
}

private struct WoodFishSection: View {
    let venue: Venue
    let venueAcceptCount: Int
    let style: WoodFishStyle
    let isPressed: Bool
    let acceptBursts: [AcceptBurst]
    let comments: [PaperComment]
    let commentRevision: Int
    @Binding var commentDraft: String
    let onStrike: () -> Void
    let onSubmitComment: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("敲给 \(venue.name)")
                            .font(.title3.weight(.black))
                            .foregroundStyle(Color.paperInk)

                        TimelineView(.periodic(from: .now, by: 30)) { context in
                            if let status = venue.resultStatusText(relativeTo: context.date) {
                                Text(status)
                                    .font(.caption2.weight(.black))
                                    .monospacedDigit()
                                    .foregroundStyle(Color.acceptBlue)
                                    .lineLimit(1)
                                    .padding(.horizontal, 7)
                                    .frame(height: 22)
                                    .background(Color.acceptBlue.opacity(0.10), in: RoundedRectangle(cornerRadius: 7))
                            }
                        }
                    }
                    Text(venue.kind.rawValue + "祈福中")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("已接 \(venueAcceptCount) 次")
                    .font(.caption.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(Color.paperInk)
                    .padding(.horizontal, 10)
                    .frame(height: 28)
                    .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 8))
            }

            CommentMarquee(comments: comments)
                .id("\(venue.id)-\(commentRevision)")
                .frame(height: 86)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            ZStack {
                Button(action: onStrike) {
                    ZStack {
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(style.accentColor.opacity(isPressed ? 0.38 : 0.16), lineWidth: 2)
                                .frame(width: CGFloat(202 + index * 22), height: CGFloat(202 + index * 22))
                                .scaleEffect(isPressed ? 1.07 + CGFloat(index) * 0.03 : 0.96)
                                .opacity(isPressed ? 0.22 : 0.52)
                        }

                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: style.gradientColors,
                                    center: .topLeading,
                                    startRadius: 12,
                                    endRadius: 124
                                )
                            )
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.22), lineWidth: 4)
                                    .padding(16)
                            )
                            .shadow(color: .black.opacity(0.28), radius: isPressed ? 8 : 20, y: isPressed ? 3 : 12)

                        ForEach(0..<6) { index in
                            Capsule()
                                .stroke(style.accentColor.opacity(index.isMultiple(of: 2) ? 0.28 : 0.16), lineWidth: 2)
                                .frame(width: CGFloat(78 + index * 18), height: CGFloat(22 + index * 10))
                                .rotationEffect(.degrees(Double(index) * 8 + (isPressed ? 4 : 0)))
                        }

                        VStack(spacing: 5) {
                            WoodFishStyleIcon(
                                style: style,
                                size: 48,
                                isSelected: true,
                                isPressed: isPressed,
                                usesGradient: true
                            )
                                .shadow(color: style.accentColor.opacity(0.48), radius: 12, y: 4)
                                .scaleEffect(isPressed ? 1.12 : 1)
                                .rotationEffect(.degrees(isPressed ? -7 : 5))
                            Text("+1")
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                            Text(style.caption)
                                .font(.headline.weight(.black))
                                .foregroundStyle(.white.opacity(0.82))
                            Text(venue.name)
                                .font(.caption.weight(.black))
                                .foregroundStyle(.white.opacity(0.66))
                        }
                    }
                    .frame(width: 220, height: 220)
                    .scaleEffect(isPressed ? 0.9 : 1)
                    .rotationEffect(.degrees(isPressed ? -1.5 : 0))
                }
                .buttonStyle(.plain)

                ForEach(acceptBursts) { burst in
                    FloatingAcceptLabel(burst: burst)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 244)

            HStack(spacing: 8) {
                TextField("给 \(venue.name) 留一句", text: $commentDraft)
                    .font(.callout.weight(.semibold))
                    .textInputAutocapitalization(.never)
                    .submitLabel(.send)
                    .onSubmit(onSubmitComment)
                    .padding(.horizontal, 12)
                    .frame(height: 42)
                    .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 8))

                Button(action: onSubmitComment) {
                    Image(systemName: "paperplane.fill")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 42)
                        .background(
                            commentDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.5) : Color.paperInk,
                            in: RoundedRectangle(cornerRadius: 8)
                        )
                }
                .buttonStyle(.plain)
                .disabled(commentDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(16)
        .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
    }
}

private struct WoodFishStyleIcon: View {
    let style: WoodFishStyle
    let size: CGFloat
    let isSelected: Bool
    let isPressed: Bool
    let usesGradient: Bool

    var body: some View {
        if style == .rocket {
            UpFistHeroIcon(
                size: size,
                primaryColor: heroPrimaryColor,
                accentColor: heroAccentColor
            )
            .scaleEffect(isPressed ? 1.08 : 1)
        } else if usesGradient {
            Image(systemName: style.symbol)
                .font(.system(size: size, weight: .black))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, style.accentColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        } else {
            Image(systemName: style.symbol)
                .font(.system(size: size, weight: .black))
                .foregroundStyle(isSelected ? Color.white : style.accentColor)
        }
    }

    private var heroPrimaryColor: Color {
        if usesGradient {
            return .white
        }
        return isSelected ? .white : style.accentColor
    }

    private var heroAccentColor: Color {
        if usesGradient {
            return style.accentColor
        }
        return isSelected ? .white.opacity(0.74) : Color.acceptRose
    }
}

private struct UpFistHeroIcon: View {
    let size: CGFloat
    let primaryColor: Color
    let accentColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(accentColor.opacity(0.24))
                .frame(width: size * 0.96, height: size * 0.96)
                .offset(y: size * 0.03)

            Capsule()
                .fill(primaryColor.opacity(0.94))
                .frame(width: size * 0.26, height: size * 0.46)
                .rotationEffect(.degrees(-8))
                .offset(x: -size * 0.03, y: size * 0.18)

            Capsule()
                .fill(primaryColor.opacity(0.95))
                .frame(width: size * 0.14, height: size * 0.46)
                .rotationEffect(.degrees(-34))
                .offset(x: size * 0.19, y: -size * 0.14)

            Circle()
                .fill(accentColor)
                .frame(width: size * 0.24, height: size * 0.24)
                .offset(x: size * 0.32, y: -size * 0.39)

            ForEach(0..<3) { index in
                Capsule()
                    .fill(primaryColor.opacity(0.9))
                    .frame(width: size * 0.035, height: size * 0.12)
                    .offset(x: size * (0.27 + CGFloat(index) * 0.04), y: -size * 0.43)
            }

            Capsule()
                .fill(primaryColor.opacity(0.88))
                .frame(width: size * 0.13, height: size * 0.38)
                .rotationEffect(.degrees(50))
                .offset(x: -size * 0.22, y: size * 0.08)

            Circle()
                .fill(primaryColor)
                .frame(width: size * 0.23, height: size * 0.23)
                .offset(x: -size * 0.09, y: -size * 0.16)

            Capsule()
                .fill(accentColor.opacity(0.86))
                .frame(width: size * 0.15, height: size * 0.26)
                .rotationEffect(.degrees(22))
                .offset(x: -size * 0.14, y: size * 0.44)

            Capsule()
                .fill(accentColor.opacity(0.78))
                .frame(width: size * 0.15, height: size * 0.25)
                .rotationEffect(.degrees(-28))
                .offset(x: size * 0.08, y: size * 0.43)
        }
        .frame(width: size, height: size)
    }
}

private struct FloatingAcceptLabel: View {
    let burst: AcceptBurst
    @State private var isFloating = false

    var body: some View {
        Text("accept +1")
            .font(.headline.weight(.black))
            .foregroundStyle(Color.acceptRose)
            .padding(.horizontal, 13)
            .padding(.vertical, 7)
            .background(.white, in: RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.acceptRose.opacity(0.22), radius: 10, y: 5)
            .scaleEffect(isFloating ? 1.12 : 0.82)
            .rotationEffect(.degrees(burst.rotation))
            .offset(
                x: burst.xOffset,
                y: isFloating ? -132 + burst.yOffset : burst.yOffset
            )
            .opacity(isFloating ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 1.1)) {
                    isFloating = true
                }
            }
    }
}

private struct CommentMarquee: View {
    let comments: [PaperComment]
    @State private var isRunning = false

    private var visibleComments: [(Int, PaperComment)] {
        Array(comments.prefix(24).enumerated()).map { ($0.offset, $0.element) }
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    colors: [Color.paperInk.opacity(0.08), Color.acceptMint.opacity(0.10)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                ForEach(visibleComments, id: \.0) { index, comment in
                    MarqueeCommentPill(comment: comment)
                        .offset(
                            x: isRunning ? -proxy.size.width - CGFloat(comment.text.count * 9) - 80 : proxy.size.width - 24 + CGFloat(index * 58),
                            y: rowYOffset(index)
                        )
                        .animation(
                            .linear(duration: Double(12 + (index % 3) * 2))
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 1.1),
                            value: isRunning
                        )
                }
            }
            .onAppear {
                isRunning = true
            }
        }
    }

    private func rowYOffset(_ index: Int) -> CGFloat {
        [7, 32, 57][index % 3]
    }
}

private struct MarqueeCommentPill: View {
    let comment: PaperComment

    var body: some View {
        label
            .font(.caption.weight(comment.isVIP ? .black : .bold))
            .lineLimit(1)
            .padding(.horizontal, 10)
            .frame(height: 23)
            .background {
                Capsule()
                    .fill(comment.isVIP ? Color.white.opacity(0.9) : Color.white.opacity(0.72))
            }
            .overlay {
                Capsule()
                    .stroke(
                        comment.isVIP ? vipAccent(for: comment).opacity(0.46) : Color.clear,
                        lineWidth: 1
                    )
            }
            .shadow(
                color: comment.isVIP ? vipAccent(for: comment).opacity(0.30) : .clear,
                radius: comment.isVIP ? 8 : 0,
                y: comment.isVIP ? 3 : 0
            )
    }

    @ViewBuilder
    private var label: some View {
        if comment.isVIP {
            Text("VIP：\(comment.text)")
                .foregroundStyle(
                    LinearGradient(
                        colors: vipColors(for: comment),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        } else {
            Text("网友：\(comment.text)")
                .foregroundStyle(Color.paperInk.opacity(0.78))
        }
    }

    private func vipColors(for comment: PaperComment) -> [Color] {
        switch comment.styleIndex % 5 {
        case 0:
            return [Color.acceptRose, Color.acceptGold]
        case 1:
            return [Color.acceptBlue, Color.acceptMint]
        case 2:
            return [Color(red: 0.62, green: 0.36, blue: 0.92), Color.acceptRose]
        case 3:
            return [Color.paperInk, Color.acceptBlue]
        default:
            return [Color.acceptMint, Color.acceptGold]
        }
    }

    private func vipAccent(for comment: PaperComment) -> Color {
        vipColors(for: comment).first ?? Color.acceptGold
    }
}

private enum VenueSheetMode {
    case add
    case edit(Venue)

    var title: String {
        switch self {
        case .add:
            return "添加接稿项目"
        case .edit:
            return "编辑接稿项目"
        }
    }

    var saveTitle: String {
        switch self {
        case .add:
            return "添加到主页"
        case .edit:
            return "保存修改"
        }
    }
}

private struct AddVenueSheet: View {
    let mode: VenueSheetMode
    let defaultTrack: VenueTrack
    let onSave: (String, String, VenueKind, VenueTrack, String, Int?, Date?) -> Void
    let onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var fullName = ""
    @State private var kind: VenueKind = .conference
    @State private var track: VenueTrack
    @State private var ccfRank = "A"
    @State private var year: Int
    @State private var hasResultDate = true
    @State private var resultDate: Date

    init(
        mode: VenueSheetMode = .add,
        defaultTrack: VenueTrack,
        onSave: @escaping (String, String, VenueKind, VenueTrack, String, Int?, Date?) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        self.mode = mode
        self.defaultTrack = defaultTrack
        self.onSave = onSave
        self.onDelete = onDelete

        let fallbackTrack: VenueTrack = defaultTrack == .all || defaultTrack == .journal ? .machineLearning : defaultTrack
        let fallbackYear = Calendar.current.component(.year, from: .now)
        let fallbackResultDate = Calendar.current.date(byAdding: .month, value: 3, to: .now) ?? .now

        switch mode {
        case .add:
            _track = State(initialValue: fallbackTrack)
            _year = State(initialValue: fallbackYear)
            _resultDate = State(initialValue: fallbackResultDate)
        case .edit(let venue):
            _name = State(initialValue: venue.name)
            _fullName = State(initialValue: venue.fullName == venue.name ? "" : venue.fullName)
            _kind = State(initialValue: venue.kind)
            _track = State(initialValue: venue.track == .journal ? fallbackTrack : venue.track)
            _ccfRank = State(initialValue: venue.ccfRank)
            _year = State(initialValue: venue.year ?? fallbackYear)
            _hasResultDate = State(initialValue: venue.resultDate != nil)
            _resultDate = State(initialValue: venue.resultDate ?? fallbackResultDate)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    Text(mode.title)
                        .font(.title2.weight(.black))
                        .foregroundStyle(Color.paperInk)

                    VStack(alignment: .leading, spacing: 10) {
                        TextField("简称，例如 UIST / SIGGRAPH / TOG", text: $name)
                            .paperInputStyle()

                        TextField("全称，可不填", text: $fullName)
                            .paperInputStyle()

                        Picker("类型", selection: $kind) {
                            ForEach(VenueKind.allCases) { kind in
                                Text(kind.rawValue).tag(kind)
                            }
                        }
                        .pickerStyle(.segmented)

                        if kind == .conference {
                            Picker("方向", selection: $track) {
                                ForEach(conferenceTracks) { track in
                                    Text(track.title).tag(track)
                                }
                            }
                            .pickerStyle(.menu)

                            TextField("评级，例如 A / B / Workshop", text: $ccfRank)
                                .paperInputStyle()

                            Stepper("年份 \(year)", value: $year, in: 2024...2035)
                                .font(.callout.weight(.bold))
                                .foregroundStyle(Color.paperInk)

                            Toggle("设置开奖时间", isOn: $hasResultDate)
                                .font(.callout.weight(.bold))
                                .foregroundStyle(Color.paperInk)

                            if hasResultDate {
                                DatePicker(
                                    "开奖时间",
                                    selection: $resultDate,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .font(.callout.weight(.bold))
                                .foregroundStyle(Color.paperInk)
                            }
                        } else {
                            TextField("评级，例如 CCF A / Journal", text: $ccfRank)
                                .paperInputStyle()
                        }
                    }
                    .padding(14)
                    .background(.white.opacity(0.84), in: RoundedRectangle(cornerRadius: 8))

                    Button {
                        onSave(
                            name,
                            fullName,
                            kind,
                            kind == .journal ? .journal : track,
                            ccfRank,
                            kind == .conference ? year : nil,
                            kind == .conference && hasResultDate ? resultDate : nil
                        )
                        dismiss()
                    } label: {
                        Label(mode.saveTitle, systemImage: saveIcon)
                            .font(.headline.weight(.black))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(canSave ? Color.paperInk : Color.gray.opacity(0.46), in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(!canSave)

                    if case .edit = mode, let onDelete {
                        Button(role: .destructive) {
                            onDelete()
                            dismiss()
                        } label: {
                            Label("删除这个项目", systemImage: "trash.fill")
                                .font(.headline.weight(.black))
                                .foregroundStyle(Color.acceptRose)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(Color.paperSurface.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") {
                        dismiss()
                    }
                    .font(.callout.weight(.bold))
                }
            }
            .onChange(of: kind) { _, newKind in
                if newKind == .journal {
                    track = .journal
                    ccfRank = "Journal"
                } else {
                    track = defaultTrack == .all || defaultTrack == .journal ? .machineLearning : defaultTrack
                    ccfRank = "A"
                }
            }
        }
    }

    private var conferenceTracks: [VenueTrack] {
        VenueTrack.allCases.filter { $0 != .all && $0 != .journal }
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var saveIcon: String {
        switch mode {
        case .add:
            return "plus.circle.fill"
        case .edit:
            return "checkmark.circle.fill"
        }
    }
}

private extension View {
    func paperInputStyle() -> some View {
        self
            .font(.callout.weight(.semibold))
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 12)
            .frame(height: 42)
            .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct ReminderWidgetPanel: View {
    let venue: Venue
    let reminderMessage: String
    @Binding var widgetPreviewEnabled: Bool
    @Binding var notificationLeadDays: Int
    let onScheduleNotification: () -> Void
    let onSaveWidget: () -> Void

    private let leadDayOptions = [1, 3, 7]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("提醒与卡片", systemImage: "bell.badge.fill")
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color.paperInk)
                Spacer()
                Text(reminderMessage)
                    .font(.caption2.weight(.black))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            if venue.kind == .conference, venue.resultDate != nil {
                TimelineView(.periodic(from: .now, by: 60)) { context in
                    VStack(alignment: .leading, spacing: 10) {
                        WidgetPreviewCard(
                            venue: venue,
                            now: context.date,
                            isEnabled: widgetPreviewEnabled
                        )

                        HStack(spacing: 8) {
                            ForEach(leadDayOptions, id: \.self) { days in
                                Button {
                                    withAnimation(.snappy) {
                                        notificationLeadDays = days
                                    }
                                } label: {
                                    Text("\(days)天前")
                                        .font(.caption.weight(.black))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 32)
                                        .foregroundStyle(notificationLeadDays == days ? .white : Color.paperInk)
                                        .background(
                                            notificationLeadDays == days ? Color.paperInk : .white.opacity(0.82),
                                            in: RoundedRectangle(cornerRadius: 8)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        HStack(spacing: 10) {
                            Button(action: onScheduleNotification) {
                                Label("设置 iOS 通知", systemImage: "bell.fill")
                                    .font(.caption.weight(.black))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.78)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .foregroundStyle(.white)
                                    .background(Color.paperInk, in: RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)

                            Button(action: onSaveWidget) {
                                Label(widgetPreviewEnabled ? "更新桌面小卡片" : "放到桌面小卡片", systemImage: "rectangle.on.rectangle")
                                    .font(.caption.weight(.black))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.72)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .foregroundStyle(widgetPreviewEnabled ? .white : Color.paperInk)
                                    .background(
                                        widgetPreviewEnabled ? Color.acceptMint : Color.white.opacity(0.86),
                                        in: RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            } else {
                HStack(spacing: 10) {
                    Image(systemName: "newspaper.fill")
                        .font(.title3.weight(.black))
                        .foregroundStyle(Color.acceptMint)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("期刊暂无固定开奖时间线")
                            .font(.callout.weight(.black))
                            .foregroundStyle(Color.paperInk)
                        Text("可以继续接稿，提醒会留给有开奖日的会议。")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(12)
                .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(14)
        .background(.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct WidgetPreviewCard: View {
    let venue: Venue
    let now: Date
    let isEnabled: Bool

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("桌面小卡片")
                    .font(.caption.weight(.black))
                    .foregroundStyle(isEnabled ? Color.acceptMint : .secondary)
                Text(venue.notificationBody(relativeTo: now) ?? "\(venue.name) 开奖提醒")
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color.paperInk)
                    .lineLimit(2)
                Text(isEnabled ? "已同步当前项目" : "可同步为桌面 Widget 内容")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: isEnabled ? "checkmark.seal.fill" : "iphone")
                .font(.title2.weight(.black))
                .foregroundStyle(isEnabled ? Color.acceptMint : Color.paperInk.opacity(0.48))
                .frame(width: 46, height: 46)
                .background(Color.paperSurface.opacity(0.82), in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(12)
        .background(
            LinearGradient(
                colors: [
                    Color.acceptMint.opacity(isEnabled ? 0.22 : 0.10),
                    Color.acceptGold.opacity(0.12),
                    Color.white.opacity(0.84)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 8)
        )
    }
}

private struct PremiumAcceptPanel: View {
    let venue: Venue
    let isVIP: Bool
    let vipStatusText: String
    @Binding var userName: String
    let selectedEffect: VIPEffect
    let selectedVoiceStyle: AdvancedVoiceStyle
    let selectedWoodFishStyle: WoodFishStyle
    let onSelectEffect: (VIPEffect) -> Void
    let onSelectVoiceStyle: (AdvancedVoiceStyle) -> Void
    let onSelectWoodFishStyle: (WoodFishStyle) -> Void
    let onUnlock: () -> Void
    let onAdvancedAccept: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("高级 Accept", systemImage: "crown.fill")
                    .font(.headline.weight(.black))
                Spacer()
                Text(isVIP ? "VIP有效" : "¥1.66起")
                    .font(.caption.weight(.black))
                    .foregroundStyle(isVIP ? Color.acceptMint : Color.acceptRose)
                    .padding(.horizontal, 10)
                    .frame(height: 26)
                    .background(.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 8))
            }

            Text("恭喜 \(displayName) 即将中稿 \(venue.name)")
                .font(.title3.weight(.black))
                .foregroundStyle(Color.paperInk)

            Text(isVIP ? vipStatusText : "订阅后解锁语音、特效、彩色弹幕和专属敲击图标")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            if isVIP {
                TextField("输入你的名字", text: $userName)
                    .font(.callout.weight(.semibold))
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, 12)
                    .frame(height: 42)
                    .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 8))

                voiceStyleSelector

                acceptEffectSelector

                actionButtons

                woodFishStyleSelector
            } else {
                actionButtons
            }
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [Color.acceptGold.opacity(0.32), Color.acceptMint.opacity(0.18), Color.white.opacity(0.82)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 8)
        )
    }

    private var acceptEffectSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("选择接收特效")
                .font(.caption.weight(.black))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(VIPEffect.allCases) { effect in
                        Button {
                            withAnimation(.snappy) {
                                onSelectEffect(effect)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: effect.icon)
                                    .font(.caption.weight(.black))
                                Text(effect.title)
                                    .font(.caption.weight(.black))
                            }
                            .padding(.horizontal, 11)
                            .frame(height: 36)
                            .foregroundStyle(selectedEffect == effect ? .white : Color.paperInk)
                            .background(
                                selectedEffect == effect ? Color.paperInk : Color.white.opacity(0.82),
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button {
                isVIP ? onAdvancedAccept() : onUnlock()
            } label: {
                Label(isVIP ? "接受论文中稿" : "开通 VIP", systemImage: isVIP ? "speaker.wave.3.fill" : "lock.open.fill")
                    .font(.callout.weight(.black))
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .foregroundStyle(.white)
                    .background(Color.paperInk, in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)

            Button {
                isVIP ? onAdvancedAccept() : onUnlock()
            } label: {
                Image(systemName: "sparkles")
                    .font(.title3.weight(.black))
                    .frame(width: 50, height: 46)
                    .foregroundStyle(Color.paperInk)
                    .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
    }

    private var voiceStyleSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("选择语音风格")
                .font(.caption.weight(.black))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(AdvancedVoiceStyle.allCases) { style in
                        Button {
                            withAnimation(.snappy) {
                                onSelectVoiceStyle(style)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: style.icon)
                                    .font(.caption.weight(.black))
                                Text(style.title)
                                    .font(.caption.weight(.black))
                            }
                            .padding(.horizontal, 11)
                            .frame(height: 36)
                            .foregroundStyle(selectedVoiceStyle == style ? .white : Color.paperInk)
                            .background(
                                selectedVoiceStyle == style ? Color.paperInk : Color.white.opacity(0.82),
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var woodFishStyleSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("选择敲击图标")
                .font(.caption.weight(.black))
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
                spacing: 8
            ) {
                ForEach(WoodFishStyle.allCases) { style in
                    Button {
                        withAnimation(.snappy) {
                            onSelectWoodFishStyle(style)
                        }
                    } label: {
                        VStack(spacing: 5) {
                            WoodFishStyleIcon(
                                style: style,
                                size: 22,
                                isSelected: selectedWoodFishStyle == style,
                                isPressed: false,
                                usesGradient: false
                            )
                            Text(style.title)
                                .font(.caption2.weight(.black))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 62)
                        .foregroundStyle(selectedWoodFishStyle == style ? .white : Color.paperInk)
                        .background(
                            selectedWoodFishStyle == style ? style.accentColor : Color.white.opacity(0.86),
                            in: RoundedRectangle(cornerRadius: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style.accentColor.opacity(selectedWoodFishStyle == style ? 0 : 0.18), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(
            Color.paperInk.opacity(0.06),
            in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.62), lineWidth: 1)
        )
    }

    private var displayName: String {
        let trimmed = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        return isVIP && !trimmed.isEmpty ? trimmed : "老板"
    }
}

private struct CountdownSection: View {
    let featuredVenues: [Venue]
    let selectedTrack: VenueTrack
    let selectedRank: VenueRankFilter
    let refreshMessage: String
    @Namespace private var countdownTransition
    @State private var expandedVenueID: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("论文倒计时", systemImage: "timer")
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color.paperInk)
                Spacer()
                Text(refreshMessage)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            HStack(spacing: 6) {
                CountdownFilterBadge(text: selectedTrack.title, tint: Color.acceptBlue)
                CountdownFilterBadge(text: rankTitle, tint: Color.acceptRose)
                Spacer(minLength: 0)
            }

            if let expandedVenue {
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    FeaturedCountdownCard(venue: expandedVenue, now: context.date)
                        .matchedGeometryEffect(id: expandedVenue.id, in: countdownTransition)
                        .id(expandedVenue.id)
                }
                .zIndex(1)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.97, anchor: .top).combined(with: .opacity),
                    removal: .opacity
                ))
            }

            VStack(spacing: 8) {
                if featuredVenues.isEmpty {
                    Text("当前筛选下暂无未来会议倒计时")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 8))
                } else {
                    ForEach(collapsedVenues) { venue in
                        Button {
                            withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) {
                                expandedVenueID = venue.id
                            }
                        } label: {
                            TimelineView(.periodic(from: .now, by: 30)) { context in
                                FeaturedCountdownRow(venue: venue, now: context.date)
                                    .matchedGeometryEffect(id: venue.id, in: countdownTransition)
                            }
                        }
                        .buttonStyle(.plain)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
        }
        .onAppear {
            syncExpandedVenue()
        }
        .onChange(of: featuredVenueIDs) { _, _ in
            syncExpandedVenue()
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.84), value: expandedVenueID)
    }

    private var rankTitle: String {
        selectedRank == .all ? "全部等级" : "CCF \(selectedRank.rawValue)"
    }

    private var featuredVenueIDs: [String] {
        featuredVenues.map(\.id)
    }

    private var expandedVenue: Venue? {
        featuredVenues.first { $0.id == expandedVenueID } ?? featuredVenues.first
    }

    private var collapsedVenues: [Venue] {
        guard let expandedVenue else { return [] }
        return featuredVenues.filter { $0.id != expandedVenue.id }
    }

    private func syncExpandedVenue() {
        guard let firstVenue = featuredVenues.first else {
            expandedVenueID = nil
            return
        }

        if let expandedVenueID,
           featuredVenues.contains(where: { $0.id == expandedVenueID }) {
            return
        }

        expandedVenueID = firstVenue.id
    }
}

private struct CountdownFilterBadge: View {
    let text: String
    let tint: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.black))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .frame(height: 22)
            .foregroundStyle(tint)
            .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 7))
    }
}

private struct CountdownUnitBox: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 26, weight: .black, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.72)
                .foregroundStyle(Color.paperInk)
            Text(label)
                .font(.caption2.weight(.black))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .background(Color.paperSurface.opacity(0.78), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct FeaturedCountdownCard: View {
    let venue: Venue
    let now: Date

    var body: some View {
        let milestone = venue.nextMilestone(relativeTo: now)
        let countdown = CountdownFormatter.value(until: milestone.date, from: now)

        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(venue.name) \(milestone.title)")
                        .font(.title3.weight(.black))
                        .foregroundStyle(Color.paperInk)
                    Text(milestone.source)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: icon(for: milestone.kind))
                    .font(.title2.weight(.black))
                    .foregroundStyle(Color.acceptBlue)
            }

            HStack(spacing: 8) {
                ForEach(countdown.units, id: \.0) { unit in
                    CountdownUnitBox(label: unit.0, value: unit.1)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Label(venue.dateText, systemImage: "calendar")
                    Spacer(minLength: 8)
                    Text(venue.place)
                        .lineLimit(1)
                }
                if !venue.note.isEmpty {
                    Text(venue.note)
                        .lineLimit(2)
                }
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 8))
    }

    private func icon(for kind: MilestoneKind) -> String {
        switch kind {
        case .result:
            return "checkmark.seal.fill"
        case .paperDeadline:
            return "paperplane.fill"
        case .conferenceStart:
            return "calendar.badge.clock"
        case .rollingReview:
            return "arrow.triangle.2.circlepath"
        }
    }
}

private struct FeaturedCountdownRow: View {
    let venue: Venue
    let now: Date

    var body: some View {
        let milestone = venue.nextMilestone(relativeTo: now)
        let countdown = CountdownFormatter.value(until: milestone.date, from: now)

        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(venue.name)
                    .font(.callout.weight(.black))
                    .foregroundStyle(Color.paperInk)
                    .lineLimit(1)

                Text("\(venue.categoryTitle) · \(venue.displayRank)")
                .font(.caption2.weight(.black))
                .foregroundStyle(Color.paperInk.opacity(0.56))
                .lineLimit(1)
                .minimumScaleFactor(0.76)
            }
            .frame(width: 98, alignment: .leading)

            VStack(alignment: .leading, spacing: 3) {
                Text(milestone.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(milestone.source)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Color.secondary.opacity(0.76))
                    .lineLimit(1)
            }

            Spacer()

            Text(countdown.compactText)
                .font(.caption.weight(.black))
                .monospacedDigit()
                .foregroundStyle(Color.paperInk)
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .frame(height: 58)
        .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct VIPPaywallView: View {
    let venue: Venue
    let benefits: [String]
    let paywallNotice: String
    let onSubscribe: (VIPSubscriptionPlan) -> Void
    let onRedeemCoupon: (String) -> CouponRedemptionResult
    let onRestore: () -> Bool
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: VIPSubscriptionPlan = .monthly
    @State private var couponCode = ""
    @State private var couponMessage = ""
    @State private var restoreMessage = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("VIP 高级 Accept", systemImage: "crown.fill")
                        .font(.title2.weight(.black))
                        .foregroundStyle(Color.paperInk)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline.weight(.black))
                            .foregroundStyle(Color.paperInk)
                            .frame(width: 36, height: 36)
                            .background(.black.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }

                Text("为 \(venue.name) 解锁更完整的中稿仪式")
                    .font(.callout.weight(.black))
                    .foregroundStyle(Color.acceptRose)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(benefits.indices, id: \.self) { index in
                        Label(benefits[index], systemImage: benefitIcon(for: index))
                    }
                }
                .font(.callout.weight(.bold))
                .foregroundStyle(Color.paperInk.opacity(0.78))

                VStack(spacing: 8) {
                    ForEach(VIPSubscriptionPlan.allCases) { plan in
                        Button {
                            withAnimation(.snappy) {
                                selectedPlan = plan
                                restoreMessage = ""
                            }
                        } label: {
                            VIPPlanCard(plan: plan, isSelected: selectedPlan == plan)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button {
                    onSubscribe(selectedPlan)
                    dismiss()
                } label: {
                    HStack {
                        Text("订阅并解锁")
                        Spacer()
                        Text(selectedPlan.priceText + selectedPlan.periodText)
                            .monospacedDigit()
                    }
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(Color.paperInk, in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 8) {
                    Text("优惠码开通")
                        .font(.callout.weight(.black))
                        .foregroundStyle(Color.paperInk)

                    HStack(spacing: 8) {
                        TextField("输入优惠码", text: $couponCode)
                            .font(.callout.weight(.bold))
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 12)
                            .frame(height: 44)
                            .background(.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 8))

                        Button {
                            let result = onRedeemCoupon(couponCode)
                            couponMessage = result.message
                            restoreMessage = ""
                            if result.isSuccess {
                                dismiss()
                            }
                        } label: {
                            Text("兑换")
                                .font(.callout.weight(.black))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .frame(height: 44)
                                .background(Color.acceptRose, in: RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }

                    if !couponMessage.isEmpty {
                        Text(couponMessage)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(couponMessage.contains("已开通") ? Color.acceptMint : Color.acceptRose)
                    }
                }
                .padding(12)
                .background(Color.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.acceptRose.opacity(0.18), lineWidth: 1)
                )

                Button {
                    if onRestore() {
                        dismiss()
                    } else {
                        restoreMessage = "暂无可恢复的有效订阅"
                    }
                } label: {
                    Text("恢复购买")
                        .font(.callout.weight(.black))
                        .foregroundStyle(Color.paperInk)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

                if !restoreMessage.isEmpty {
                    Text(restoreMessage)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.acceptRose)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                if !paywallNotice.isEmpty {
                    Text(paywallNotice)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
        }
        .background(Color.paperSurface)
    }

    private func benefitIcon(for index: Int) -> String {
        let icons = [
            "person.text.rectangle.fill",
            "sparkles",
            "text.bubble.fill",
            "square.grid.2x2.fill",
            "gift.fill",
            "crown.fill"
        ]
        return icons[index % icons.count]
    }
}

private struct VIPPlanCard: View {
    let plan: VIPSubscriptionPlan
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title3.weight(.black))
                .foregroundStyle(isSelected ? Color.acceptRose : Color.paperInk.opacity(0.32))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(plan.title)
                        .font(.headline.weight(.black))
                        .foregroundStyle(Color.paperInk)

                    if let badge = plan.badge {
                        Text(badge)
                            .font(.caption2.weight(.black))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .frame(height: 20)
                            .background(Color.acceptRose, in: RoundedRectangle(cornerRadius: 6))
                    }
                }

                Text(plan.subtitle)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(plan.priceText)
                    .font(.title3.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(Color.paperInk)
                Text(plan.periodText)
                    .font(.caption2.weight(.black))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(
            isSelected ? Color.acceptGold.opacity(0.20) : Color.white.opacity(0.84),
            in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.acceptRose.opacity(0.66) : Color.white.opacity(0.62), lineWidth: 1.5)
        )
    }
}

private struct VIPCelebrationOverlay: View {
    let venueName: String
    let userName: String
    let venueAcceptCount: Int
    let effect: VIPEffect
    @Binding var isPresented: Bool
    @State private var animate = false

    private let colors: [Color] = [Color.acceptGold, Color.acceptRose, Color.acceptMint, Color.acceptBlue, Color.white]

    var body: some View {
        ZStack {
            Color.black.opacity(0.46)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.22)) {
                        isPresented = false
                    }
                }

            effectLayer

            VStack(spacing: 12) {
                Text("ACCEPTED")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.acceptGold, Color.white, Color.acceptMint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: Color.acceptGold.opacity(0.55), radius: 18)
                Text("恭喜 \(userName) 即将中稿 \(venueName)")
                    .font(.title3.weight(.black))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text("accept +\(venueAcceptCount)")
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color.acceptGold)
            }
            .padding(22)
            .frame(maxWidth: 320)
            .background(.black.opacity(0.42), in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white.opacity(0.34), lineWidth: 1)
            )
            .scaleEffect(animate ? 1 : 0.72)
            .animation(.spring(response: 0.32, dampingFraction: 0.72), value: animate)
        }
        .onAppear {
            animate = true
        }
    }

    @ViewBuilder
    private var effectLayer: some View {
        switch effect {
        case .confetti:
            confettiLayer
        case .goldRain:
            goldRainLayer
        case .fireworks:
            fireworksLayer
        case .starfield:
            starfieldLayer
        case .spotlight:
            spotlightLayer
        case .acceptSeal:
            acceptSealLayer
        case .balloons:
            balloonLayer
        }
    }

    private var confettiLayer: some View {
        ForEach(0..<72, id: \.self) { index in
            RoundedRectangle(cornerRadius: 2)
                .fill(colors[index % colors.count])
                .frame(width: pieceWidth(index), height: pieceHeight(index))
                .rotationEffect(.degrees(animate ? Double(index * 19) : Double(index * 7)))
                .offset(
                    x: xOffset(index),
                    y: animate ? yOffset(index) : -420
                )
                .opacity(animate ? 1 : 0)
                .animation(
                    .interpolatingSpring(stiffness: 62, damping: 12)
                    .delay(Double(index % 14) * 0.025),
                    value: animate
                )
        }
    }

    private var goldRainLayer: some View {
        ForEach(0..<44, id: \.self) { index in
            Text(index.isMultiple(of: 3) ? "+1" : "ACCEPT")
                .font(.system(size: CGFloat(17 + index % 5), weight: .black, design: .rounded))
                .foregroundStyle(index.isMultiple(of: 2) ? Color.acceptGold : Color.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.paperInk.opacity(0.22), in: Capsule())
                .rotationEffect(.degrees(animate ? Double(index * 13) : 0))
                .offset(
                    x: CGFloat((index * 47) % 360) - 180,
                    y: animate ? CGFloat((index * 61) % 760) - 260 : -430
                )
                .opacity(animate ? 1 : 0)
                .animation(
                    .easeOut(duration: 1.55)
                    .delay(Double(index % 11) * 0.045),
                    value: animate
                )
        }
    }

    private var fireworksLayer: some View {
        ForEach(0..<5, id: \.self) { cluster in
            ZStack {
                ForEach(0..<14, id: \.self) { ray in
                    Capsule()
                        .fill(colors[(cluster + ray) % colors.count])
                        .frame(width: 5, height: 34)
                        .offset(y: animate ? -CGFloat(70 + cluster * 12) : -8)
                        .rotationEffect(.degrees(Double(ray) * 360 / 14))
                        .opacity(animate ? 0 : 1)
                }

                Circle()
                    .stroke(colors[cluster % colors.count].opacity(0.82), lineWidth: 3)
                    .frame(
                        width: animate ? CGFloat(180 + cluster * 24) : 12,
                        height: animate ? CGFloat(180 + cluster * 24) : 12
                    )
                    .opacity(animate ? 0 : 1)
            }
            .offset(
                x: CGFloat((cluster * 93) % 300) - 150,
                y: CGFloat((cluster * 71) % 360) - 180
            )
            .animation(
                .easeOut(duration: 1.2)
                .delay(Double(cluster) * 0.18),
                value: animate
            )
        }
    }

    private var starfieldLayer: some View {
        ForEach(0..<64, id: \.self) { index in
            Image(systemName: index.isMultiple(of: 4) ? "sparkle" : "star.fill")
                .font(.system(size: CGFloat(10 + (index * 7) % 22), weight: .black))
                .foregroundStyle(colors[index % colors.count])
                .scaleEffect(animate ? 1.2 : 0.2)
                .rotationEffect(.degrees(animate ? Double(index * 23) : 0))
                .offset(
                    x: CGFloat((index * 59) % 390) - 195,
                    y: CGFloat((index * 83) % 760) - 330
                )
                .opacity(animate ? 0.95 : 0)
                .animation(
                    .easeOut(duration: 1.1)
                    .delay(Double(index % 16) * 0.035),
                    value: animate
                )
        }
    }

    private var spotlightLayer: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                colors[index % colors.count].opacity(animate ? 0.36 : 0.02),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 92, height: 720)
                    .rotationEffect(.degrees(Double(index) * 32 - 48 + (animate ? 12 : -18)))
                    .offset(x: CGFloat(index * 84) - 126, y: -46)
                    .blur(radius: 10)
                    .animation(
                        .easeInOut(duration: 1.4)
                        .delay(Double(index) * 0.08),
                        value: animate
                    )
            }

            Circle()
                .stroke(Color.acceptGold.opacity(animate ? 0 : 0.72), lineWidth: 4)
                .frame(width: animate ? 360 : 80, height: animate ? 360 : 80)
                .animation(.easeOut(duration: 1.15), value: animate)
        }
    }

    private var acceptSealLayer: some View {
        ZStack {
            ForEach(0..<9, id: \.self) { index in
                Text("ACCEPT")
                    .font(.system(size: CGFloat(22 + index % 3 * 4), weight: .black, design: .rounded))
                    .foregroundStyle(Color.acceptRose.opacity(0.78))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.acceptRose.opacity(0.78), lineWidth: 2)
                    )
                    .rotationEffect(.degrees(Double((index * 37) % 34) - 17))
                    .scaleEffect(animate ? 1 : 2.4)
                    .offset(
                        x: CGFloat((index * 71) % 330) - 165,
                        y: CGFloat((index * 49) % 500) - 235
                    )
                    .opacity(animate ? 0.72 : 0)
                    .animation(
                        .spring(response: 0.34, dampingFraction: 0.54)
                        .delay(Double(index) * 0.08),
                        value: animate
                    )
            }
        }
    }

    private var balloonLayer: some View {
        ForEach(0..<28, id: \.self) { index in
            VStack(spacing: 0) {
                Image(systemName: index.isMultiple(of: 2) ? "balloon.fill" : "balloon.2.fill")
                    .font(.system(size: CGFloat(18 + (index * 3) % 18), weight: .black))
                    .foregroundStyle(colors[index % colors.count])
                Rectangle()
                    .fill(Color.white.opacity(0.68))
                    .frame(width: 1, height: CGFloat(18 + index % 12))
            }
            .offset(
                x: CGFloat((index * 43) % 360) - 180,
                y: animate ? CGFloat((index * 61) % 700) - 420 : 360
            )
            .opacity(animate ? 1 : 0)
            .animation(
                .easeOut(duration: 1.7)
                .delay(Double(index % 10) * 0.055),
                value: animate
            )
        }
    }

    private func pieceWidth(_ index: Int) -> CGFloat {
        CGFloat(6 + (index * 5) % 10)
    }

    private func pieceHeight(_ index: Int) -> CGFloat {
        CGFloat(12 + (index * 7) % 18)
    }

    private func xOffset(_ index: Int) -> CGFloat {
        CGFloat((index * 53) % 360) - 180
    }

    private func yOffset(_ index: Int) -> CGFloat {
        CGFloat((index * 41) % 740) - 220
    }
}

#Preview {
    ContentView()
}
