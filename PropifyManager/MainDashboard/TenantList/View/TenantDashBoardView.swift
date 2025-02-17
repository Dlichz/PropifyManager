//
//  TenantDashBoardView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct TenantDashboardView: View {
    @State private var tenants: [Tenant] = [
        Tenant(firstName: "Juan", lastName: "Pérez", email: "juan@example.com", phoneNumber: "1234567890", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(86400 * 10), paymentStatus: .current),
        Tenant(firstName: "Ana", lastName: "Gómez", email: "ana@example.com", phoneNumber: "0987654321", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(-86400 * 5), paymentStatus: .overdue),
        Tenant(firstName: "Luis", lastName: "Martínez", email: "luis@example.com", phoneNumber: "5555555555", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(86400 * 2), paymentStatus: .upcoming),
        Tenant(firstName: "María", lastName: "López", email: "maria@example.com", phoneNumber: "6666666666", contractStart: Date(), contractEnd: nil, nextPaymentDate: nil, paymentStatus: .inactive)
    ]
    
    @State private var searchText = ""
    @State private var filterByMonth = ""
    
    var filteredTenants: [Tenant] {
        var result = tenants
        
        // Filtrar por nombre
        if !searchText.isEmpty {
            result = result.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filtrar por mes (si se selecciona)
        if !filterByMonth.isEmpty {
            result = result.filter {
                guard let nextPaymentDate = $0.nextPaymentDate else { return false }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM"
                return dateFormatter.string(from: nextPaymentDate) == filterByMonth
            }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra de búsqueda
                SearchBar(text: $searchText, placeholder: "Buscar por nombre")
                
                // Filtro por mes
                Picker("Filtrar por mes", selection: $filterByMonth) {
                    Text("Todos").tag("")
                    ForEach(months, id: \.self) { month in
                        Text(month).tag(month)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                
                // Lista de inquilinos
                List(filteredTenants) { tenant in
                    NavigationLink(destination: TenantDetailView(tenant: tenant)) {
                        TenantRow(tenant: tenant)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Inquilinos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTenantView()) {
                        Image(systemName: "doc.text")
                    }
                }
                
            }
        }
    }
    
    // Lista de meses para el filtro
    var months: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols
    }
}

// Celda o "Row" que muestra información básica de cada inquilino
struct TenantRow: View {
    let tenant: Tenant
    
    var body: some View {
        HStack {
            // Ícono de estado
            Image(systemName: "circle.fill")
                .foregroundColor(tenant.paymentStatus.color)
                .font(.system(size: 10))
            
            VStack(alignment: .leading) {
                Text(tenant.fullName)
                    .font(.headline)
                if let nextPaymentDate = tenant.nextPaymentDate {
                    Text("Próximo pago: \(nextPaymentDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("Inactivo")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// Barra de búsqueda
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
    }
}

// Previsualización
struct TenantDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        TenantDashboardView()
    }
}
