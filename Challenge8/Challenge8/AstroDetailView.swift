//
//  AstroDetailView.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import SwiftUI

struct AstroDetailView: View {
    
    let astro: AstrounautEntity
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Image(astro.id)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
                
                Text(astro.description)
                    .padding()
            }
            .navigationTitle(astro.name)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
        }
    }
}

#Preview {
    let astronaut = Bundle.main.decode([String: AstrounautEntity].self
                                       , path: "astronauts.json")!.first!
    
    return AstroDetailView(astro: astronaut.value)
        .preferredColorScheme(.dark)
}
