//
//  NotionClient+.swift
//  TestNotionSwift
//
//  Created by 朱浩宇 on 2024/1/23.
//

import Foundation
import NotionSwift

extension NotionClient {
    func searchDatabase() async throws -> [Database] {
        return try await withCheckedThrowingContinuation { continuation in
            self.search(request: .init(filter: .database)) { result in
                switch result {
                case .success(let objects):
                    let items = objects.results.compactMap({ object -> Database? in
                        if case .database(let db) = object {
                            return db
                        }

                        return nil
                    })

                    continuation.resume(returning: items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func queryDatabaseItem(id: Database.Identifier) async throws -> [Page] {
        return try await withCheckedThrowingContinuation { continuation in
            self.databaseQuery(databaseId: id) { result in
                switch result {
                case .success(let objects):
                    let items = objects.results

                    continuation.resume(returning: items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}

extension DateValue {
    var date: Date {
        switch self {
        case .dateOnly(let date):
            return date
        case .dateAndTime(let date):
            return date
        }
    }

    var dateOnly: Bool {
        switch self {
        case .dateOnly(_):
            return true
        case .dateAndTime(_):
            return false
        }
    }
}
