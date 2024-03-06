//
//  AddActivityView.swift
//  Challange 9
//
//  Created by Victor on 07.03.2024.
//

import SwiftUI

struct AddActivityView: View {
    
    let aStorage: ActivityStorage
    @State private var title = ""
    @State private var description = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            Button(
                action: {
                    addNewActivity()
                },
                label: {
                    Text("Add")
                }
            )
        }
        .navigationTitle("New Activity")
        .alert(
            "Title is empty",
            isPresented: $showAlert,
            actions: {
                Button("OK", action: {})
            }
        )
    }
    
    private func addNewActivity() {
        guard !title.isEmpty else {
            showAlert = true
            return
        }
        aStorage.add(
            .init(
                title: title,
                description: description.isEmpty ? nil : description,
                count: .zero
            )
        )
    }
}

#Preview {
    AddActivityView(aStorage: ActivityStorage())
}
