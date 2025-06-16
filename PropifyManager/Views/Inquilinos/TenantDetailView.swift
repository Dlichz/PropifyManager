//
//  TenantDetailView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct TenantDetailView: View {
    let tenant: Inquilino
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with tenant name
                VStack(spacing: 8) {
                    Text(tenant.fullName)
                        .font(.title)
                        .bold()
                    
                    if let email = tenant.email, !email.isEmpty {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Personal Information Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Información Personal")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        InfoRow(title: "Nombre", value: tenant.firstName)
                        InfoRow(title: "Apellido", value: tenant.lastName)
                        if let phone = tenant.phoneNumber {
                            InfoRow(title: "Teléfono", value: phone)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                // Contact Information Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Información de Contacto")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if let email = tenant.email {
                            InfoRow(title: "Correo", value: email)
                        }
                        if let phone = tenant.phoneNumber {
                            InfoRow(title: "Teléfono", value: phone)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        // TODO: Implement edit action
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Editar Información")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // TODO: Implement contract view action
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Ver Contrato")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // TODO: Implement payment history action
                    }) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Historial de Pagos")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Helper view for displaying information rows
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .bold()
        }
    }
}

// Preview provider
struct TenantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TenantDetailView(tenant: Inquilino(
                firstName: "John",
                lastName: "Doe",
                email: "john.doe@example.com",
                phoneNumber: "+1 234 567 8900"
            ))
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

