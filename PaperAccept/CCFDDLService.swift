import Foundation

struct VenueUpdate: Equatable {
    let id: String
    let categoryCode: String?
    let year: Int?
    let ccfRank: String?
    let paperDeadline: Date?
    let conferenceStart: Date?
    let dateText: String?
    let place: String?
    let sourceURL: URL?
}

enum CCFDDLServiceError: LocalizedError {
    case invalidResponse
    case decodeFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "CCFDDL 数据响应不可用"
        case .decodeFailed(let reason):
            return "无法解析 CCFDDL 数据：\(reason)"
        }
    }
}

struct CCFDDLService {
    private let sourceURL = URL(string: "https://ccfddl.top/")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchUpdates() async throws -> [VenueUpdate] {
        let (data, response) = try await session.data(from: sourceURL)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw CCFDDLServiceError.invalidResponse
        }
        guard let html = String(data: data, encoding: .utf8) else {
            throw CCFDDLServiceError.decodeFailed("页面编码不是 UTF-8")
        }
        return parseWebsiteRows(from: html)
    }

    private func parseWebsiteRows(from html: String) -> [VenueUpdate] {
        let pattern = #"rows\.push\((\{[\s\S]*?\})\)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(html.startIndex..<html.endIndex, in: html)

        return regex.matches(in: html, range: range).compactMap { match in
            guard let objectRange = Range(match.range(at: 1), in: html) else { return nil }
            return parseRow(String(html[objectRange]))
        }
    }

    private func parseRow(_ object: String) -> VenueUpdate? {
        let fields = parseFields(from: object)
        guard let shortName = fields["shortName"], !shortName.isEmpty else { return nil }

        let deadline = parseDateTime(fields["deadline"], timeZoneText: fields["timezone"])
        let year = fields["year"].flatMap(Int.init)
        let dateText = fields["date"]
        let conferenceStart = dateText.flatMap {
            parseConferenceStart(dateText: $0, fallbackYear: year)
        }

        return VenueUpdate(
            id: Self.venueID(from: shortName),
            categoryCode: fields["type"],
            year: year,
            ccfRank: fields["ccfRank"],
            paperDeadline: deadline,
            conferenceStart: conferenceStart,
            dateText: dateText,
            place: fields["place"],
            sourceURL: fields["link"].flatMap(URL.init(string:)) ?? sourceURL
        )
    }

    private func parseFields(from object: String) -> [String: String] {
        let pattern = #"'([^']+)'\s*:\s*(?:"([^"]*)"|'([^']*)'|([^,\n}]+))"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [:] }
        let range = NSRange(object.startIndex..<object.endIndex, in: object)

        var fields: [String: String] = [:]
        for match in regex.matches(in: object, range: range) {
            guard let keyRange = Range(match.range(at: 1), in: object) else { continue }
            let key = String(object[keyRange])

            let value: String?
            if let doubleQuotedRange = Range(match.range(at: 2), in: object) {
                value = String(object[doubleQuotedRange])
            } else if let singleQuotedRange = Range(match.range(at: 3), in: object) {
                value = String(object[singleQuotedRange])
            } else if let bareRange = Range(match.range(at: 4), in: object) {
                value = String(object[bareRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                value = nil
            }

            fields[key] = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return fields
    }

    private func parseDateTime(_ text: String?, timeZoneText: String?) -> Date? {
        guard let text, text.uppercased() != "TBD" else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone(for: timeZoneText)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: text)
    }

    private func timeZone(for text: String?) -> TimeZone {
        guard let text, !text.isEmpty else {
            return TimeZone(secondsFromGMT: 0) ?? .current
        }
        if text == "AoE" {
            return TimeZone(secondsFromGMT: -12 * 3600) ?? .current
        }
        if text == "UTC" {
            return TimeZone(secondsFromGMT: 0) ?? .current
        }
        let pattern = #"UTC([+-])(\d{1,2})"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..<text.endIndex, in: text)),
              let signRange = Range(match.range(at: 1), in: text),
              let hourRange = Range(match.range(at: 2), in: text),
              let hour = Int(text[hourRange]) else {
            return TimeZone(secondsFromGMT: 0) ?? .current
        }
        let sign = text[signRange] == "+" ? 1 : -1
        return TimeZone(secondsFromGMT: sign * hour * 3600) ?? .current
    }

    private func parseConferenceStart(dateText: String, fallbackYear: Int?) -> Date? {
        let monthMap = [
            "jan": 1, "january": 1,
            "feb": 2, "february": 2,
            "mar": 3, "march": 3,
            "apr": 4, "april": 4,
            "may": 5,
            "jun": 6, "june": 6,
            "jul": 7, "july": 7,
            "aug": 8, "august": 8,
            "sep": 9, "sept": 9, "september": 9,
            "oct": 10, "october": 10,
            "nov": 11, "november": 11,
            "dec": 12, "december": 12
        ]

        let year = firstMatch(in: dateText, pattern: #"(\d{4})"#).flatMap(Int.init) ?? fallbackYear
        guard let year,
              let monthName = firstMatch(in: dateText, pattern: #"(?i)\b([A-Za-z]+)\s+\d{1,2}"#)?.lowercased(),
              let month = monthMap[monthName],
              let dayText = firstMatch(in: dateText, pattern: #"(?i)\b[A-Za-z]+\s+(\d{1,2})"#),
              let day = Int(dayText) else {
            return nil
        }

        return Date.paperDate(year, month, day, 9, 0)
    }

    private func firstMatch(in text: String, pattern: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              match.numberOfRanges > 1,
              let captureRange = Range(match.range(at: 1), in: text) else {
            return nil
        }
        return String(text[captureRange])
    }

    static func venueID(from shortName: String) -> String {
        let parts = shortName
            .lowercased()
            .split { !$0.isLetter && !$0.isNumber }
            .map(String.init)
        return parts.isEmpty ? shortName.lowercased() : parts.joined(separator: "-")
    }
}
