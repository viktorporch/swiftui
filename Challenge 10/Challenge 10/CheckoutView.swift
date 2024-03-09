//
//  CheckoutView.swift
//  Challenge 10
//
//  Created by Victor on 09.03.2024.
//

import SwiftUI

struct CheckoutView: View {
    
    @Bindable var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfigrmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(
                    url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                    scale: 3,
                    content: {
                        $0.resizable().scaledToFit()
                    },
                    placeholder: {
                            ProgressView()
                    }
                )
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button(
                    "Place Order",
                    action: {
                        Task {
                            await placeOrder()
                        }
                    }
                )
                .padding()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Thank you!",
            isPresented: $showingConfigrmation,
            actions: {
                Button("OK") {}
            },
            message: {
                Text(confirmationMessage)
            }
        )
    }
    
    private func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decoded = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decoded.quantity)x \(Order.types[decoded.type]) cupcakes is on its way!"
            showingConfigrmation = true
        } catch {
            confirmationMessage = "Failed to make an order!"
            showingConfigrmation = true
            print("Checkout failed: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
