//
//  ContentView.swift
//  WeSplit
//
//  Created by Victor Rubenko on 24.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    private let tipPercent = [10, 20, 30, 0]
    
    @State private var numberOfPeople: Int = 2
    @State private var totalAmount: Double = 0.0
    @State private var selectedPercent: Int = 20
    @FocusState private var isTotalTextFieldFirstResponder: Bool
    
    private var totalAmountWithTip: Double {
        (totalAmount + totalAmount * Double(selectedPercent) / 100.0)
    }
    private var calculatedPart: Double {
        totalAmountWithTip / Double(numberOfPeople + 2)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Total amount") {
                        TextField("Total Amount", value: $totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "RUB")).keyboardType(.decimalPad)
                            .focused($isTotalTextFieldFirstResponder)
                    }
                    
                    Section("Options") {
                        Picker("Tip Percent:", selection: $selectedPercent) {
                            ForEach(0..<101) {
                                Text($0, format: .percent)
                            }
                        }
                        
                        Picker("Number of people:", selection: $numberOfPeople) {
                            ForEach(2..<11) {
                                Text(String($0))
                            }
                        }
                    }
                    
                    Section("Total amount with tip") {
                        Text(totalAmountWithTip, format: .currency(code: Locale.current.currency?.identifier ?? "RUB"))
                    }
                    
                    Section("Partical Amount") {
                        Text(calculatedPart, format: .currency(code: Locale.current.currency?.identifier ?? "RUB"))
                    }
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    isTotalTextFieldFirstResponder = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
