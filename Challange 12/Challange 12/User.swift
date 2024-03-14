//
//  User.swift
//  Challange 12
//
//  Created by Victor on 15.03.2024.
//

import Foundation
import SwiftData

@Model
class User: Codable {
    let id: String
    let name: String
    let age: Int
    let company: String
    let registered: Date
    let about: String
    let email: String
    let address: String
    let tags: [String]
    let friends: [Friend]
    
    init(
        id: String,
        name: String,
        age: Int,
        company: String,
        registered: Date,
        about: String,
        email: String,
        address: String,
        tags: [String],
        friends: [Friend]
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.company = company
        self.registered = registered
        self.about = about
        self.email = email
        self.address = address
        self.tags = tags
        self.friends = friends
    }
    
    private enum CodingKeys : String, CodingKey {
        case id, name, age, company, registered, about, email, address, tags, friends
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.company = try container.decode(String.self, forKey: .company)
        self.registered = try container.decode(Date.self, forKey: .registered)
        self.about = try container.decode(String.self, forKey: .about)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.friends = try container.decode([Friend].self, forKey: .friends)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(registered, forKey: .registered)
        try container.encode(about, forKey: .about)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encode(tags, forKey: .tags)
        try container.encode(friends, forKey: .friends)
    }
}

@Model
class Friend: Codable {
    let id: String
    let name: String
    
    init(
        id: String,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
    private enum CodingKeys : String, CodingKey {
        case id, name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
