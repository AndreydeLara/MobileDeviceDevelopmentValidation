//
//  RegisterViewModel.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import SwiftUI
import Foundation

final class RegisterViewModel: ObservableObject {
    
    @Published var shouldDismiss: Bool = false
    @Published var registerError: CoreDataController.ValidationError?
    
}

extension RegisterViewModel {
    func createPerson(name: String, email: String, birthday: Date, photo: UIImage?) {
        do {
            try CoreDataController.checkName(name)
            try CoreDataController.checkEmail(email)
            try CoreDataController.checkBirthday(birthday)
            let photo = try CoreDataController.checkPhoto(photo)
            
            try CoreDataController.shared.createPerson(name: name, email: email, birthday: birthday, photo: photo)
            shouldDismiss = true
        } catch let error as CoreDataController.ValidationError{
            registerError = error
        } catch {
            registerError = .unknown
        }
    }
}
