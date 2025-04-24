//
//  TenantDashboardViewModel.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import Foundation

class TenantDashboardViewModel: ObservableObject {
    @Published var tenants: [Tenant] = []
    
    @Published var searchText: String = "H"
    @Published var filterByMonth: String = ""
    
    init() {
        self.tenants = [
            Tenant(firstName: "Francisco David", lastName: "Zárate", email: "davidzarate33@gmail.com", contractStart: Date().addingTimeInterval(-60 * 60 * 24 * 30), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 5), paymentStatus: .current),
            Tenant(firstName: "Pedro", lastName: "Pascal", email: "PedroPascal@gmail.com", contractStart: Date().addingTimeInterval(60 * 60 * 24 * 30), paymentStatus: .inactive),
            Tenant(firstName: "Juan", lastName: "Fernandez", email: "Fernandez33@gmail.com", contractStart: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 5), paymentStatus: .overdue),
            Tenant(firstName: "Lorena", lastName: "Vásquez", email: "lorenaemoxita@gmail.com", contractStart: Date().addingTimeInterval(60 * 60 * 24 * 30 * 5), paymentStatus: .upcoming),
            Tenant(firstName: "Juan", lastName: "Pérez", email: "juan@example.com", phoneNumber: "1234567890", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 5), paymentStatus: .current),
            Tenant(firstName: "Ana", lastName: "Gómez", email: "ana@example.com", phoneNumber: "0987654321", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 12), paymentStatus: .inactive),
            Tenant(firstName: "Luis", lastName: "Martínez", email: "luis@example.com", phoneNumber: "5555555555", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 15), paymentStatus: .overdue),
            Tenant(firstName: "María", lastName: "López", email: "maria@example.com", phoneNumber: "6666666666", contractStart: Date(), contractEnd: nil, nextPaymentDate: nil, paymentStatus: .upcoming)
        ]
    }
    
    func addTenant(_ tenant: Tenant) {
        tenants.append(tenant)
    }
    
    func removeTenant(at index: Int) {
        tenants.remove(at: index)
    }
    
    func updateTenant(_ tenant: Tenant) {
            if let index = tenants.firstIndex(where: { $0.id == tenant.id }) {
                tenants[index] = tenant
            }
        }
    
    var months: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols
    }
    
    var filteredTenants: [Tenant] {
        var tenants = self.tenants

        if !searchText.isEmpty {
            tenants = tenants.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText)
            }
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
    
}
