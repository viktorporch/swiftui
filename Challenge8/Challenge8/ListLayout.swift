//
//  ListLayout.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import SwiftUI

struct ListLayout: View {
    
    @State var missions: [MissionEntity]
    @State var astronauts: [String: AstrounautEntity]
    
    var body: some View {
            ScrollView {
                LazyVStack {
                    ForEach(missions) {
                        mission in
                        
                        NavigationLink(
                            destination: {
                                MissionView(mission: mission, astronauts: astronauts)
                            },
                            label: {
                                HStack {
                                    Image(mission.image)
                                        .resizable()
                                        .scaledToFit()
                                    VStack {
                                        Text(mission.name)
                                            .font(.headline)
                                        Text(mission.date)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
                                }
                                .frame(
                                    height: 100
                                )
                                .padding()
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
    
    
    return ListLayout(missions: missions, astronauts: astronauts)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
