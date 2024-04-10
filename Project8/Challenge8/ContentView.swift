//
//  ContentView.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var missions = [MissionEntity]()
    @State private var astronauts = [String: AstrounautEntity]()
    @State private var showGrid = true
    
    var body: some View {
        NavigationStack {
            Group {
                if showGrid {
                    GridLayout(missions: missions, astronauts: astronauts)
                } else {
                    ListLayout(missions: missions, astronauts: astronauts)
                }
            }
            .navigationDestination(for: Int.self) { selection in
                
                MissionView(mission: missions[selection], astronauts: astronauts)
            }
            .navigationTitle("Moonshot")
            .toolbar {
                Button("List/Grid") {
                    withAnimation(.linear) {
                        showGrid.toggle()
                    }
                }
            }
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
        .onAppear {
            if let missions = Bundle.main.decode([MissionEntity].self, path: "missions.json") {
                self.missions = missions
            }
            self.astronauts = Bundle.main.decode([String: AstrounautEntity].self, path: "astronauts.json")!
        }
    }
}

extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}

#Preview {
    ContentView()
}
