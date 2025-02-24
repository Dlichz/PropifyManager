//
//  Tenant.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct Tenant: Identifiable, Codable {
    var id = UUID()
    
    // Información personal
    var firstName: String
    var lastName: String
    var email: String? = ""
    var phoneNumber: String?
    var imageID: String?
    
    // Detalles del contrato
    var contractStart: Date
    var contractEnd: Date?
    var lastPaymentDate: Date?
    var nextPaymentDate: Date?
    var paymentStatus: PaymentStatus
    var rentAmount: String?
    var notes: String?
    
    // Detalles del inmueble
    var departamento: Inmueble?

    // Propiedad calculada para obtener el nombre completo
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // Propiedad calculada para determinar si el contrato está activo
    var isActive: Bool {
        if let contractEnd = contractEnd {
            return Date() <= contractEnd
        }
        return true // Si no se establece fecha de finalización, se asume activo
    }
}

struct Inmueble: Identifiable, Codable {
    let id: UUID
    let name: String
    let direccion: String
    let description: String
}


struct Payment: Identifiable, Codable {
    let id: String
    let date: Date
    let amount: Double
}

enum PaymentStatus: String, Codable {
    case current    // Al corriente (verde)
    case upcoming   // Próximo (amarillo)
    case overdue    // Atrasado (rojo)
    case inactive   // Inactivo (gris)
    
    var color: Color {
        switch self {
        case .current:
            return .green
        case .upcoming:
            return .yellow
        case .overdue:
            return .red
        case .inactive:
            return .gray
        }
    }
}

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
