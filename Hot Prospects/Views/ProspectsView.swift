//
//  ProspectsView.swift
//  Hot Prospects
//
//  Created by Arthur Sh on 05.01.2023.
//

import UserNotifications
import CodeScanner
import SwiftUI

struct ProspectsView: View {
    enum FilterTypes {
        case none, contacted, uncontacted
    }
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    var filter: FilterTypes
    
    var body: some View {
        NavigationView{
            List {
                ForEach(filteredPeople) { prospect in
                    VStack(alignment: .leading){
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button{
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.orange)
                        } else {
                            Button{
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                setNotofication(for: prospect)
                            } label: {
                                Label("Add notification", systemImage: "bell")
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        }
        
    }
    //MARK: Set notification at 9 am
    func setNotofication(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addNotification = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { setting in
            if setting.authorizationStatus == .authorized {
                addNotification()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addNotification()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
    // MARK: to handle results from scanning qr code
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            
            guard details.count == 2 else { return }
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Failed to scan \(error.localizedDescription)")
        }
    }
    
    
    var title: String {
        switch filter {
        case .none:
            return "All"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredPeople: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
        
    }
}
