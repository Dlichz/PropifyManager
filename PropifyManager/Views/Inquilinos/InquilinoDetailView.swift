import SwiftUI

struct InquilinoDetailView: View {
    let inquilino: Inquilino
    @StateObject private var viewModel = InquilinoDetailViewModel()
    @State private var selectedTab = 0
    @State private var showingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text(inquilino.fullName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let email = inquilino.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Segmented Picker
                Picker("Sección", selection: $selectedTab) {
                    Text("Actual").tag(0)
                    Text("Historial").tag(1)
                    Text("Pagos").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Contenido según la pestaña seleccionada
                switch selectedTab {
                case 0:
                    if let contratoId = inquilino.contratoActualId,
                       let contrato = viewModel.contratoActual {
                        ContratoActualView(contrato: contrato)
                    } else {
                        Text("No hay contrato activo")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                case 1:
                    if !viewModel.historial.isEmpty {
                        HistorialContratosView(historial: viewModel.historial)
                    } else {
                        Text("No hay historial de contratos")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                case 2:
                    if let resumenId = inquilino.resumenId,
                       let resumen = viewModel.resumen {
                        HistorialPagosView2(pagos: resumen.pagos)
                    } else {
                        Text("No hay pagos registrados")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingEditSheet = true }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditarInquilinoView(inquilino: inquilino)
        }
        .onAppear {
            viewModel.loadData(for: inquilino)
        }
    }
}

class InquilinoDetailViewModel: ObservableObject {
    @Published var contratoActual: HistorialInquilino?
    @Published var historial: [HistorialInquilino] = []
    @Published var resumen: ResumenInquilino?
    
    func loadData(for inquilino: Inquilino) {
        // TODO: Implementar la carga de datos desde el servicio
        // Por ahora, usamos datos de ejemplo
        if let contratoId = inquilino.contratoActualId {
            // Cargar contrato actual
        }
        
        if !inquilino.historialIds.isEmpty {
            // Cargar historial
        }
        
        if let resumenId = inquilino.resumenId {
            // Cargar resumen
        }
    }
}

struct ContratoActualView: View {
    let contrato: HistorialInquilino
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Información del inmueble
            VStack(alignment: .leading, spacing: 8) {
                Text("Inmueble Actual")
                    .font(.headline)
                
                // TODO: Cargar información del inmueble usando contrato.inmuebleId
                Text("Cargando información del inmueble...")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            // Información del contrato
            VStack(alignment: .leading, spacing: 8) {
                Text("Detalles del Contrato")
                    .font(.headline)
                
                DetailRow(title: "Fecha de Inicio", value: contrato.fechaInicio.formatted(date: .long, time: .omitted))
                if let fechaFin = contrato.fechaFin {
                    DetailRow(title: "Fecha de Término", value: fechaFin.formatted(date: .long, time: .omitted))
                }
                DetailRow(title: "Duración", value: contrato.duracionFormateada)
                DetailRow(title: "Renta Mensual", value: "$\(String(format: "%.2f", contrato.rentaMensual))")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            if let notas = contrato.notas {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notas")
                        .font(.headline)
                    Text(notas)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
        }
        .padding()
    }
}

struct HistorialContratosView: View {
    let historial: [HistorialInquilino]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Historial de Contratos")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(historial) { contrato in
                VStack(alignment: .leading, spacing: 8) {
                    // TODO: Cargar información del inmueble usando contrato.inmuebleId
                    Text("Cargando información del inmueble...")
                        .font(.headline)
                    
                    DetailRow2(title: "Período", value: "\(contrato.fechaInicio.formatted(date: .abbreviated, time: .omitted)) - \(contrato.fechaFin?.formatted(date: .abbreviated, time: .omitted) ?? "Presente")")
                    DetailRow2(title: "Duración", value: contrato.duracionFormateada)
                    DetailRow2(title: "Renta Mensual", value: "$\(String(format: "%.2f", contrato.rentaMensual))")
                    
                    if let motivo = contrato.motivoSalida {
                        DetailRow2(title: "Motivo de Salida", value: motivo)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
            }
        }
    }
}

struct HistorialPagosView2: View {
    let pagos: [Pago]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Historial de Pagos")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(pagos) { pago in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(pago.fechaPago.formatted(date: .abbreviated, time: .omitted))
                            .font(.headline)
                        Spacer()
                        Text("$\(String(format: "%.2f", pago.monto))")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Image(systemName: pago.estado.icon)
                            .foregroundColor(pago.estado.color)
                        Text(pago.estado.rawValue)
                            .foregroundColor(pago.estado.color)
                    }
                    
                    if let notas = pago.notas {
                        Text(notas)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
            }
        }
    }
}

struct DetailRow2: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    InquilinoDetailView(inquilino: Inquilino(
        firstName: "Juan",
        lastName: "Pérez",
        email: "juan@example.com",
        phoneNumber: "555-0123"
    ))
} 
