//
//  Item.swift
//  PhotoName
//
//  Created by Victor on 10.04.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    @Attribute(.externalStorage) var photo: Data
    
    init(name: String, photo: Data) {
        self.name = name
        self.photo = photo
    }
}

extension Item: Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        lhs.name < rhs.name
    }
}
