//
//  PagosDashboardView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI
import Charts

struct PagosDashboardView: View {
    @StateObject private var viewModel = PagosDashboardViewModel()
    @State private var selectedTab = 0
    @State private var showingAddPago = false
    @State private var showingAddGasto = false
    @State private var showingReporte = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header con acciones
                HStack {
                    Text("Dashboard de Pagos")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Menu {
                        Button(action: { showingAddPago = true }) {
                            Label("Agregar Pago", systemImage: "plus.circle")
                        }
                        
                        Button(action: { showingAddGasto = true }) {
                            Label("Agregar Gasto", systemImage: "minus.circle")
                        }
                        
                        Divider()
                        
                        Button(action: { showingReporte = true }) {
                            Label("Descargar Reporte", systemImage: "square.and.arrow.down")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Picker para las pestañas
                Picker("Sección", selection: $selectedTab) {
                    Text("Resumen").tag(0)
                    Text("Historial").tag(1)
                    Text("Estadísticas").tag(2)
                    Text("Alertas").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Contenido de las pestañas
                TabView(selection: $selectedTab) {
                    ResumenFinancieroView(viewModel: viewModel)
                        .tag(0)
                    
                    HistorialPagosView(viewModel: viewModel)
                        .tag(1)
                    
                    EstadisticasView(viewModel: viewModel)
                        .tag(2)
                    
                    AlertasView(viewModel: viewModel)
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddPago) {
            AgregarPagoView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddGasto) {
            AgregarGastoView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingReporte) {
            ReporteView(viewModel: viewModel)
        }
    }
}

// MARK: - Vista de Resumen Financiero
struct ResumenFinancieroView: View {
    @ObservedObject var viewModel: PagosDashboardViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Tarjetas de resumen
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatPaymentCard(
                        title: "Ingresos",
                        value: "$\(String(format: "%.2f", viewModel.resumenFinanciero.ingresosTotales))",
                        icon: "arrow.up.circle.fill",
                        color: .green
                    )
                    
                    StatPaymentCard(
                        title: "Egresos",
                        value: "$\(String(format: "%.2f", viewModel.resumenFinanciero.egresosTotales))",
                        icon: "arrow.down.circle.fill",
                        color: .red
                    )
                    
                    StatPaymentCard(
                        title: "Balance",
                        value: "$\(String(format: "%.2f", viewModel.resumenFinanciero.balance))",
                        icon: "chart.line.uptrend.xyaxis",
                        color: viewModel.resumenFinanciero.balance >= 0 ? .blue : .orange
                    )
                    
                    StatPaymentCard(
                        title: "Cumplimiento",
                        value: "\(String(format: "%.1f", viewModel.resumenFinanciero.porcentajeCumplimiento))%",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                }
                .padding(.horizontal)
                
                // Alertas rápidas
                if !viewModel.alertas.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Alertas")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.alertas.prefix(3)) { alerta in
                                    AlertaCard(alerta: alerta)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Últimos gastos
                VStack(alignment: .leading, spacing: 12) {
                    Text("Últimos Gastos")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.gastos.prefix(5)) { gasto in
                        GastoRow(gasto: gasto)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Vista de Historial de Pagos
struct HistorialPagosView: View {
    @ObservedObject var viewModel: PagosDashboardViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Filtros
            VStack(spacing: 12) {
                HStack {
                    Text("Filtros")
                        .font(.headline)
                    Spacer()
                }
                
                // Filtro por fecha
                Picker("Período", selection: $viewModel.filtroFecha) {
                    ForEach(PagosDashboardViewModel.DateFilter.allCases, id: \.self) { filtro in
                        Text(filtro.rawValue).tag(filtro)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Filtros adicionales
                HStack {
                    TextField("Buscar inquilino...", text: $viewModel.filtroInquilino)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("Estado", selection: $viewModel.filtroEstado) {
                        Text("Todos").tag(nil as EstadoPago?)
                        ForEach(EstadoPago.allCases, id: \.self) { estado in
                            Text(estado.rawValue).tag(estado as EstadoPago?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Filtro personalizado
                if viewModel.filtroFecha == .personalizado {
                    HStack {
                        DatePicker("Desde", selection: $viewModel.fechaInicio, displayedComponents: .date)
                        DatePicker("Hasta", selection: $viewModel.fechaFin, displayedComponents: .date)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Lista de pagos
            List {
                ForEach(viewModel.pagosFiltrados) { pago in
                    PagoRow(pago: pago)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

// MARK: - Vista de Estadísticas
struct EstadisticasView: View {
    @ObservedObject var viewModel: PagosDashboardViewModel
    @State private var selectedPeriod = "Mensual"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Selector de período
                Picker("Período", selection: $selectedPeriod) {
                    Text("Mensual").tag("Mensual")
                    Text("Anual").tag("Anual")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Gráfica de ingresos vs egresos
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingresos vs Egresos")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Chart {
                        ForEach(viewModel.estadisticasMensuales) { estadistica in
                            LineMark(
                                x: .value("Mes", estadistica.mes),
                                y: .value("Ingresos", estadistica.ingresos)
                            )
                            .foregroundStyle(.green)
                            .symbol(.circle)
                            
                            LineMark(
                                x: .value("Mes", estadistica.mes),
                                y: .value("Egresos", estadistica.egresos)
                            )
                            .foregroundStyle(.red)
                            .symbol(.square)
                        }
                    }
                    .frame(height: 200)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
                
                // Estadísticas por inmueble
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingresos por Inmueble")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.estadisticasPorInmueble) { estadistica in
                        InmuebleStatRow(estadistica: estadistica)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Vista de Alertas
struct AlertasView: View {
    @ObservedObject var viewModel: PagosDashboardViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.alertas) { alerta in
                AlertaRow(alerta: alerta)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Alertas")
    }
}

// MARK: - Componentes de UI

struct StatPaymentCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct AlertaCard: View {
    let alerta: AlertaPago
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: alerta.tipo.icon)
                    .foregroundColor(alerta.tipo.color)
                Text(alerta.tipo.rawValue)
                    .font(.caption)
                    .foregroundColor(alerta.tipo.color)
                Spacer()
            }
            
            Text(alerta.nombreInquilino)
                .font(.headline)
            
            Text(alerta.nombreInmueble)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("$\(String(format: "%.2f", alerta.monto))")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("\(alerta.diasRestantes) días")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 200)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct GastoRow: View {
    let gasto: Gasto
    @State private var showingComprobante = false
    
    var body: some View {
        HStack {
            Image(systemName: gasto.tipo.icon)
                .foregroundColor(gasto.tipo.color)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(gasto.descripcion)
                    .font(.body)
                Text(gasto.tipo.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(String(format: "%.2f", gasto.monto))")
                    .font(.body)
                    .fontWeight(.medium)
                Text(gasto.fecha, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if gasto.comprobante != nil {
                    Button(action: {
                        showingComprobante = true
                    }) {
                        Image(systemName: "doc.text")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .sheet(isPresented: $showingComprobante) {
            if let comprobante = gasto.comprobante {
                ComprobanteView(url: comprobante, titulo: "Comprobante de Gasto")
            }
        }
    }
}

struct PagoRow: View {
    let pago: Pago
    @State private var showingComprobante = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("$\(String(format: "%.2f", pago.monto))")
                    .font(.headline)
                Text(pago.fechaPago, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack {
                Image(systemName: pago.estado.icon)
                    .foregroundColor(pago.estado.color)
                Text(pago.estado.rawValue)
                    .font(.caption)
                    .foregroundColor(pago.estado.color)
                
                if pago.comprobante != nil {
                    Button(action: {
                        showingComprobante = true
                    }) {
                        Image(systemName: "doc.text")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingComprobante) {
            if let comprobante = pago.comprobante {
                ComprobanteView(url: comprobante, titulo: "Comprobante de Pago")
            }
        }
    }
}

struct InmuebleStatRow: View {
    let estadistica: EstadisticaPorInmueble
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(estadistica.nombreInmueble)
                    .font(.body)
                Text("Ocupación: \(String(format: "%.0f", estadistica.porcentajeOcupacion))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(String(format: "%.2f", estadistica.ingresos))")
                    .font(.body)
                    .fontWeight(.medium)
                Text("Balance: $\(String(format: "%.2f", estadistica.balance))")
                    .font(.caption)
                    .foregroundColor(estadistica.balance >= 0 ? .green : .red)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct AlertaRow: View {
    let alerta: AlertaPago
    
    var body: some View {
        HStack {
            Image(systemName: alerta.tipo.icon)
                .foregroundColor(alerta.tipo.color)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(alerta.nombreInquilino)
                    .font(.body)
                Text(alerta.nombreInmueble)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(String(format: "%.2f", alerta.monto))")
                    .font(.body)
                    .fontWeight(.medium)
                Text("\(alerta.diasRestantes) días")
                    .font(.caption)
                    .foregroundColor(alerta.tipo.color)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PagosDashboardView()
} 
