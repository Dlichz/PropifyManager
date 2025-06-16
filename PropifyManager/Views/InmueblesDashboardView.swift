import SwiftUI

struct InmueblesDashboardView: View {
    @StateObject private var viewModel = InmueblesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Statistics Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(title: "Total", value: "\(viewModel.totalInmuebles)", color: .blue)
                        StatCard(title: "Disponibles", value: "\(viewModel.inmueblesDisponibles)", color: .green)
                        StatCard(title: "Ocupados", value: "\(viewModel.inmueblesOcupados)", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Properties List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Inmuebles")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.inmuebles) { inmueble in
                            NavigationLink(destination: InmuebleDetailView(inmueble: inmueble)) {
                                InmuebleRowView(inmueble: inmueble)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.loadInmuebles()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct InmuebleRowView: View {
    let inmueble: Inmueble
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(inmueble.defaultName)
                    .font(.headline)
                Text(inmueble.direccion.colonia)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(inmueble.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Circle()
                        .fill(inmueble.ocupado ? Color.orange : Color.green)
                        .frame(width: 8, height: 8)
                    Text(inmueble.ocupado ? "Ocupado" : "Disponible")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

struct InmuebleDetailView: View {
    let inmueble: Inmueble
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(inmueble.defaultName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(inmueble.type.rawValue)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Details
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(title: "Dirección", value: "\(inmueble.direccion.calle) \(inmueble.direccion.numeroExterior)")
                    DetailRow(title: "Colonia", value: inmueble.direccion.colonia)
                    DetailRow(title: "Municipio", value: inmueble.direccion.municipio)
                    DetailRow(title: "Estado", value: inmueble.direccion.estado)
                    DetailRow(title: "Metros Cuadrados", value: "\(inmueble.metrosCuadrados) m²")
                    DetailRow(title: "Renta Mensual", value: "$\(inmueble.rentaMensual, specifier: "%.2f")")
                    DetailRow(title: "Estado", value: inmueble.ocupado ? "Ocupado" : "Disponible")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                if let notas = inmueble.notas {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notas")
                            .font(.headline)
                        Text(notas)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
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
    InmueblesDashboardView()
} 