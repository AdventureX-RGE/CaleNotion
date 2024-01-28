//
//  DescriptionManager.swift
//
//
//  Created by 朱浩宇 on 2024/1/28.
//

import Foundation
import NotionSwift

actor DescriptionManager {
    static let shared = DescriptionManager()

    var desciptions: [Page.Identifier: (String, Date)] = [:]

    func find(id: Page.Identifier, _ notion: NotionClient) -> String? {
        let pair = desciptions[id]

        if let pair, isOneDayLater(firstDate: pair.1, secondDate: Date()) {
            Self.addTask(id: id, notion)
        } else if pair == nil {
            Self.addTask(id: id, notion)
        }

        return pair?.0
    }

    func setD(id: Page.Identifier, content: String) {
        return desciptions[id] = (content, Date())
    }

    static func addTask(id: Page.Identifier, _ notion: NotionClient) {
        Task.detached {
            let content = try await notion.retriveBlock(id: id.toBlockIdentifier).reduce(into: "") { partialResult, block in
                partialResult += block.type.toString() + "\\n"
            }

            await DescriptionManager.shared.setD(id: id, content: content)
        }
    }

    func isOneDayLater(firstDate: Date, secondDate: Date) -> Bool {
        let calendar = Calendar.current
        if let nextDay = calendar.date(byAdding: .hour, value: 3, to: firstDate) {
            // Compare only the date components (year, month, day), ignoring the time components
            let date1Components = calendar.dateComponents([.year, .month, .day], from: nextDay)
            let date2Components = calendar.dateComponents([.year, .month, .day], from: secondDate)
            return date1Components == date2Components
        }
        return false
    }
}
