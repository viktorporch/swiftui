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
        .accessibilityElement()
        .accessibilityLabel(label)
        .accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if rating < maxRating { rating += 1 }
            case .decrement:
                if rating > 1 { rating -= 1 }
            default:
                break
            }
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
