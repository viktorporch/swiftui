//
//  ContentView.swift
//  Challange 12
//
//  Created by Victor on 15.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User] = []
    @State private var path = [String]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(users, id: \.id) {
                    user in
                    
                    NavigationLink(value: user.id) {
                        Text(user.name)
                    }
                }
            }
            .navigationDestination(
                for: String.self,
                destination: {
                    id in
                    
                    DetailView(
                        user: users.first(where: { $0.id == id })!,
                        path: $path
                    )
                }
            )
        }
        .task {
            guard users.isEmpty else {
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(string:"https://www.hackingwithswift.com/samples/friendface.json")!)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let users = try decoder.decode([User].self, from: data)
                users.forEach {
                    modelContext.insert($0)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
