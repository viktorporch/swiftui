//
//  ContentView.swift
//  Challenge 10
//
//  Created by Victor on 09.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(
                        "Selecy your cake type",
                        selection: $order.type,
                        content: {
                            ForEach(Order.types, id: \.self) {
                                Text($0.capitalized)
                            }
                        }
                    )
                    
                    Stepper(
                        "Number of cakes: \(order.quantity)",
                        value: $order.quantity
                    )
                }
                
                Section {
                    Toggle(
                        "Any special requests?",
                        isOn: $order.specialRequestEnabled
                    )
                    
                    if order.specialRequestEnabled {
                        Toggle(
                            "Add extra frosting",
                            isOn: $order.extraFrosting
                        )
                        Toggle(
                            "Add extra sprinkles",
                            isOn: $order.addSprinkles
                        )
                    }
                }
                
                Section {
                    NavigationLink(
                        "Delivery details",
                        destination: {
                            AddressView(order: order)
                        }
                    )
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
