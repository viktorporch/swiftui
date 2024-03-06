//
//  MainView.swift
//  Challange 9
//
//  Created by Victor on 07.03.2024.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var aStorage = ActivityStorage()
    @State private var showDetails = false
    @State private var selectedActivity: Activity = .init(title: "", description: "", count: .zero)
    
    var body: some View {
        VStack {
            List {
                ForEach(aStorage.activities) {
                    activity in
                    
                    Button(
                        action: {
                            selectedActivity = activity
                            showDetails = true
                        },
                        label: {
                            HStack {
                                Text(activity.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Count: \(activity.count)")
                            }
                        }
                    )
                    .swipeActions() {
                        Button(
                            "Delete",
                            action: {
                                withAnimation(.default) {
                                    aStorage.remove(id: activity.id)
                                }
                            }
                        )
                        .tint(.red)
                    }
                }
            }
            if aStorage.activities.isEmpty {
                Text("Add new activity!")
                    .foregroundStyle(.blue)
                    .bold()
            }
        }
        .sheet(
            isPresented: $showDetails,
            content: {
                ActivityDetailsView(
                    aStorage: aStorage,
                    activity: selectedActivity
                )
            }
        )
        .toolbar {
            NavigationLink(
                destination: {
                    AddActivityView(aStorage: aStorage)
                },
                label: {
                    HStack {
                        Text("Add activity")
                        Image(systemName: "plus")
                    }
                }
            )
        }
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainView()
}
