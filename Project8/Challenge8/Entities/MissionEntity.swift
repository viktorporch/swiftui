//
//  MissionEntity.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import Foundation

struct MissionEntity: Codable, Identifiable {
    let id: Int
    let launchDate: Date?
    let crew: [CrewMemberEntity]
    let description: String
    
    var image: String {
        "apollo\(id)"
    }
    
    var name: String {
        "Apollo \(id)"
    }
    
    var date: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}

struct CrewMemberEntity: Codable {
//    let id = UUID()
    let name: String
    let role: String
}
