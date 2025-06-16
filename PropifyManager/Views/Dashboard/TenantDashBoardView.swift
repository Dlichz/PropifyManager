//
//  TenantDashBoardView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI
import Charts

struct TenantDashboardView: View {
    @State private var selectedTimeFrame: TimeFrame = .month
    
    enum TimeFrame: String, CaseIterable {
        case week = "Semana"
        case month = "Mes"
        case year = "Año"
    }
    
    // Modelos de ejemplo para los datos
    struct UpcomingPayment: Identifiable {
        let id = UUID()
        let tenantName: String
        let propertyNumber: String
        let amount: Double
        let dueDate: Date
    }
    
    struct ExpiringContract: Identifiable {
        let id = UUID()
        let tenantName: String
        let propertyNumber: String
        let daysRemaining: Int
        let expirationDate: Date
    }
    
    struct IncomeData: Identifiable {
        let id = UUID()
        let month: String
        let amount: Double
    }
    
    struct OccupancyData: Identifiable {
        let id = UUID()
        let type: String
        let count: Int
    }
    
    // Datos de ejemplo
    let upcomingPayments = [
        UpcomingPayment(tenantName: "Juan Pérez", propertyNumber: "101", amount: 12000, dueDate: Date()),
        UpcomingPayment(tenantName: "María López", propertyNumber: "203", amount: 15000, dueDate: Date().addingTimeInterval(86400)),
        UpcomingPayment(tenantName: "Carlos Ruiz", propertyNumber: "305", amount: 18000, dueDate: Date().addingTimeInterval(172800))
    ]
    
    let expiringContracts = [
        ExpiringContract(tenantName: "María García", propertyNumber: "203", daysRemaining: 30, expirationDate: Date().addingTimeInterval(2592000)),
        ExpiringContract(tenantName: "Roberto Sánchez", propertyNumber: "405", daysRemaining: 45, expirationDate: Date().addingTimeInterval(3888000))
    ]
    
    let incomeData = [
        IncomeData(month: "Ene", amount: 24000),
        IncomeData(month: "Feb", amount: 28000),
        IncomeData(month: "Mar", amount: 32000),
        IncomeData(month: "Abr", amount: 29000),
        IncomeData(month: "May", amount: 35000),
        IncomeData(month: "Jun", amount: 38000)
    ]
    
    let occupancyData = [
        OccupancyData(type: "Ocupados", count: 8),
        OccupancyData(type: "Disponibles", count: 2)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Time Frame Selector
                Picker("Período", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                        Text(timeFrame.rawValue).tag(timeFrame)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Ingresos Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ingresos del \(selectedTimeFrame.rawValue)")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text("$24,500")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(.green)
                                Text("+12%")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Gráfica de ingresos
                        Chart(incomeData) { item in
                            BarMark(
                                x: .value("Mes", item.month),
                                y: .value("Ingresos", item.amount)
                            )
                            .foregroundStyle(Color.blue.gradient)
                        }
                        .frame(height: 200)
                        .padding(.top)
                    }
                }
                
                // Estado de Propiedades Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Estado de Propiedades")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        // Gráfica circular de ocupación
                        Chart(occupancyData) { item in
                            SectorMark(
                                angle: .value("Cantidad", item.count),
                                innerRadius: .ratio(0.618),
                                angularInset: 1.5
                            )
                            .foregroundStyle(by: .value("Tipo", item.type))
                        }
                        .frame(height: 200)
                        
                        HStack(spacing: 20) {
                            ForEach(occupancyData) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.type)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                                        Text("\(item.count)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Text("de 10")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Próximos Pagos Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Próximos Pagos")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        ForEach(upcomingPayments) { payment in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(payment.tenantName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("Departamento \(payment.propertyNumber)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("$\(Int(payment.amount))")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text(payment.dueDate, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            if payment.id != upcomingPayments.last?.id {
                                Divider()
                            }
                        }
                    }
                }
                
                // Contratos por Vencer Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contratos por Vencer")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        ForEach(expiringContracts) { contract in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(contract.tenantName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("Departamento \(contract.propertyNumber)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(contract.daysRemaining) días")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                    Text(contract.expirationDate, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            if contract.id != expiringContracts.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
}

// Card View Component
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
    }
}

// Previsualización
struct TenantDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TenantDashboardView()
        }
    }
}
