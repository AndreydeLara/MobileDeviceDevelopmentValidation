//
//  RegisterViewModel.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    
    @Published var shouldDismiss: Bool = false
    @Published var registerError: CoreDataController.ValidationError?
    
}

extension RegisterViewModel {
    func createPerson(name: String, email: String, birthday: Date) {
        do {
            try CoreDataController.checkName(name)
            try CoreDataController.checkEmail(email)
            try CoreDataController.checkBirthday(birthday)
            
            try CoreDataController.shared.createPerson(name: name, email: email, birthday: birthday)
            shouldDismiss = true
        } catch let error as CoreDataController.ValidationError{
            registerError = error
        } catch {
            registerError = .unknown
        }
    }
}
