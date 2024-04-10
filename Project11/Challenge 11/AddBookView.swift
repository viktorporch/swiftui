//
//  AddBookView.swift
//  Challange 11
//
//  Created by Victor on 11.03.2024.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 2
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var showingWarning = false
    
    private let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        addNewBook()
                    }
                }
            }
            .navigationTitle("Add book")
        }
        .alert(
            "Warning",
            isPresented: $showingWarning,
            actions: {
                Button("OK") { }
            },
            message: {
                Text("Title, Author and Genre must not be empty!")
            }
        )
    }
    
    private func addNewBook() {
        guard !title.isEmpty, !author.isEmpty, !genre.isEmpty else {
            showingWarning = true
            return
        }
        let newBook = Book(
            title: title,
            author: author,
            genre: genre,
            review: review,
            rating: rating
        )
        modelContext.insert(newBook)
        dismiss()
    }
}

#Preview {
    AddBookView()
}
