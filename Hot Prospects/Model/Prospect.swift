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
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        
        people = []
    }
    
   private func save() {
        if let data = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
