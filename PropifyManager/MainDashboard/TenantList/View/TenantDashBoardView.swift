//
//  TenantDashBoardView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct TenantDashboardView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var searchText = ""
    @State private var filterByMonth = ""

    var filteredTenants: [Tenant] {
        var tenants = viewModel.tenants
        
        if !searchText.isEmpty {
            tenants = tenants.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
        
        if !filterByMonth.isEmpty {
            tenants = tenants.filter {
                guard let nextPaymentDate = $0.nextPaymentDate else { return false }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM"
                return dateFormatter.string(from: nextPaymentDate) == filterByMonth
            }
        }
        
        return tenants
    }

    var body: some View {
        NavigationView {
            VStack {
                // Barra de búsqueda
                SearchBar(text: $searchText, placeholder: "Buscar por nombre")
                
                // Filtro por mes
                Picker("Filtrar por mes", selection: $filterByMonth) {
                    Text("Todos").tag("")
                    ForEach(viewModel.months, id: \.self) { month in
                        Text(month).tag(month)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                
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
                        Image(systemName: "person.fill.badge.plus")
                    }
                }
            }
        }
    }
}


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

// Previsualización
struct TenantDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        TenantDashboardView()
    }
}
