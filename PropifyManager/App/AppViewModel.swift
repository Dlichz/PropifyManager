//
//  TenantDashboardViewModel.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import Foundation

class AppViewModel: ObservableObject {
    
    @Published var isAuthenticated = false

    
    @Published var tenants: [Inquilino] = []
    
    @Published var searchText: String = "H"
    @Published var filterByMonth: String = ""
    
    init() {
        self.tenants = [
        ]
    }
    
    func addTenant(_ tenant: Inquilino) {
        tenants.append(tenant)
    }
    
    func removeTenant(at index: Int) {
        tenants.remove(at: index)
    }
    
    func updateTenant(_ tenant: Inquilino) {
            if let index = tenants.firstIndex(where: { $0.id == tenant.id }) {
                tenants[index] = tenant
            }
        }
    
    var months: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols
    }
    
    var filteredTenants: [Inquilino] {
        var tenants = self.tenants

        if !searchText.isEmpty {
            tenants = tenants.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText)
            }
        }

        if !filterByMonth.isEmpty {
        }
        
        return tenants
    }
    
}
