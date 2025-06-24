//
//  ReporteView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct ReporteView: View {
    @ObservedObject var viewModel: PagosDashboardViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var reporteTexto: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Header con información del reporte
                VStack(spacing: 12) {
                    Text("Reporte Mensual")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Enero 2025")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("$\(String(format: "%.2f", viewModel.resumenFinanciero.ingresosTotales))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("Ingresos")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("$\(String(format: "%.2f", viewModel.resumenFinanciero.egresosTotales))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            Text("Egresos")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("$\(String(format: "%.2f", viewModel.resumenFinanciero.balance))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.resumenFinanciero.balance >= 0 ? .blue : .orange)
                            Text("Balance")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Contenido del reporte
                ScrollView {
                    Text(reporteTexto)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(.systemBackground))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Compartir") {
                        compartirReporte()
                    }
                }
            }
        }
        .onAppear {
            reporteTexto = viewModel.generarReporteMensual()
        }
    }
    
    private func compartirReporte() {
        let activityVC = UIActivityViewController(
            activityItems: [reporteTexto],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

#Preview {
    ReporteView(viewModel: PagosDashboardViewModel())
} 