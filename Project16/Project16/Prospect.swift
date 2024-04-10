//
//  Prospect.swift
//  Project16
//
//  Created by Victor on 10.04.2024.
//

import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    
    init(
        name: String,
        emailAddress: String,
        isContacted: Bool
    ) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
}
