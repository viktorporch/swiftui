//
//  RatingView.swift
//  Challange 11
//
//  Created by Victor on 11.03.2024.
//

import SwiftUI

struct RatingView: View {
    
    @Binding var rating: Int
    var label = ""
    
    private let maxRating = 5
    
    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }
            
            ForEach(1..<maxRating + 1, id: \.self) {
                index in
                
                Button(
                    action: {
                        rating = index
                        print(rating)
                    },
                    label: {
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundStyle(index <= rating ? .yellow : .gray)
                    }
                )
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
