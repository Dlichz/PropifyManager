//
//  ResumenFinanciero.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct ResumenFinanciero: Codable {
    var ingresosTotales: Double
    var egresosTotales: Double
    var balance: Double
    var pagosPendientes: Double
    var pagosVencidos: Double
    var periodo: String // "Enero 2025", "2025", etc.
    
    init(ingresosTotales: Double, egresosTotales: Double, balance: Double, pagosPendientes: Double, pagosVencidos: Double, periodo: String) {
        self.ingresosTotales = ingresosTotales
        self.egresosTotales = egresosTotales
        self.balance = balance
        self.pagosPendientes = pagosPendientes
        self.pagosVencidos = pagosVencidos
        self.periodo = periodo
    }
    
    var porcentajeCumplimiento: Double {
        guard ingresosTotales > 0 else { return 0 }
        return ((ingresosTotales - pagosPendientes - pagosVencidos) / ingresosTotales) * 100
    }
}

struct EstadisticaMensual: Codable, Identifiable {
    var id = UUID()
    var mes: String
    var año: Int
    var ingresos: Double
    var egresos: Double
    var balance: Double
    
    init(mes: String, año: Int, ingresos: Double, egresos: Double, balance: Double) {
        self.mes = mes
        self.año = año
        self.ingresos = ingresos
        self.egresos = egresos
        self.balance = balance
    }
    
    var fecha: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.date(from: "\(mes) \(año)") ?? Date()
    }
}

struct EstadisticaPorInmueble: Codable, Identifiable {
    var id = UUID()
    var inmuebleID: UUID
    var nombreInmueble: String
    var ingresos: Double
    var egresos: Double
    var balance: Double
    var porcentajeOcupacion: Double
    
    init(inmuebleID: UUID, nombreInmueble: String, ingresos: Double, egresos: Double, balance: Double, porcentajeOcupacion: Double) {
        self.inmuebleID = inmuebleID
        self.nombreInmueble = nombreInmueble
        self.ingresos = ingresos
        self.egresos = egresos
        self.balance = balance
        self.porcentajeOcupacion = porcentajeOcupacion
    }
}

struct AlertaPago: Codable, Identifiable {
    var id = UUID()
    var contratoID: UUID
    var inquilinoID: UUID
    var nombreInquilino: String
    var inmuebleID: UUID
    var nombreInmueble: String
    var monto: Double
    var fechaVencimiento: Date
    var diasRestantes: Int
    var tipo: TipoAlerta
    
    init(contratoID: UUID, inquilinoID: UUID, nombreInquilino: String, inmuebleID: UUID, nombreInmueble: String, monto: Double, fechaVencimiento: Date, diasRestantes: Int, tipo: TipoAlerta) {
        self.contratoID = contratoID
        self.inquilinoID = inquilinoID
        self.nombreInquilino = nombreInquilino
        self.inmuebleID = inmuebleID
        self.nombreInmueble = nombreInmueble
        self.monto = monto
        self.fechaVencimiento = fechaVencimiento
        self.diasRestantes = diasRestantes
        self.tipo = tipo
    }
    
    enum TipoAlerta: String, Codable, CaseIterable {
        case proximo = "Próximo"
        case vencido = "Vencido"
        case urgente = "Urgente"
        
        var color: Color {
            switch self {
            case .proximo:
                return .yellow
            case .vencido:
                return .red
            case .urgente:
                return .orange
            }
        }
        
        var icon: String {
            switch self {
            case .proximo:
                return "clock.fill"
            case .vencido:
                return "exclamationmark.triangle.fill"
            case .urgente:
                return "exclamationmark.circle.fill"
            }
        }
    }
} 