//
//  ContentView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tenantDashboardViewModel = TenantDashboardViewModel() // ✅ Se crea aquí
    
    var tenant = Tenant(firstName: "Francisco", lastName: "Zárate Vásquez", email: "davidzarate33@gmail.com", phoneNumber: "9513929968", contractStart: Date(), contractEnd: nil, nextPaymentDate: nil, paymentStatus: .current, notes: "")

    var body: some View {
        TabView {
            TenantDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            PaymentsDashboard()
                .tabItem {
                    Label("Pagos", systemImage: "dollarsign.circle.fill")
                }

            TenantsView()
                .tabItem {
                    Label("Inquilinos", systemImage: "person.3.fill")
                }

            ContractView(tenant: tenant)
                .tabItem {
                    Label("Departamentos", systemImage: "building.fill")
                }

            ReportsDashboardView()
                .tabItem {
                    Label("Reportes", systemImage: "chart.bar.fill")
                }
        }
        .environmentObject(tenantDashboardViewModel) // ✅ Se pasa a toda la jerarquía de vistas
    }
}



struct TenantsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Gestión de Inquilinos")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Inquilinos")
        }
    }
}

struct ApartmentsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Gestión de Departamentos")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Departamentos")
        }
    }
}

struct ReportsDashboardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Reportes del Mes")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Reportes")
        }
    }
}

// Previsualización
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
