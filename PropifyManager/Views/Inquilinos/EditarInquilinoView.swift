import SwiftUI
import PhotosUI

struct EditarInquilinoView: View {
    @Environment(\.dismiss) var dismiss
    let inquilino: Inquilino?
    var isEditing: Bool { inquilino != nil }
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    // Detalles del contrato
    @State private var selectedInmueble: Inmueble?
    @State private var contractStart: Date = Date()
    @State private var includeContractEnd: Bool = false
    @State private var contractEnd: Date = Date().addingTimeInterval(365*24*60*60)
    @State private var rentAmount: String = ""
    @State private var depositAmount: String = ""
    @State private var depositPaid: Bool = false
    
    // Servicios incluidos
    @State private var includesElectricity: Bool = false
    @State private var includesInternet: Bool = false
    @State private var includesWater: Bool = false
    @State private var includesGas: Bool = false
    
    // Observaciones
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Información Personal
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $firstName)
                        .autocapitalization(.words)
                    TextField("Apellido", text: $lastName)
                        .autocapitalization(.words)
                    TextField("Correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Teléfono", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    
                    // Foto de perfil
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Seleccionar foto")
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                            }
                        }
                    }
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
                
                // Detalles del Contrato
                Section(header: Text("Detalles del Contrato")) {
                    // Selector de inmueble
                    NavigationLink {
                        // Aquí iría la vista de selección de inmueble
                        Text("Seleccionar Inmueble")
                    } label: {
                        HStack {
                            Text("Inmueble")
                            Spacer()
                            if let inmueble = selectedInmueble {
                                Text(inmueble.defaultName)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Seleccionar")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    DatePicker("Inicio del Contrato", selection: $contractStart, displayedComponents: .date)
                    
                    Toggle("¿Contrato con fecha de finalización?", isOn: $includeContractEnd)
                    
                    if includeContractEnd {
                        DatePicker("Fin del Contrato", selection: $contractEnd, displayedComponents: .date)
                    }
                    
                    TextField("Monto de la renta mensual", text: $rentAmount)
                        .keyboardType(.decimalPad)
                }
                
                // Depósito
                Section(header: Text("Depósito")) {
                    Toggle("¿Dio depósito?", isOn: $depositPaid)
                    
                    if depositPaid {
                        TextField("Monto del depósito", text: $depositAmount)
                            .keyboardType(.decimalPad)
                    }
                }
                
                // Servicios incluidos
                Section(header: Text("Servicios Incluidos")) {
                    Toggle("Luz", isOn: $includesElectricity)
                    Toggle("Internet", isOn: $includesInternet)
                    Toggle("Agua", isOn: $includesWater)
                    Toggle("Gas", isOn: $includesGas)
                }
                
                // Observaciones
                Section(header: Text("Observaciones")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle(isEditing ? "Editar Inquilino" : "Nuevo Inquilino")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveInquilino()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || rentAmount.isEmpty || selectedInmueble == nil)
                }
            }
            .onAppear {
                if let inquilino = inquilino {
                    // Cargar datos del inquilino si estamos editando
                    firstName = inquilino.firstName
                    lastName = inquilino.lastName
                    email = inquilino.email ?? ""
                    phoneNumber = inquilino.phoneNumber ?? ""
                }
            }
        }
    }
    
    private func saveInquilino() {
        // Aquí iría la lógica para guardar el inquilino
        dismiss()
    }
}

#Preview {
    EditarInquilinoView(inquilino: nil)
} 