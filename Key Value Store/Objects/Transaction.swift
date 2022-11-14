//
//  Transaction.swift
//  Key Value Store
//
//  Created by Ramon Vasconcelos on 14.11.2022.
//

import Foundation

enum Transaction: CaseIterable, Hashable {
    case set(key: String, value: String)
    case get(key: String)
    case delete(key: String)
    case count(value: String)
    case begin
    case commit
    case rollback
    
    static var allCases: [Transaction] {
        return [
            .set(key: "foo", value: "123"),
            .get(key: "foo"),
            .delete(key: "foo"),
            .count(value: "123"),
            .begin,
            .commit,
            .rollback
        ]
    }
    
    var description: String {
        switch self {
        case let .set(key, value):
            return "SET \(key) \(value)"
        case let .get(key):
            return "GET \(key)"
        case let .delete(key):
            return "DELETE \(key)"
        case let .count(value):
            return "COUNT \(value)"
        case .begin:
            return "BEGIN"
        case .commit:
            return "COMMIT"
        case .rollback:
            return "ROLLBACK"
        }
    }
}
