//
//  GridLayout.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import SwiftUI

struct GridLayout: View {
    
    private let layout: [GridItem] = [
        .init(.adaptive(minimum: 100, maximum: 120)),
        .init(.adaptive(minimum: 100, maximum: 120)),
        .init(.adaptive(minimum: 100, maximum: 120))
    ]
    let missions: [MissionEntity]
    let astronauts: [String: AstrounautEntity]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(missions) {
                    mission in
                    
                    NavigationLink(
                        destination: {
                            MissionView(
                                mission: mission,
                                astronauts: astronauts
                            )
                        },
                        label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding(1)
                                VStack {
                                    Text(mission.name)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.date)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .background(.blue)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }
                    )
                }
            }
            .background(.darkBackground)
        }
    }
}

#Preview {
    
    let missions = Bundle.main.decode([MissionEntity].self, path: "missions.json")!
    let astronauts = Bundle.main.decode([String: AstrounautEntity].self
                                        , path: "astronauts.json")!
    
    
    return GridLayout(missions: missions, astronauts: astronauts)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
