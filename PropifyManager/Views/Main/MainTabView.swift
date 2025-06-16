//
//  MainTabView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TenantDashboardView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
            InmueblesDashboardView()
                .tabItem {
                    Label("Inicio", systemImage: "building.2.fill")
                }
            InquilinosDashboardView()
                .tabItem {
                    Label("Inicio", systemImage: "person.fill")
                }
        }
    }
}
