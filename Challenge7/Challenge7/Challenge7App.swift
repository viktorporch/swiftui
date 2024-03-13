//
//  Challenge7App.swift
//  Challenge7
//
//  Created by Victor on 21.02.2024.
//

import SwiftUI
import SwiftData

@main
struct Challenge7App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
