//
//  ContentView.swift
//  Challenge7
//
//  Created by Victor on 21.02.2024.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    
    enum ExpenseType: String, CaseIterable, Codable {
        case personal
        case business
    }
    
    var id = UUID()
    let name: String
    let type: ExpenseType
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "items"),
           let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: data) {
            items = decoded
        } else {
            items = []
        }
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(ExpenseItem.ExpenseType.allCases, id: \.self) {
                        itemType in
                        
                        Section(itemType.rawValue.capitalized) {
                            ForEach(expenses.items.filter { $0.type == itemType }) {
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
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(
                isPresented: $showingAddExpense,
                content: {
                    AddView(expenses: expenses)
                }
            )
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}

extension String {
    static var localCurrencyCode: String {
        let locale = Locale.current
        return locale.currency?.identifier ?? "USD"
    }
}
