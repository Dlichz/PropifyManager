//
//  Pago.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct Pago: Hashable, Identifiable, Codable {
    var id: UUID
    var contratoID: UUID
    var fechaPago: Date
    var monto: Double
    var notas: String?
    var estado: EstadoPago
    
    init(id: UUID = UUID(), contratoID: UUID, fechaPago: Date, monto: Double, notas: String? = nil, estado: EstadoPago = .current) {
        self.id = id
        self.contratoID = contratoID
        self.fechaPago = fechaPago
        self.monto = monto
        self.notas = notas
        self.estado = estado
    }
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
