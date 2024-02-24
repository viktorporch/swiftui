//
//  MissionScrollView.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import SwiftUI

struct MissionScrollView: View {
    
    let crew: [CrewMemberEntity]
    let astronauts: [String: AstrounautEntity]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [.init()]) {
                ForEach(crew, id: \.name) {
                    member in
                    
                    if let astro = astronauts[member.name] {
                        NavigationLink(
                            destination: {
                                AstroDetailView(astro: astro)
                            },
                            label: {
                                HStack {
                                    Image(member.name)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 75)
                                        .clipShape(.rect(cornerRadius: 5))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(.white)
                                        )
                                    VStack(alignment: .leading) {
                                        Text(astro.name)
                                        Text(member.role)
                                    }
                                }
                                .padding()
                            }
                        )
                    }
                }
            }
        }
        .background(.darkBackground)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    let mission = Bundle.main.decode([MissionEntity].self, path: "missions.json")!.first!
    let astronauts = Bundle.main.decode([String: AstrounautEntity].self
                                        , path: "astronauts.json")!
    return MissionScrollView(crew: mission.crew, astronauts: astronauts)
        .preferredColorScheme(.dark)
}
