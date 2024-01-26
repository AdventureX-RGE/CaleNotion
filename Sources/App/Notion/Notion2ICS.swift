// The Swift Programming Language
// https://docs.swift.org/swift-book

import NotionSwift
import Foundation

struct Notion2ICS {
    let token: String

    init(token: String) {
        self.token = token
    }

    func fetchEvents() async throws -> [Event] {
        let notion = NotionClient(accessKeyProvider: StringAccessKeyProvider(accessKey: token))

        let databases = try await notion.searchDatabase()

        var events = [Event]()

        for database in databases {
            let rows = try await notion.queryDatabaseItem(id: database.id)

            let dbName = database.title.reduce(into: "", { partialResult, text in
                partialResult += text.plainText ?? ""
            })

            for row in rows {
                let title = row.getTitle()?.reduce(into: "", { partialResult, text in
                    partialResult += text.plainText ?? ""
                })

                guard let dateRange: DateRange = row.properties.compactMap({ (key, value) in
                    if case .date(let daterange) = value.type {
                        return daterange
                    }
                    return nil
                }).first else { continue }

                var replaceEnd: Date? = nil

                if !dateRange.start.dateOnly && dateRange.end == nil {
                    replaceEnd = Calendar.current.date(byAdding: .hour, value: 1, to: dateRange.start.date)
                }

                events.append(.init(uid: UUID().uuidString, title: "\(dbName): \(title ?? "Untitled")", start: dateRange.start.date, end: dateRange.end?.date ?? replaceEnd, dateOnly: dateRange.start.dateOnly))
            }
        }

        return events
    }
}
