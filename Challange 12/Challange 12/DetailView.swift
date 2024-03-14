//
//  DetailView.swift
//  Challange 12
//
//  Created by Victor on 15.03.2024.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    
    let user: User
    @Binding var path: [String]
    
    var body: some View {
        ScrollView {
            Text(user.about)
            Text("Registration: \(user.registered.formatted(date: .numeric, time: .omitted))")
            
            Group {
                Text("Friends:")
                LazyVGrid(columns: [.init()]) {
                    ForEach(user.friends, id: \.id) {
                        friend in
                        
                        NavigationLink(value: friend.id) {
                            Text(friend.name)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .padding()
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(user.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Return to main") {
                    path.removeAll()
                }
            }
        }
    }
}
