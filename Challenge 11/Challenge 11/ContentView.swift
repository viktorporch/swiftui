//
//  ContentView.swift
//  Challange 11
//
//  Created by Victor on 11.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query(
        sort: [
            SortDescriptor(\Book.rating, order: .reverse),
            SortDescriptor(\Book.title)
        ]
    ) private var books: [Book]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddBookView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init()]) {
                    ForEach(books) {
                        book in
                        
                        NavigationLink(value: book) {
                            HStack {
                                EmojiRatingView(rating: book.rating)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                        .foregroundStyle(book.rating == 1 ? .red : .black)
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteBook)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .navigationDestination(for: Book.self) {
                DetailsView(book: $0)
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        "Add book",
                        action: {
                            showAddBookView = true
                        }
                    )
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $showAddBookView) {
            AddBookView()
        }
    }
    
    private func deleteBook(at offsets: IndexSet) {
        offsets.forEach {
            modelContext.delete(books[$0])
        }
    }
}

#Preview {
    ContentView()
}
