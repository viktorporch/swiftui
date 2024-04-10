//
//  ContentView.swift
//  Challenge1
//
//  Created by Victor Rubenko on 26.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    private enum Length: String, CaseIterable {
        case m
        case km
        case ft
        case yard
        case mile
    }
    @State private var selectedInput: Length = .m
    @State private var selectedOutput: Length = .km
    @State private var inputValue: Double = 0
    private var outputValue: Double {
        let inputMeters: Double
        switch selectedInput {
        case .m:
            inputMeters = inputValue
        case .km:
            inputMeters = inputValue * 1000
        case .ft:
            inputMeters = inputValue * 0.3048
        case .yard:
            inputMeters = inputValue * 0.9144
        case .mile:
            inputMeters = inputValue * 1609.34
        }
        
        switch selectedOutput {
        case .m:
            return inputMeters
        case .km:
            return inputMeters * 0.001
        case .ft:
            return inputMeters * 3.28084
        case .yard:
            return inputMeters * 1.09361
        case .mile:
            return inputMeters * 0.000621371
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Input") {
                        Picker("Input", selection: $selectedInput) {
                            ForEach(Length.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    Section("Output") {
                        Picker("Output", selection: $selectedOutput) {
                            ForEach(Length.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    Section("Input value") {
                        TextField("Input value", value: $inputValue, format: .number )
                    }
                    
                    Section("Output value") {
                        Text(outputValue.formatted())
                    }
                    
                }
            }
            .navigationTitle("Lenght conversion")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
