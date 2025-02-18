//
//  ViewModel.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import Foundation

class TenantViewModel: ObservableObject {
    @Published var tenants: [Tenant]
    
    @Published var searchText: String = ""
    @Published var filterByMonth: String = ""
    
    var filteredTenants: [Tenant] {
        var tenants = self.tenants
        
        // Filtrar por nombre
        if !searchText.isEmpty {
            tenants = tenants.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filtrar por mes (si se selecciona)
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
    
    // Lista de meses para el filtro
    var months: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols
    }
    
    init() {
        // Datos dummy
        self.tenants = [
            Tenant(firstName: "Francisco David", lastName: "Zárate", email: "davidzarate33@gmail.com", contractStart: Date().addingTimeInterval(-60 * 60 * 24 * 30), paymentStatus: .current),
            Tenant(firstName: "Pedro", lastName: "Pascal", email: "PedroPascal@gmail.com", contractStart: Date().addingTimeInterval(-60 * 60 * 24 * 30), paymentStatus: .current),
            Tenant(firstName: "Juan", lastName: "Fernandez", email: "Fernandez33@gmail.com", contractStart: Date().addingTimeInterval(-60 * 60 * 24 * 30), paymentStatus: .current),
            Tenant(firstName: "Lorena", lastName: "Vásquez", email: "lorenaemoxita@gmail.com", contractStart: Date().addingTimeInterval(-60 * 60 * 24 * 30), paymentStatus: .current),
            Tenant(firstName: "Juan", lastName: "Pérez", email: "juan@example.com", phoneNumber: "1234567890", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(86400 * 10), paymentStatus: .current),
            Tenant(firstName: "Ana", lastName: "Gómez", email: "ana@example.com", phoneNumber: "0987654321", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(-86400 * 5), paymentStatus: .overdue),
            Tenant(firstName: "Luis", lastName: "Martínez", email: "luis@example.com", phoneNumber: "5555555555", contractStart: Date(), contractEnd: nil, nextPaymentDate: Date().addingTimeInterval(86400 * 2), paymentStatus: .upcoming),
            Tenant(firstName: "María", lastName: "López", email: "maria@example.com", phoneNumber: "6666666666", contractStart: Date(), contractEnd: nil, nextPaymentDate: nil, paymentStatus: .inactive)
        ]
    }
    
    func fetchTenants() {
        // Aquí puedes simular la carga de datos, como si vinieran de Firebase
        print("Cargando inquilinos: \(tenants)")
    }
}
