//
//  Contrato.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct Contrato:Hashable, Identifiable, Codable {
    var id: UUID = UUID()
    let departamentoID: UUID
    var inquilinoID: UUID
    var fechaInicio: Date
    var fechaFin: Date
    var rentaMensual: Double
    
    init(id: UUID = UUID(), departamentoID: UUID, inquilinoID: UUID, fechaInicio: Date, fechaFin: Date, rentaMensual: Double) {
        self.id = id
        self.departamentoID = departamentoID
        self.inquilinoID = inquilinoID
        self.fechaInicio = fechaInicio
        self.fechaFin = fechaFin
        self.rentaMensual = rentaMensual
    }
}
