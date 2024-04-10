//
//  Bundle + Extension.swift
//  Challenge8
//
//  Created by Victor on 24.02.2024.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, path: String) -> T? {
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let url = self.url(forResource: path, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let decoded = try? decoder.decode(type, from: data) else  {
            return nil
        }
        return decoded
    }
}
