//
//  PeopleListViewModel.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import Foundation

@MainActor final class PeopleListViewModel: ObservableObject {
    
    @Published var people: [PersonCell] = []
    @Published var isAlertPresented: Bool = false
    
}

extension PeopleListViewModel {
    func fetchPeople() {
        do {
            let people = try CoreDataController.shared.fetchPeople()
            
            self.people.removeAll()
            
            for person in people {
                if let id = person.id,
                   let name = person.name,
                   let email = person.email,
                   let birthday = person.birthday {
                    self.people.append(.init(id: id, name: name, email: email, birthday: birthday))
                } else {
                    isAlertPresented = true
                    return
                }
            }
        } catch {
            isAlertPresented = true
        }
    }
}

struct PersonCell: Identifiable {
    var id: UUID
    var name: String
    var email: String
    var birthday: Date
}
