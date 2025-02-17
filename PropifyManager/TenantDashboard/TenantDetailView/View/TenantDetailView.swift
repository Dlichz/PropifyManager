//
//  TenantDetailView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct TenantDetailView: View {
    let tenant: Tenant
    @State private var selectedPayment: Payment?
    @State private var showPaymentTicket = false
    @State private var isEditing = false
    @State private var showContract = false
    
    let paymentHistory: [Payment] = [
        Payment(id: "", date: Date().addingTimeInterval(-60 * 60 * 24 * 30), amount: 8000),
        Payment(id: "", date: Date().addingTimeInterval(-60 * 60 * 24 * 60), amount: 8000),
        Payment(id: "", date: Date().addingTimeInterval(-60 * 60 * 24 * 90), amount: 8000)
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Información Personal")) {
                Text("Nombre: \(tenant.firstName) \(tenant.lastName)")
                Text("Correo Electrónico: \(tenant.email)")
                if let phone = tenant.phoneNumber {
                    Text("Teléfono: \(phone)")
                }
            }
            
            Section(header: Text("Detalles del Contrato")) {
                Text("Inicio del Contrato: \(tenant.contractStart.formatted(date: .numeric, time: .omitted))")
                if let contractEnd = tenant.contractEnd {
                    Text("Fin del Contrato: \(contractEnd.formatted(date: .numeric, time: .omitted))")
                }
                Text("Próximo Pago: \(Date())")
            }
            
            Section(header: Text("Historial de Pagos")) {
                if paymentHistory.isEmpty {
                    Text("No hay pagos registrados")
                        .foregroundColor(.gray)
                } else {
                    ForEach(paymentHistory, id: \.id) { payment in
                        Button(action: {
                            selectedPayment = payment
                            showPaymentTicket.toggle()
                        }) {
                            HStack {
                                Text(payment.date.formatted(date: .numeric, time: .omitted))
                                Spacer()
                                Text("$\(payment.amount, specifier: "%.2f")")
                                    .bold()
                            }
                        }
                    }
                }
            }
            
            Section {
                Button(action: {
                    showContract.toggle()
                }) {
                    Text("Ver Contrato")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .listRowBackground(Color.blue)
            }
        }
        .navigationTitle("\(tenant.firstName) \(tenant.lastName)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") {
                    isEditing.toggle()
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditTenantView(tenant: tenant)
        }
        .sheet(isPresented: $showContract) {
            ContractView(tenant: tenant)
        }
        .sheet(item: $selectedPayment) { payment in
            PaymentTicketView(payment: payment, tenant: tenant)
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

