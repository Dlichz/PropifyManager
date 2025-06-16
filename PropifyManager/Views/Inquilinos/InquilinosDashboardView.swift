import SwiftUI

struct InquilinosDashboardView: View {
    @State private var searchText = ""
    @State private var selectedFilter: InquilinoFilter = .todos
    @State private var showingAddSheet = false
    
    enum InquilinoFilter: String, CaseIterable {
        case todos = "Todos"
        case activos = "Activos"
        case inactivos = "Inactivos"
        case alCorriente = "Al Corriente"
        case atrasados = "Atrasados"
        case proximos = "Próximos"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Resumen de estadísticas
                    estadisticasView
                    
                    // Filtros
                    filtrosView
                    
                    // Lista de inquilinos
                    listaInquilinosView
                }
                .padding(.vertical)
            }
            .navigationTitle("Inquilinos")
            .searchable(text: $searchText, prompt: "Buscar inquilino")
            .sheet(isPresented: $showingAddSheet) {
                EditarInquilinoView(inquilino: nil)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private var estadisticasView: some View {
        HStack(spacing: 15) {
            StatTenantCard(
                title: "Total",
                value: "12",
                icon: "person.3.fill",
                color: .blue
            )
            StatTenantCard(
                title: "Al Corriente",
                value: "8",
                icon: "checkmark.circle.fill",
                color: .green
            )
            StatTenantCard(
                title: "Atrasados",
                value: "2",
                icon: "exclamationmark.circle.fill",
                color: .red
            )
        }
        .padding(.horizontal)
    }
    
    private var filtrosView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(InquilinoFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var listaInquilinosView: some View {
        LazyVStack(spacing: 15) {
            ForEach(0..<5) { _ in
                NavigationLink(destination: InquilinoDetailView(inquilino: Inquilino(
                    firstName: "Juan",
                    lastName: "Pérez",
                    email: "juan@example.com",
                    phoneNumber: "555-0123"
                ))) {
                    InquilinoCard()
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
    }
}

struct StatTenantCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct InquilinoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Avatar
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Juan Pérez")
                        .font(.headline)
                    Text("Departamento 101")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Estado de pago
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Al Corriente")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    
                    Text("$15,000")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            Divider()
            
            HStack {
                InfoItem(icon: "calendar", title: "Próximo pago", value: "15 Jun")
                Spacer()
                InfoItem(icon: "house.fill", title: "Inicio", value: "1 Ene 2024")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct InfoItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    InquilinosDashboardView()
} 
