//
//  PeopleListViewModel.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import SwiftUI
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
                   let birthday = person.birthday,
                   let data = person.dataPhoto,
                   let photo = UIImage(data: data) {
                    self.people.append(.init(id: id, name: name, email: email, birthday: birthday, photo: photo))
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
