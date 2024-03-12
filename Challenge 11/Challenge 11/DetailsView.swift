//
//  DetailsView.swift
//  Challenge 11
//
//  Created by Victor on 13.03.2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    
    let book: Book
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .trailing) {
                    Text(book.genre.uppercased())
                        .modifier(Capsule())
                    Text(
                        book.date.formatted(
                            date: .abbreviated,
                            time: .shortened
                        )
                    )
                    .modifier(Capsule())
                }
            }
            
            Text(book.author)
                .font(.title)
                .foregroundStyle(.secondary)
            
            Text(book.review)
                .padding()
            
            RatingView(rating: .constant(book.rating))
                .font(.largeTitle)
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            Button(
                "Delete this book",
                systemImage: "trash",
                action: {
                    showingDeleteAlert = true
                }
            )
        }
        .alert(
            "Delete book",
            isPresented: $showingDeleteAlert,
            actions: {
                Button("Delete", role: .destructive, action: deleteBook)
                Button("Cancel", role: .cancel) {}
            },
            message: {
                Text("Are you sure?")
            }
        )
    }
    
    private func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

private struct Capsule: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .fontWeight(.black)
            .padding(8)
            .foregroundStyle(.white)
            .background(.black.opacity(0.75))
            .clipShape(.capsule)
            .offset(x: -5, y: -5)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it.", rating: 4)
        
        return DetailsView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
