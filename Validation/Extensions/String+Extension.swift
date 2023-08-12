//
//  String+Extension.swift
//  Validation
//
//  Created by PremierSoft on 11/08/23.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, bundle: .main, comment: "No comment")
    }
    
    func localized(for bundle: Bundle, arguments: [CVarArg]) -> String {
        let localizedString = NSLocalizedString(self, bundle: bundle, comment: "No comment")
        let stringInterpolated = String(format: localizedString, arguments: arguments)
        return stringInterpolated
    }
}
