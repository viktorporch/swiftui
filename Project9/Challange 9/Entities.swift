//
//  Activity.swift
//  Challange 9
//
//  Created by Victor on 07.03.2024.
//

import Foundation

class ActivityStorage: ObservableObject {
    @Published private(set) var activities: [Activity] {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.setValue(encoded, forKey: "activities")
            }
        }
    }
    
    init() {
        guard let data = UserDefaults.standard.data(forKey: "activities"),
              let items = try? JSONDecoder().decode([Activity].self, from: data) else {
            activities = []
            return
        }
        activities = items
    }
    
    func add(_ activity: Activity) {
        activities += [activity]
    }
    
    func remove(id: UUID) {
        activities.removeAll(where: { $0.id == id })
    }
    
    func update(_ activity: Activity) {
        guard let index = activities.firstIndex(where: { $0.id == activity.id }) else {
            add(activity)
            return
        }
        activities[index] = activity
    }
}

struct Activity: Identifiable, Codable {
    
    var id = UUID()
    
    let title: String
    let description: String?
    let count: Int
}
