//
//  Challange_11App.swift
//  Challange 11
//
//  Created by Victor on 11.03.2024.
//

import SwiftUI
import SwiftData

@main
struct Challange_11App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
