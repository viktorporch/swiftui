//
//  ContentView.swift
//  Challenge2
//
//  Created by Victor  on 28.01.2024.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .bold()
    }
}

struct FlagButton: View {
    
    let action: () -> Void
    let country: String
    
    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                Image(country)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 5))
                    .shadow(radius: 10)
            }
        )
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var answer: Int = 0
    @State private var isGameStarted = false
    @State private var result = ""
    @State private var isResultShown = false
    @State private var score = 0
    @State private var counter = 0
    @State private var isCorrectAnswerShown = false
    @State private var givenAnswer = ""
    @State private var rotateAmount = 0.0
    @State private var opacity = 1.0
    @State private var choosenFlag = -1
    @State private var scaleValue = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: .blue, location: 0.7),
                        .init(color: .cyan, location: 0.1)
                ],
                center: .top,
                startRadius: 350,
                endRadius: 1
            )
                .ignoresSafeArea()
            VStack(spacing: 15) {
                Text("Guess the flag")
                    .modifier(Title())
                Spacer()
                VStack {
                    if !isGameStarted {
                        Button(
                            action: {
                                isGameStarted = true
                                answer = Int.random(in: 0..<3)
                            },
                            label: {
                                Text("Start")
                                    .foregroundStyle(.yellow)
                                    .font(.title)
                                    .bold()
                                    .padding(10)
                                    .background(.white, in: .capsule(style: .continuous))
                            }
                        )
                    } else {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.white)
                            Text(countries[answer])
                                .foregroundStyle(.yellow)
                                .bold()
                                .font(.title)
                            
                            HStack {
                                ForEach(0..<3) {
                                    number in
                                    
                                    FlagButton(action: {
                                        tapFlag(number)
                                        choosenFlag = number
                                        withAnimation(.spring(duration: 1.0)) {
                                            rotateAmount = 360
                                            opacity = 0.25
                                            scaleValue = 2
                                        }
                                        scaleValue = 1
                                        opacity = 1.0
                                        rotateAmount = 0
                                    }, country: countries[number])
                                    .rotation3DEffect(
                                        .degrees(number == choosenFlag ? rotateAmount : 0),
                                        axis: (x: 1, y: 0, z:0)
                                    )
                                    .scaleEffect(number != choosenFlag ? scaleValue : 1)
                                }
                            }
                            Text(result)
                                .foregroundStyle(.white)
                                .bold()
                                .font(.largeTitle)
                        }
                        .padding(20)
                        .background(.regularMaterial, in: .rect(cornerRadius: 10))
                        .padding(.init(top: .zero, leading: 10, bottom: .zero, trailing: 10))

                    }
                }
                Spacer()
            }
        }
        .alert("Result", isPresented: $isResultShown) {
            Button("New Game") {
                isResultShown = false
                newGame()
            }
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Invalid", isPresented: $isCorrectAnswerShown, actions: {
            Button {
                isCorrectAnswerShown = false
            } label: {
                Text("Ok")
            }

        }, message: { Text("This is flag of \(givenAnswer)") } )
    }
    
    private func tapFlag(_ number: Int) {
        if number == answer {
            result = "Correct"
            score += 1
        } else {
            result = "Invalid"
            score -= 1
            givenAnswer = countries[number]
            isCorrectAnswerShown = true
        }
        counter += 1
        if counter == 8 {
            isResultShown = true
            isGameStarted = false
        } else {
            askQuestion()
        }
    }
    
    private func askQuestion() {
        countries = countries.shuffled()
        answer = Int.random(in: 0..<3)
    }
    
    private func newGame() {
        isGameStarted = true
        counter = 0
    }
}

#Preview {
    ContentView()
}
