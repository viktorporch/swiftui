//
//  AddView.swift
//  Challenge7
//
//  Created by Victor on 21.02.2024.
//

import SwiftUI

struct AlertData {
    var title: String = ""
    var text: String = ""
    var isAlertShowing = false
}

struct AddView: View {
    
    @State private var name = ""
    @State private var type: ExpenseItem.ExpenseType = .personal
    @State private var amount = 0.0
    @Environment(\.dismiss) private var dismiss
    @State private var alertData = AlertData()
    
    var expenses: Expenses
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Name", text: $name)
                    
                    Picker(
                        "Type",
                        selection: $type,
                        content: {
                            ForEach(ExpenseItem.ExpenseType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    )
                    .pickerStyle(.segmented)
                    
                    TextField(
                        "Amount",
                        value: $amount,
                        format: .currency(code: .localCurrencyCode)
                    )
                    .keyboardType(.decimalPad)
                }
                Button("Add") {
                    addExepnseItem()
                }
            }
            .navigationTitle("Add new expense")
            .alert(
                alertData.title,
                isPresented: $alertData.isAlertShowing,
                actions: {
                    Button("OK") {}
                },
                message: {
                    Text(alertData.text)
                }
            )
        }
    }
    
    private func addExepnseItem() {
        guard name.count > 0,
              amount > 0 else {
            alertData = .init(
                title: "Oops..",
                text: "Name or Amount is invalid",
                isAlertShowing: true
            )
            return
        }
        expenses.items.append(
            .init(
                name: name,
                type: type,
                amount: amount
            )
        )
        alertData = .init(
            title: "Success",
            text: "New Expense Item was added",
            isAlertShowing: true
        )
    }
}

#Preview {
    AddView(expenses: .init())
}
