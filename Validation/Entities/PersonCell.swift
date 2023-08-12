//
//  PersonCell.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import SwiftUI
import Foundation

struct PersonCell: Identifiable {
    var id: UUID
    var name: String
    var email: String
    var birthday: Date
    var photo: UIImage
}
