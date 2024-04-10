//
//  ProspectsView.swift
//  Project16
//
//  Created by Victor on 10.04.2024.
//

import SwiftUI
import SwiftData
import UserNotifications
import CodeScanner

enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectsView: View {
    
    private enum SortOrder {
        case byName, byRecent
    }
    
    let filter: FilterType
    
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    @State private var sortOrder: SortOrder = .byName
    @Query private var prospects: [Prospect]
    @Environment(\.modelContext) private var modelContext
    
    private var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    init(filter: FilterType) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
        }
    }
    
    var body: some View {
        NavigationStack {
            List(sortOrder == .byName ? prospects.sorted(by: { $0.name < $1.name }) : prospects, selection: $selectedProspects) { prospect in
                NavigationLink(
                    destination: {
                        EditingView(prospect: prospect)
                    },
                    label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(prospect.name)
                                    .font(.headline)
                                Text(prospect.emailAddress)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if filter == .none {
                                Image(
                                    systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark" : "person.crop.circle.badge.xmark"
                                )
                            }
                        }
                    }
                )
                .swipeActions {
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                    }
                    
                    Button("Remind Me", systemImage: "bell") {
                        addNotification(for: prospect)
                    }
                    .tint(.orange)
                    
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                }
                .tag(prospect)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                if !selectedProspects.isEmpty {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
                ToolbarItem {
                    Menu {
                        Button(
                            action: {
                                sortOrder = .byName
                            },
                            label: { Text("By Name") })
                        Button(
                            action: {
                                sortOrder = .byRecent
                            },
                            label: { Text("By recent") })
                    }
                label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                    completion: handleResult
                )
            }
        }
    }
    
    private func handleResult(_ result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            
            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    private func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    private func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
