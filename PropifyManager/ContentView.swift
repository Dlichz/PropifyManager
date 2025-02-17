//
//  ContentView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct ContentView: View {
    var tenant = Tenant(firstName: "Francisco", lastName: "Zárate Vásquez", email: "davidzarate33@gmail.com", phoneNumber: "9513929968", contractStart: Date(), contractEnd: nil, nextPaymentDate: nil, paymentStatus: .inactive)
    var body: some View {
        TabView {
            // 1. Dashboard principal
            TenantDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            // 2. Pagos
            PaymentsDashboard()
                .tabItem {
                    Label("Pagos", systemImage: "dollarsign.circle.fill")
                }

            // 3. Inquilinos
            TenantsView()
                .tabItem {
                    Label("Inquilinos", systemImage: "person.3.fill")
                }

            // 4. Departamentos
            ContractView(tenant: tenant)
                .tabItem {
                    Label("Departamentos", systemImage: "building.fill")
                }

            // 5. Dashboard de reportes del mes
            ReportsDashboardView()
                .tabItem {
                    Label("Reportes", systemImage: "chart.bar.fill")
                }
        }
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
