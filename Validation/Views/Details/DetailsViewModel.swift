//
//  DetailsViewModel.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import Foundation
import SwiftUI

final class DetailsViewModel: ObservableObject {
    
    @Published var person: PersonCell
    @Published var isAlertPresented: Bool = false
    
    init(person: PersonCell) {
        self.person = person
    }
}

extension DetailsViewModel {
    func fetchPerson() {
        do {
            let person = try CoreDataController.shared.fetchPerson(from: person.id)
            
            if let id = person.id,
               let name = person.name,
               let email = person.email,
               let birthday = person.birthday {
                self.person = .init(id: id, name: name, email: email, birthday: birthday)
            } else {
                isAlertPresented = true
                return
            }
            
            isAlertPresented = false
        } catch {
            isAlertPresented = true
        }
    }
    
    func deletePerson(dismiss: DismissAction) {
        do {
            try CoreDataController.shared.deletePerson(from: person.id)
            isAlertPresented = false
            dismiss()
        } catch {
            isAlertPresented = true
        }
    }
}
