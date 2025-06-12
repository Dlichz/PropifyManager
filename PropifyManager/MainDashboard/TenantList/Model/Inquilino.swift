//
//  Tenant.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

enum InmuebleType: String, Hashable, Codable {
    case Departamento
    case Oficina
    case Casa
    case LocalComercial = "Local Comercial"
}

struct Inmueble: Hashable, Identifiable, Codable {
    let id: UUID
    let type: InmuebleType
    let name: String
    let direccion: Direccion
    let metrosCuadrados: Double
    var rentaMensual: Double
    var ocupado: Bool
    var inquilino: Inquilino?
    let notas: String?
    
    var defaultName: String {
        return "\(direccion.apodo ?? type.rawValue) \(direccion.calle)"
    }
}

struct Direccion: Hashable, Identifiable, Codable {
    let id: UUID
    let calle: String
    let numeroExterior: String
    let numeroInterior: String
    let colonia: String
    let municipio: String
    let estado: String
    let pais: String
    let codigoPostal: String
    let apodo: String?
}

struct Inquilino: Hashable, Identifiable, Codable {
    var id = UUID()
    
    // Información personal
    var firstName: String
    var lastName: String
    var email: String? = ""
    var phoneNumber: String?
    var imageID: [String?]? = nil

    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

struct Contrato:Hashable, Identifiable, Codable {
    var id: UUID = UUID()
    let departamentoID: UUID
    var inquilinoID: UUID
    var fechaInicio: Date
    var fechaFin: Date
    var rentaMensual: Double
}

struct Pago: Hashable, Identifiable, Codable {
    var id: UUID
    var contratoID: UUID
    var fechaPago: Date
    var monto: Double
    var notas: String
}

enum PaymentStatus: String, Hashable, Codable {
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
