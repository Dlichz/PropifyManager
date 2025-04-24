//
//  PropifyManagerApp.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI
import Firebase

@main
struct PropifyManagerApp: App {
    @StateObject private var tenantDashboardViewModel = TenantDashboardViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tenantDashboardViewModel)
        }
    }
}
