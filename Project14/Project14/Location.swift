//
//  Location.swift
//  Project14
//
//  Created by Victor on 07.04.2024.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: String {
        name + description + "\(latitude)" + "\(longitude)"
    }
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
#if DEBUG
    static let example = Location(
        name: "Buckingham Palace",
        description: "Lit by over 40,000 lightbulbs.",
        latitude: 51.501,
        longitude: -0.141
    )
#endif
}
