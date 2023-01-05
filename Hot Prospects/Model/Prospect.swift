//
//  Prospect.swift
//  Hot Prospects
//
//  Created by Arthur Sh on 05.01.2023.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Annonymous"
    var emailAddress = ""
    var isContacted = false
}


@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        self.people = []
    }
}
