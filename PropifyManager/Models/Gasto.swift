//
//  Gasto.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct Gasto: Hashable, Identifiable, Codable {
    var id: UUID
    var inmuebleID: UUID?
    var tipo: TipoGasto
    var monto: Double
    var fecha: Date
    var descripcion: String
    var comprobante: String?
    var notas: String?
    
    init(id: UUID = UUID(), inmuebleID: UUID? = nil, tipo: TipoGasto, monto: Double, fecha: Date, descripcion: String, comprobante: String? = nil, notas: String? = nil) {
        self.id = id
        self.inmuebleID = inmuebleID
        self.tipo = tipo
        self.monto = monto
        self.fecha = fecha
        self.descripcion = descripcion
        self.comprobante = comprobante
        self.notas = notas
    }
}

enum TipoGasto: String, CaseIterable, Codable {
    case mantenimiento = "Mantenimiento"
    case electricidad = "Electricidad"
    case agua = "Agua"
    case internet = "Internet"
    case gas = "Gas"
    case reparaciones = "Reparaciones"
    case limpieza = "Limpieza"
    case seguros = "Seguros"
    case impuestos = "Impuestos"
    case otros = "Otros"
    
    var icon: String {
        switch self {
        case .mantenimiento:
            return "wrench.and.screwdriver.fill"
        case .electricidad:
            return "bolt.fill"
        case .agua:
            return "drop.fill"
        case .internet:
            return "wifi"
        case .gas:
            return "flame.fill"
        case .reparaciones:
            return "hammer.fill"
        case .limpieza:
            return "sparkles"
        case .seguros:
            return "shield.fill"
        case .impuestos:
            return "doc.text.fill"
        case .otros:
            return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .mantenimiento:
            return .orange
        case .electricidad:
            return .yellow
        case .agua:
            return .blue
        case .internet:
            return .purple
        case .gas:
            return .red
        case .reparaciones:
            return .brown
        case .limpieza:
            return .green
        case .seguros:
            return .indigo
        case .impuestos:
            return .gray
        case .otros:
            return .secondary
        }
    }
} 