//
//  EditionViewModel.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import Foundation

final class EditionViewModel: ObservableObject {
    
    @Published var person: PersonCell
    @Published var shouldDismiss: Bool = false
    @Published var registerError: CoreDataController.ValidationError?
    
    init(person: PersonCell) {
        self.person = person
    }
}

extension EditionViewModel {
    func editPerson() {
        do {
            try CoreDataController.checkName(person.name)
            try CoreDataController.checkEmail(person.email)
            try CoreDataController.checkBirthday(person.birthday)
            
            try CoreDataController.shared.editPerson(
                id: person.id,
                name: person.name,
                email: person.email,
                birthday: person.birthday
            )
            
            shouldDismiss = true
        } catch let error as CoreDataController.ValidationError{
            registerError = error
        } catch {
            registerError = .unknown
        }
    }
}
