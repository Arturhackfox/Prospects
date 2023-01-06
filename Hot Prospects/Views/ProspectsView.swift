//
//  ProspectsView.swift
//  Hot Prospects
//
//  Created by Arthur Sh on 05.01.2023.
//

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
                CodeScannerView(codeTypes: [.qr], completion: handleScan)
            }
        }
       
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            
            guard details.count == 2 else { return }
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.people.append(person)
            
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
