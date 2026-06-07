# PaperAccept

一个 SwiftUI iOS 原型：敲木鱼累计 `accept +1`，按会议/期刊选择祈福目标，底部实时显示论文节点倒计时，并提供 VIP 高级 Accept 语音与动画。

## 运行

1. 用 Xcode 打开 `PaperAccept.xcodeproj`
2. 选择 iOS Simulator
3. 运行 `PaperAccept` scheme

## 数据

- CCF A AI/ML/CV/NLP 会议内置了精选初始数据。
- 点击右上角刷新会从 `ccfddl/ccf-deadlines` 的 GitHub contents API 拉取对应 YAML，更新投稿截止、会期、地点等字段。
- CCFDDL 主要维护 deadline 和会议日期，不稳定提供录用结果日；App 中标注为“预计结果日”的节点是产品原型占位，后续应接入官方 CFP 或后台维护。

## VIP

当前 VIP 解锁是本地原型入口，后续可替换为 StoreKit 内购。高级 Accept 使用系统中文语音播报和 SwiftUI 动画。
