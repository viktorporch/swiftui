//
//  ContentView.swift
//  Challenge7
//
//  Created by Victor on 21.02.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var showingAddExpense = false
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ]
    @State private var filterTypes: [ExpenseItem.ExpenseType] = [.business, .personal]
    
    var body: some View {
        NavigationStack {
            SortedExpensesList(
                types: filterTypes.map { $0.rawValue },
                sortOrder: sortOrder
            )
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink(
                    destination: {
                        AddView()
                            .navigationBarBackButtonHidden()
                    },
                    label: {
                        HStack {
                            Text("Add Expense")
                        }
                    }
                )
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Menu("Type") {
                        Picker("Sort", selection: $filterTypes) {
                            Text("All")
                                .tag([
                                    ExpenseItem.ExpenseType.business,
                                    ExpenseItem.ExpenseType.personal
                                ])
                            Text("Business")
                                .tag([ExpenseItem.ExpenseType.business])
                            
                            Text("Personal")
                                .tag([ExpenseItem.ExpenseType.personal])
                        }
                    }
                    
                    Menu("Properties") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Name")
                                .tag([
                                    SortDescriptor(\ExpenseItem.name),
                                    SortDescriptor(\ExpenseItem.amount)
                                ])
                            
                            Text("Sort by Amount")
                                .tag([
                                    SortDescriptor(\ExpenseItem.amount),
                                    SortDescriptor(\ExpenseItem.name),
                                ])
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        let item1 = ExpenseItem(name: "1", type: .business, amount: 123)
        let item2 = ExpenseItem(name: "2", type: .business, amount: 124)
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}

extension String {
    static var localCurrencyCode: String {
        let locale = Locale.current
        return locale.currency?.identifier ?? "USD"
    }
}
