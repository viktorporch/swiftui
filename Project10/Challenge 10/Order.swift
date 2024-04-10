//
//  Order.swift
//  Challenge 10
//
//  Created by Victor on 09.03.2024.
//

import Foundation

private struct AddressData: Codable {
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
}

@Observable
class Order: Codable {
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rawinbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            extraFrosting = false
            addSprinkles = false
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = "" {
        didSet {
            saveAddress()
        }
    }
    var streetAddress = "" {
        didSet {
            saveAddress()
        }
    }
    var city = "" {
        didSet {
            saveAddress()
        }
    }
    var zip = "" {
        didSet {
            saveAddress()
        }
    }
    
    var hasValidAddress: Bool {
        ![name, streetAddress, city, zip].map { $0.trimmingCharacters(in: .whitespaces).isEmpty }.contains(true)
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type) / 2
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
    
    init() {
        loadAddress()
    }
    
    private func saveAddress() {
        let address = AddressData(name: name, streetAddress: streetAddress, city: city, zip: zip)
        guard let encoded = try? JSONEncoder().encode(address) else {
            return
        }
        UserDefaults.standard.setValue(encoded, forKey: "addressData")
    }
    
    private func loadAddress() {
        guard let data = UserDefaults.standard.data(forKey: "addressData"),
              let decoded = try? JSONDecoder().decode(AddressData.self, from: data) else {
            return
        }
        name = decoded.name
        streetAddress = decoded.streetAddress
        city = decoded.city
        zip = decoded.zip
    }
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrostings"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
}
