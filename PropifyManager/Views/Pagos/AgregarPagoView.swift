//
//  AgregarPagoView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct AgregarPagoView: View {
    @ObservedObject var viewModel: PagosDashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var contratoSeleccionado: UUID?
    @State private var monto: String = ""
    @State private var fecha: Date = Date()
    @State private var notas: String = ""
    @State private var estado: EstadoPago = .current
    @State private var comprobante: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Información del Pago") {
                    Picker("Contrato", selection: $contratoSeleccionado) {
                        Text("Seleccionar contrato").tag(nil as UUID?)
                        ForEach(viewModel.contratos, id: \.id) { contrato in
                            if let inquilino = viewModel.inquilinos.first(where: { $0.id == contrato.inquilinoID }),
                               let inmueble = viewModel.inmuebles.first(where: { $0.id == contrato.departamentoID }) {
                                Text("\(inquilino.firstName) \(inquilino.lastName) - \(inmueble.defaultName)")
                                    .tag(contrato.id as UUID?)
                            }
                        }
                    }
                    
                    TextField("Monto", text: $monto)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Fecha de Pago", selection: $fecha, displayedComponents: .date)
                    
                    Picker("Estado", selection: $estado) {
                        ForEach(EstadoPago.allCases, id: \.self) { estado in
                            Text(estado.rawValue).tag(estado)
                        }
                    }
                }
                
                Section("Notas") {
                    TextField("Notas adicionales", text: $notas, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Comprobante") {
                    TextField("URL del comprobante", text: $comprobante)
                        .keyboardType(.URL)
                }
            }
            .navigationTitle("Agregar Pago")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        guardarPago()
                    }
                    .disabled(contratoSeleccionado == nil || monto.isEmpty)
                }
            }
        }
    }
    
    private func guardarPago() {
        guard let contratoID = contratoSeleccionado,
              let montoDouble = Double(monto) else { return }
        
        viewModel.agregarPago(
            contratoID: contratoID,
            monto: montoDouble,
            fecha: fecha,
            notas: notas.isEmpty ? nil : notas,
            comprobante: comprobante.isEmpty ? nil : comprobante
        )
        
        dismiss()
    }
}

#Preview {
    AgregarPagoView(viewModel: PagosDashboardViewModel())
} 