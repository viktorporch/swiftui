//
//  MissionView.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import SwiftUI

struct MissionView: View {
    
    let mission: MissionEntity
    let astronauts: [String: AstrounautEntity]
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) {
                        length, axis in
                        
                        return length * 0.5
                    }
                    .padding(.top)
                Text("Launch Date: \(mission.date)")
                    .font(.title)
                Text("Mission Highlights")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(.bottom)
                Text(mission.description)
                    .font(.headline)
                    .foregroundStyle(.white)
                VStack(alignment: .leading) {
                    Text("Crew")
                        .foregroundStyle(.white)
                        .padding(.top)
                        .bold()
                    MissionScrollView(
                        crew: mission.crew,
                        astronauts: astronauts
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.all)
        }
        .navigationTitle(mission.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

#Preview {
    
    let mission = Bundle.main.decode([MissionEntity].self, path: "missions.json")!.first!
    let astronauts = Bundle.main.decode([String: AstrounautEntity].self
                                        , path: "astronauts.json")!
    
    return MissionView(mission: mission, astronauts: astronauts)
        .preferredColorScheme(.dark)
}
