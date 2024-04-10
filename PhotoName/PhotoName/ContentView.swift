//
//  ContentView.swift
//  PhotoName
//
//  Created by Victor on 10.04.2024.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showNameDialog = false
    @State private var name = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items.sorted()) { item in
                    NavigationLink(
                        destination: {
                            DetailView(item: item)
                        },
                        label: {
                            HStack {
                                Text(item.name)
                                Spacer()
                                if let image = UIImage(data: item.photo) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                    )
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    PhotosPicker(
                        "Add image",
                        selection: $selectedImageItem,
                        matching: .images
                    )
                }
            }
        } detail: {
            Text("Select an item")
        }
        .onChange(of: selectedImageItem) {
            Task {
                await loadImage()
            }
        }
        .alert("Enter name", isPresented: $showNameDialog) {
            TextField("Name", text: $name)
            Button("OK") {
                guard let selectedImageData else {
                    return
                }
                modelContext.insert(Item(name: name, photo: selectedImageData))
            }
        } message: {
            Text("Enter name of photo")
        }
    }
    
    private func loadImage() async {
        if let loaded = try? await selectedImageItem?.loadTransferable(type: Data.self) {
            selectedImageData = loaded
            showNameDialog = true
        } else {
            print("Failed")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
