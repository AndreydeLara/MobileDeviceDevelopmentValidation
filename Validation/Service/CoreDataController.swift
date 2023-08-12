//
//  DataController.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import CoreData
import Foundation
import SwiftUI

final class CoreDataController: ObservableObject {
    
    static let shared = CoreDataController()
    
    private let container = NSPersistentContainer(name: "DataBase")
    
    private init() { }
    
    enum Error: Swift.Error {
        case failToFetchPerson
    }
}

extension CoreDataController {
    func setUp(completionHandler: @escaping () -> Void)  {
        container.loadPersistentStores { _, error in
            if error != nil { completionHandler() }
        }
    }
    
    func fetchPerson(from id: UUID) throws -> Person {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        let person = try container.viewContext.fetch(fetchRequest).first
        
        guard let person else { throw Error.failToFetchPerson }
        
        return person
    }
    
    func fetchPeople() throws -> [Person] {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let people = try container.viewContext.fetch(fetchRequest)
        return people
    }
    
    func createPerson(name: String, email: String, birthday: Date, photo: UIImage) throws {
        let person = Person(context: container.viewContext)
        
        person.id = UUID()
        person.name = name
        person.email = email
        person.birthday = birthday
        
        guard let dataPhoto = photo.pngData() else { throw ValidationError.failToCreatePerson }
        
        person.dataPhoto = dataPhoto
        
        try container.viewContext.save()
    }
    
    func deletePerson(from id: UUID) throws {
        let person = try fetchPerson(from: id)
        container.viewContext.delete(person)
        try container.viewContext.save()
    }
    
    func editPerson(id: UUID, name: String, email: String, birthday: Date, photo: UIImage) throws {
        let person = try fetchPerson(from: id)
        
        person.name = name
        person.email = email
        person.birthday = birthday
        person.dataPhoto = photo.pngData()
        
        try container.viewContext.save()
    }
}

// MARK: - Validations
extension CoreDataController {
    static func checkName(_ name: String) throws {
        if name.isEmpty {
            throw ValidationError.emptyNameField
        } else if name.count < 3 {
            throw ValidationError.nameLessThanThreeCharacters
        }
    }
    
    static func checkEmail(_ email: String) throws {
        if email.isEmpty {
            throw ValidationError.emptyEmailField
        } else if !email.contains("@") {
            throw ValidationError.mustContainAtSign
        } else if !email.contains(".") {
            throw ValidationError.mustContainDot
        } else {
            if let localPart = email.components(separatedBy: "@").first {
                if localPart.count < 3 {
                    throw ValidationError.emailLocalPartLessThanThreeCharacters
                }
            }
            else {
                throw ValidationError.mustContainAtSign
            }
        }
    }
    
    static func checkBirthday(_ birthday: Date) throws {
        do {
            let formattedToday = try Date().removeTimestamp()
            let formattedBirthday = try birthday.removeTimestamp()
            
            if formattedBirthday > formattedToday {
                throw ValidationError.birthdayExceededToday
            }
        } catch {
            throw ValidationError.invalidBirthday
        }
    }
    
    static func checkPhoto(_ photo: UIImage?) throws -> UIImage {
        guard let photo else { throw ValidationError.invalidPhoto }
        return photo
    }
    
    enum ValidationError: Swift.Error {
        case emptyNameField
        case nameLessThanThreeCharacters
        case emptyEmailField
        case mustContainAtSign
        case mustContainDot
        case emailLocalPartLessThanThreeCharacters
        case birthdayExceededToday
        case invalidBirthday
        case invalidPhoto
        case failToCreatePerson
        case unknown
        
        var description: String {
            switch self {
            case .emptyNameField:
                return "ValidationError_EmptyName".localized()
            case .nameLessThanThreeCharacters:
                return "ValidationError_NameLessThanThreeCharacters".localized()
            case .emptyEmailField:
                return "ValidationError_EmptyEmail".localized()
            case .mustContainAtSign:
                return "ValidationError_MustContainAtSign".localized()
            case .mustContainDot:
                return "ValidationError_MustContainDot".localized()
            case .emailLocalPartLessThanThreeCharacters:
                return "ValidationError_EmailLocalPartLessThanThreeCharacters".localized()
            case .birthdayExceededToday:
                return "ValidationError_BirthdayExceededToday".localized()
            case .invalidBirthday:
                return "ValidationError_InvalidBirthday".localized()
            case .invalidPhoto:
                return "ValidationError_InvalidPhoto".localized()
            case .failToCreatePerson:
                return "ValidationError_FailToCreatePerson".localized()
            case .unknown:
                return "ValidationError_Unknown".localized()
            }
        }
    }
}
