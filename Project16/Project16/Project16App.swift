//
//  Project16App.swift
//  Project16
//
//  Created by Victor on 10.04.2024.
//

import SwiftUI
import SwiftData

@main
struct Project16App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
