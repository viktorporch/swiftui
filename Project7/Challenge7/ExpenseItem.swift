//
//  ExpenseItem.swift
//  Challenge7
//
//  Created by Victor Rubenko on 14.03.2024.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    
    enum ExpenseType: String, CaseIterable, Codable {
        case personal
        case business
    }
    
    let id = UUID()
    let name: String
    let type: ExpenseType
    let amount: Double
    let rawType: String
    
    init(name: String, type: ExpenseType, amount: Double) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.amount = amount
        self.rawType = type.rawValue
    }
}
