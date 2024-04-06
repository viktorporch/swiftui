//
//  EditView.swift
//  Project14
//
//  Created by Victor on 07.04.2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

extension EditView {
    @Observable
    class ViewModel {
        var location: Location
        let onSave: (Location) -> Void

        var name: String
        var description: String
        private(set) var loadingState = LoadingState.loading
        private(set) var pages = [Page]()
        
        init(
            location: Location,
            onSave: @escaping (Location) -> Void
        ) {
            self.location = location
            self.onSave = onSave
            self.name = location.name
            self.description = location.description
            self.loadingState = loadingState
            self.pages = pages
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)

                // success – convert the array values to our pages array
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
        
        func save() {
            var newLocation = location
            newLocation.name = name
            newLocation.description = description

            onSave(newLocation)
        }
    }
}

#Preview {
    EditView(viewModel: .init(location: .example, onSave: { _ in }))
}
