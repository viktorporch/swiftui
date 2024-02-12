//
//  ContentView.swift
//  Challenge4
//
//  Created by Victor on 12.02.2024.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeUpTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = "..."
    @State private var isAlertShown = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .titleStyle()
                    DatePicker(
                        "Please, enter a time",
                        selection: $wakeUp,
                        in: Date.now...,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                Section {
                    Text("Desired amount of sleep")
                        .titleStyle()
                    Stepper(
                        "\(sleepAmount.formatted()) hour(s)",
                        value: $sleepAmount,
                        in: 4...12,
                        step: 0.25
                    )
                }
                Section {
                    Text("Daily coffee intake")
                        .titleStyle()
                    Picker(
                        "^[\(coffeeAmount) cup](inflect: true)",
                        selection: $coffeeAmount,
                        content: {
                            ForEach(0..<11) {
                                Text("\($0)")
                            }
                        }
                    )
                }
                
                Text("Your ideal betime is \(alertMessage)")
                    .font(.title2)
            }
            .navigationTitle("Better Rest")
//            .toolbar(content: {
//                Button("Calculate", action: calculateBedtime)
//            }
        }
        .onChange(of: coffeeAmount, calculateBedtime)
        .onChange(of: wakeUp, calculateBedtime)
        .onChange(of: sleepAmount, calculateBedtime)
        .alert(
            alertTitle,
            isPresented: $isAlertShown,
            actions: {
                Button("OK") { }
            },
            message: {
                Text(alertMessage)
            }
        )
    }
}

extension ContentView {
    private func calculateBedtime() {
        
        let time: Int = {
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            return (components.hour ?? 0) * 3600 + (components.minute ?? 0) * 60
        }()
        
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let prediction = try model.prediction(wake: Double(time), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal betime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Something go wrong"
        }
//        isAlertShown = true
    }
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .bold()
    }
}

#Preview {
    ContentView()
}
