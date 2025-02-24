//
//  EditDetailView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI
/*
struct EditTenantView: View {
    @State var tenant: Tenant
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var contractStart: Date = Date()
    @State private var includeContractEnd: Bool = false
    @State private var contractEnd: Date = Date()
    @State private var nextPaymentDate: Date = Date()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $tenant.firstName)
                    TextField("Apellido", text: $tenant.lastName)
                    TextField("Correo Electrónico", text: $tenant.email)
                        .keyboardType(.emailAddress)
                    TextField("Teléfono", text: Binding(
                        get: { tenant.phoneNumber ?? "" },
                        set: { tenant.phoneNumber = $0.isEmpty ? nil : $0 }
                    ))
                    .keyboardType(.phonePad)
                    
                }
                
                Section(header: Text("Detalles del Contrato")) {
                    DatePicker("Inicio del Contrato", selection: $tenant.contractStart, displayedComponents: .date)
                    
                }
            }
            .navigationTitle("Editar Inquilino")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        // Aquí puedes guardar los cambios en la base de datos
                        let tenant = Tenant(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                            contractStart: contractStart,
                            contractEnd: includeContractEnd ? contractEnd : nil, paymentStatus: .overdue
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}
*/
