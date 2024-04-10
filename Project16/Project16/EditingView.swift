//
//  EditingView.swift
//  Project16
//
//  Created by Victor on 10.04.2024.
//

import SwiftUI

struct EditingView: View {
    
    @Environment(\.modelContext) private var modelContext
    private var prospect: Prospect
    @State private var name: String
    @State private var address: String
    
    init(prospect: Prospect) {
        self.prospect = prospect
        self._name = .init(initialValue: prospect.name)
        self._address = .init(initialValue: prospect.emailAddress)
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Address", text: $address)
        }
        .onChange(of: name) {
            save()
        }
        .onChange(of: address) {
            save()
        }
    }
    
    private func save() {
        prospect.name = name
        prospect.emailAddress = address
    }
}
