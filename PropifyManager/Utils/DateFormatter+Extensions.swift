//
//  DateFormatter+Extensions.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

extension Date {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var stringValue: String {
        return Date.dateFormatter.string(from: self)
    }
    
    init?(from string: String) {
        guard let date = Date.dateFormatter.date(from: string) else { return nil }
        self = date
    }
}
