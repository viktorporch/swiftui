//
//  ContentView.swift
//  Project14
//
//  Created by Victor on 07.04.2024.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    private let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            NavigationStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapModel)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .toolbar(content: {
                        Button("Switch map model") {
                            viewModel.showSwitchModel = true
                        }
                    })
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(
                    viewModel: .init(
                        location: place,
                        onSave: {
                            newLocation in
                            viewModel.update(location: newLocation)
                        }
                    )
                )
            }
            .confirmationDialog(
                "Select a model",
                isPresented: $viewModel.showSwitchModel,
                titleVisibility: .visible
            ) {
                Button("Standard") {
                    viewModel.mapModel = .standard
                }
                
                Button("Hybrid") {
                    viewModel.mapModel = .hybrid
                }
                
                Button("Imagery") {
                    viewModel.mapModel = .imagery
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert(
                    viewModel.errorText,
                    isPresented: $viewModel.showError) {
                        Button("OK") { }
                    }
        }
    }
}

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        var showSwitchModel = false
        var mapModel: MapStyle = .standard
        var showError = false
        var errorText = ""
        
        private let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(
                name: "New location",
                description: "",
                latitude: point.latitude,
                longitude: point.longitude
            )
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
            save()
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.showError = true
                        self.errorText = "Failed to auth"
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}

#Preview {
    ContentView()
}
