//
//  SortedExpensesList.swift
//  Challenge7
//
//  Created by Victor Rubenko on 14.03.2024.
//

import SwiftUI
import SwiftData

struct SortedExpensesList: View {
    
    @Query private var expenses: [ExpenseItem]
    @Environment(\.modelContext) private var modelContext
    
    init(types: [String], sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(
            filter: #Predicate<ExpenseItem> {
                types.contains($0.rawType)
            },
            sort: sortOrder
        )
    }
    
    var body: some View {
        List {
            ForEach(ExpenseItem.ExpenseType.allCases, id: \.self) {
                itemType in
                
                Section(itemType.rawValue.capitalized) {
                    ForEach(expenses.filter { $0.type == itemType }) {
                        item in
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type.rawValue.capitalized)
                            }
                            Spacer()
                            Text(
                                item.amount,
                                format: .currency(code: .localCurrencyCode)
                            )
                            .foregroundStyle(item.amount > 10 ? .red : .black)
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        offsets.forEach {
            modelContext.delete(expenses[$0])
        }
    }
}
