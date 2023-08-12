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

//private func nameIsValid(_ name: String) -> Bool {
//    if name.isEmpty {
//        registerError = .emptyNameField
//    } else if name.count < 3 {
//        registerError = .nameLessThanThreeCharacters
//    }
//
//    return registerError == nil
//}
//
//private func emailIsValid(_ email: String) -> Bool {
//    if email.isEmpty {
//        registerError = .emptyEmailField
//    } else if !email.contains("@") {
//        registerError = .mustContainAtSign
//    } else if !email.contains(".") {
//        registerError = .mustContainDot
//    } else {
//        if let localPart = email.components(separatedBy: "@").first {
//            if localPart.count < 3 {
//                registerError = .emailLocalPartLessThanThreeCharacters
//            }
//        }
//        else {
//            registerError = .mustContainAtSign
//        }
//    }
//
//    return registerError == nil
//}
//
//private func birthdayIsValid(_ birthday: Date) -> Bool {
//    do {
//        let formattedToday = try Date().removeTimestamp()
//        let formattedBirthday = try birthday.removeTimestamp()
//
//        if formattedBirthday > formattedToday {
//            registerError = .birthdayExceededToday
//        }
//    } catch {
//        registerError = .invalidBirthday
//    }
//
//    return registerError == nil
//}
