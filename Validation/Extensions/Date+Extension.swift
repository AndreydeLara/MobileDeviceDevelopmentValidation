//
//  Date+Extension.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import Foundation

extension Date {
    public func removeTimestamp() throws -> Date {
        let calendar = Calendar.current
        
        guard let date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self)) else {
            throw RemoveTimestampError.failToRemoveTimestamp
        }
        
        return date
    }
    
    private enum RemoveTimestampError: Swift.Error {
        case failToRemoveTimestamp
    }
}
