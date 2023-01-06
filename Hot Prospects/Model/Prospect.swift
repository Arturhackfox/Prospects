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
    fileprivate(set) var isContacted = false  //MARK: this property can be read from anywhere, but only written from current file
}


@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        self.people = []
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
    }
}
