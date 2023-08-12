//
//  DataController.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import CoreData
import Foundation

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
    
    func createPerson(name: String, email: String, birthday: Date) throws {
        let person = Person(context: container.viewContext)
        
        person.id = UUID()
        person.name = name
        person.email = email
        person.birthday = birthday
        
        try container.viewContext.save()
    }
    
    func deletePerson(from id: UUID) throws {
        let person = try fetchPerson(from: id)
        container.viewContext.delete(person)
        try container.viewContext.save()
    }
    
    func editPerson(id: UUID, name: String, email: String, birthday: Date) throws {
        let person = try fetchPerson(from: id)
        person.name = name
        person.email = email
        person.birthday = birthday
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
    
    enum ValidationError: Swift.Error {
        case emptyNameField
        case nameLessThanThreeCharacters
        case emptyEmailField
        case mustContainAtSign
        case mustContainDot
        case emailLocalPartLessThanThreeCharacters
        case birthdayExceededToday
        case invalidBirthday
        case failToCreatePerson
        case unknown
        
        var description: String {
            switch self {
            case .emptyNameField:
                return "Campo de nome vazio"
            case .nameLessThanThreeCharacters:
                return "O nome precisa ser maior que 3 caracteres"
            case .emptyEmailField:
                return "Campo de email vazio"
            case .mustContainAtSign:
                return "O email deve conter \"@\""
            case .mustContainDot:
                return "O email deve conter \".\""
            case .emailLocalPartLessThanThreeCharacters:
                return "A parte local do email precisa ser maior que 3 caracteres"
            case .birthdayExceededToday:
                return "A data de aniversário não pode exceder o dia de hoje"
            case .invalidBirthday:
                return "Data de aniversário inválida"
            case .failToCreatePerson:
                return "Falha ao cadastrar pessoa"
            case .unknown:
                return "Ocorreu um erro desconhecido"
            }
        }
    }
}
