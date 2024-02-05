//
//  ContentView.swift
//  Challenge3
//
//  Created by Victor  on 06.02.2024.
//

import SwiftUI

struct RPSButton: View {
    enum ButtonType: String, CaseIterable {
        case rock, papper, scissors
    }
    
    let type: ButtonType
    let action: (ButtonType) -> Void
    
    var body: some View {
        Button(action: { action(type) }, label: {
            VStack {
                Image(type.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(type.rawValue.capitalized)
                    .foregroundStyle(.white)
            }
        })
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.largeTitle)
            .bold()
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    
    @State private var gameStarted = false
    @State private var appMove: RPSButton.ButtonType = .rock
    @State private var result = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.cyan.opacity(0.4), .cyan],
                startPoint: .top,
                endPoint: .bottom
            )
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text(gameStarted ? result : "Your turn")
                    .titleStyle()
                Image(appMove.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(gameStarted ? 1 : 0)
                Text("Your turn")
                    .titleStyle()
                    .opacity(gameStarted ? 1 : 0)
                Spacer()
                HStack {
                    ForEach(RPSButton.ButtonType.allCases, id: \.self) {
                        RPSButton(type: $0) {
                            select($0)
                        }
                        .padding(10)
                        .background(.gray.opacity(0.5), in: .rect(cornerRadius: 10))
                    }
                }
                .padding(10)
                Spacer()
                    .frame(height: 10)
            }
        }
    }
    
    private func select(_ selection: RPSButton.ButtonType) {
        gameStarted = true
        appMove = RPSButton.ButtonType.allCases.randomElement() ?? .rock
        switch (appMove, selection) {
        case (.rock, .rock), (.papper, .papper), (.scissors, .scissors):
            result = "Tie"
        case (.rock, .scissors), (.papper, .rock), (.scissors, .papper):
            result = "You lose"
        default:
            result = "You win"
        }
    }
}

#Preview {
    ContentView()
}
