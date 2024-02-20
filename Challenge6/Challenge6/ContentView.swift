//
//  ContentView.swift
//  Challenge6
//
//  Created by Victor Rubenko on 21.02.2024.
//

import SwiftUI

struct ContentView: View {
    @State var multiplicationTables = 2
    @State var questionsAmount = 5
    @State var isGameStarted = false
    
    @State private var generatedQuestions = [(Int, Int)]()
    @State private var currentQuestion: (Int, Int) = (0, 0)
    @State private var currentAnswers = [Int]()
    @State private var totalScore = 0
    
    private let questionsAmounts = [5, 10, 20]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    .blue,
                    .yellow
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if !isGameStarted {
                VStack {
                    VStack {
                        Text("Select multiplication tables:")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .bold()
                        Picker(
                            "",
                            selection: $multiplicationTables
                        ) {
                            ForEach(2...12, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack {
                        Text("How many questions?")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .bold()
                        Picker(
                            "",
                            selection: $questionsAmount,
                            content: {
                                ForEach(questionsAmounts, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                        )
                        .pickerStyle(.segmented)
                    }
                    .padding(.top)
                    
                    Button(
                        action: {
                            startGame()
                        },
                        label: {
                            Text("Start Game")
                                .foregroundStyle(.white)
                                .bold()
                                .padding(20)
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(.white, lineWidth: 5)
                                )
                        }
                    )
                    .padding(.top)
                }
                .padding()
            } else {
                VStack {
                    Spacer()
                    Text("How much is: \(currentQuestion.0) * \(currentQuestion.1)?")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    ForEach(currentAnswers, id: \.self) {
                        answer in
                        
                        Button(
                            action: {
                                nextQuestion(answer)
                            },
                            label: {
                                Text("\(answer)")
                                    .foregroundStyle(.white)
                                    .bold()
                                    .font(.title3)
                                    .frame(width: 100, height: 70)
                                    .background(.gray.opacity(0.5))
                                    .clipShape(.rect(cornerRadius: 5))
                            }
                        )
                    }
                    Spacer()
                    Text("Total score: \(totalScore)")
                    Text("Remaining questions: \(generatedQuestions.count)")
                }
            }
        }
    }
    
    private func startGame() {
        generatedQuestions = []
        for _ in 1...questionsAmount {
            generatedQuestions.append(
                (
                    Int.random(in: 1...multiplicationTables),
                    Int.random(in: 1...multiplicationTables)
                )
            )
        }
        nextQuestion()
        isGameStarted = true
    }
    
    private func nextQuestion(_ answer: Int? = nil) {
        
        if let answer, answer == currentQuestion.0 * currentQuestion.1{
            totalScore += 1
        }
        
        guard let nextQuestion = generatedQuestions.popLast() else {
            isGameStarted = false
            return
        }
        currentQuestion = nextQuestion
        var answers = [currentQuestion.0 * currentQuestion.1]
        while true {
            let randomAnswer = Int.random(in: 1...multiplicationTables) * Int.random(in: 0...multiplicationTables)
            if !answers.contains(randomAnswer) {
                answers.append(randomAnswer)
            }
            if answers.count == 4 {
                break
            }
        }
        withAnimation(.bouncy) {
            currentAnswers = answers.shuffled()
        }
    }
}

#Preview {
    ContentView()
}
