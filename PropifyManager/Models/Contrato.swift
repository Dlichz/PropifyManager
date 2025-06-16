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
}
