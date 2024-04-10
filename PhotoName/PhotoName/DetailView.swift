//
//  DetailView.swift
//  PhotoName
//
//  Created by Victor on 10.04.2024.
//

import SwiftUI

struct DetailView: View {
    
    let item: Item
    
    var body: some View {
        VStack {
            if let image = UIImage(data: item.photo) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .navigationTitle(item.name)
    }
}
