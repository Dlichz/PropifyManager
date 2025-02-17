//
//  PaymentsDashboard.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct PaymentsDashboard: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Gestión de Pagos")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Pagos")
        }
    }
}
#Preview {
    PaymentsDashboard()
}
