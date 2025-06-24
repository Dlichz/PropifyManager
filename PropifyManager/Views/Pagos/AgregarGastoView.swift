//
//  AgregarGastoView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct AgregarGastoView: View {
    @ObservedObject var viewModel: PagosDashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var inmuebleSeleccionado: UUID?
    @State private var tipo: TipoGasto = .mantenimiento
    @State private var monto: String = ""
    @State private var fecha: Date = Date()
    @State private var descripcion: String = ""
    @State private var comprobante: String = ""
    @State private var notas: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Información del Gasto") {
                    Picker("Inmueble (Opcional)", selection: $inmuebleSeleccionado) {
                        Text("Gasto general").tag(nil as UUID?)
                        ForEach(viewModel.inmuebles, id: \.id) { inmueble in
                            Text(inmueble.defaultName).tag(inmueble.id as UUID?)
                        }
                    }
                    
                    Picker("Tipo de Gasto", selection: $tipo) {
                        ForEach(TipoGasto.allCases, id: \.self) { tipo in
                            HStack {
                                Image(systemName: tipo.icon)
                                    .foregroundColor(tipo.color)
                                Text(tipo.rawValue)
                            }
                            .tag(tipo)
                        }
                    }
                    
                    TextField("Monto", text: $monto)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                }
                
                Section("Descripción") {
                    TextField("Descripción del gasto", text: $descripcion, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section("Comprobante") {
                    TextField("URL del comprobante", text: $comprobante)
                        .keyboardType(.URL)
                }
                
                Section("Notas") {
                    TextField("Notas adicionales", text: $notas, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Agregar Gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        guardarGasto()
                    }
                    .disabled(monto.isEmpty || descripcion.isEmpty)
                }
            }
        }
    }
    
    private func guardarGasto() {
        guard let montoDouble = Double(monto) else { return }
        
        viewModel.agregarGasto(
            inmuebleID: inmuebleSeleccionado,
            tipo: tipo,
            monto: montoDouble,
            fecha: fecha,
            descripcion: descripcion,
            comprobante: comprobante.isEmpty ? nil : comprobante,
            notas: notas.isEmpty ? nil : notas
        )
        
        dismiss()
    }
}

#Preview {
    AgregarGastoView(viewModel: PagosDashboardViewModel())
} 