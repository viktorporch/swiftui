//
//  ActivityDetails.swift
//  Challange 9
//
//  Created by Victor on 07.03.2024.
//

import SwiftUI

struct ActivityDetailsView: View {
    
    let aStorage: ActivityStorage
    let activity: Activity
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                VStack {
                    Stepper("Your count", value: $count)
                    Text("Count: \(count)")
                }
            }
            Button(
                "Save",
                action: {
                    aStorage.update(
                        .init(
                            id: activity.id,
                            title: title,
                            description: description,
                            count: count
                        )
                    )
                }
            )
        }
        .onAppear {
            title = activity.title
            description = activity.description ?? ""
            count = activity.count
        }
    }
}
