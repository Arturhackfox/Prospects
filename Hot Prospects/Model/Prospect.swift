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
    var created = Date.now
}


@MainActor class Prospects: ObservableObject {
    @Published  var people: [Prospect]
    let saveKey = "SavedData"
    let url = FileManager.directory.appendingPathComponent("ProspectsData")
    
    init() {
        do{
            let data = try Data(contentsOf: url)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            print("Data loaded!")
        } catch {
            print("empty array")
            people = []
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
                try data.write(to: url)
                print("write success!")
        } catch {
            print("failed to write data!\(error.localizedDescription)")
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
    
    enum SortTypes {
        case byDate, byName
    }
    
    func sort(_ sortType: SortTypes) {
        switch sortType {
        case .byDate:
            people = people.sorted { $0.created > $1.created}
        case .byName:
            people = people.sorted{ $0.name < $1.name}
        }
    }
}
