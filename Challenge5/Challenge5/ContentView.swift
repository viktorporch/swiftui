//
//  ContentView.swift
//  Challenge5
//
//  Created by Victor  on 15.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var enteredWords = [String]()
    @State var rootWord = "123"
    @State var newWord = ""
    @State var isAlertShown = false
    @State var score = 0
    
    private let checker = UITextChecker()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word:", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .onSubmit(addNewWord)
                    
                    Text("Score: \(score)")
                        .opacity(score == 0 ? 0 : 1)
                }
                
                Section("Entered words:") {
                    ForEach(enteredWords, id: \.self) {
                        word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbarTitleDisplayMode(.large)
            .toolbar {
                Button("New Game") {
                    startGame()
                }
            }
        }
        .alert(
            "Opps...",
            isPresented: $isAlertShown,
            actions: {
                Button("OK", action: {})
            },
            message: {
                Text("Invalid word")
            }
        )
        .onAppear(perform: {
            startGame()
        })
    }
    
    private func startGame() {
        enteredWords = []
        newWord = ""
        guard let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let data = try? String(contentsOf: fileURL)
        else {
            return
        }
        let words = data.components(separatedBy: "\n").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        rootWord = words.randomElement() ?? "eralash"
    }
    
    private func addNewWord() {
        guard !enteredWords.contains(newWord),
              isPossible(),
              isReal(),
              newWord.count >= 3 else {
            isAlertShown = true
            return
        }
        
        enteredWords.insert(newWord, at: 0)
        score += newWord.count
        newWord = ""
    }
    
    private func isPossible() -> Bool {
        var tempWord = rootWord
        for char in newWord {
            guard let index = tempWord.firstIndex(of: char) else {
                return false
            }
            tempWord.remove(at: index)
        }
        return true
    }
    
    private func isReal() -> Bool {
        checker.rangeOfMisspelledWord(
            in: newWord,
            range: .init(location: 0, length: newWord.utf16.count),
            startingAt: .zero,
            wrap: false,
            language: "en"
        ).location == NSNotFound
    }
}

#Preview {
    ContentView()
}
