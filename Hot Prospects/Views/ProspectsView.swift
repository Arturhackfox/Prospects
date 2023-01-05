//
//  ProspectsView.swift
//  Hot Prospects
//
//  Created by Arthur Sh on 05.01.2023.
//

import SwiftUI

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    enum FilterTypes {
        case none, contacted, uncontacted
    }
    
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
                    let new = Prospect()
                    new.name = "new"
                    new.emailAddress = "@mail.ua"
                    new.isContacted = true
                    prospects.people.append(new)
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
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
