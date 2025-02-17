//
//  AddTenant.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI
import PhotosUI

struct AddTenantView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var firestoreManager = FirestoreManager()
    
    // Información personal
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    // Detalles del contrato
    @State private var contractStart: Date = Date()
    @State private var includeContractEnd: Bool = false
    @State private var contractEnd: Date = Date()
    @State private var nextPaymentDate: Date = Date()
    
    // Información del departamento
    @State private var address: String = ""
    @State private var floor: String = ""
    
    // Servicios incluidos
    @State private var includesElectricity: Bool = false
    @State private var includesInternet: Bool = false
    @State private var includesWater: Bool = false
    @State private var includesGas: Bool = false
    
    // Renta y depósito
    @State private var depositGiven: Bool = false
    @State private var depositAmount: String = ""
    @State private var rentAmount: String = ""
    
    // Observaciones
    @State private var notes: String = ""
    
    // Subida de imágenes
    @State private var selectedImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            Form {
                // Información Personal
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $firstName)
                        .autocapitalization(.words)
                    TextField("Apellido", text: $lastName)
                        .autocapitalization(.words)
                    TextField("Correo Electrónico", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Teléfono", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                // Dirección del departamento
                Section(header: Text("Dirección del Departamento")) {
                    TextField("Dirección (Calle, Número, Colonia, Ciudad)", text: $address)
                    TextField("Piso", text: $floor)
                        .keyboardType(.numberPad)
                }
                
                // Servicios incluidos
                Section(header: Text("Servicios Incluidos")) {
                    Toggle("Luz", isOn: $includesElectricity)
                    Toggle("Internet", isOn: $includesInternet)
                    Toggle("Agua", isOn: $includesWater)
                    Toggle("Gas", isOn: $includesGas)
                }
                
                // Detalles del contrato
                Section(header: Text("Detalles del Contrato")) {
                    DatePicker("Inicio del Contrato", selection: $contractStart, displayedComponents: .date)
                    Toggle("¿Contrato con fecha de finalización?", isOn: $includeContractEnd)
                    
                    if includeContractEnd {
                        DatePicker("Fin del Contrato", selection: $contractEnd, displayedComponents: .date)
                    }
                }
                
                // Depósito y renta
                Section(header: Text("Renta y Depósito")) {
                    Toggle("¿Dio depósito?", isOn: $depositGiven)
                    
                    if depositGiven {
                        TextField("Monto del depósito", text: $depositAmount)
                            .keyboardType(.decimalPad)
                    }
                    
                    TextField("Monto de la renta mensual", text: $rentAmount)
                        .keyboardType(.decimalPad)
                }
                
                // Observaciones
                Section(header: Text("Observaciones")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                // Subir foto de identificación
                Section(header: Text("Foto de Identificación")) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Seleccionar foto")
                        }
                    }
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Nuevo Inquilino")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveTenant()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || rentAmount.isEmpty)
                }
            }
            .onChange(of: selectedPhoto) { newItem in
                loadSelectedImage()
            }
        }
    }
    
    // Función para cargar la imagen seleccionada
    private func loadSelectedImage() {
        Task {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
            }
        }
    }
    
    // Función para guardar el inquilino
    private func saveTenant() {
        let tenant = Tenant(firstName: firstName,
                            lastName: lastName,
                            email: email,
                            contractStart:
                                contractStart,
                            paymentStatus: .current)
        
        firestoreManager.addTenant(tenant) { success in
            if success {
                dismiss()
            }
        }
    }
}
