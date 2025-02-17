//
//  PaymentTicketView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct PaymentTicketView: View {
    let payment: Payment
    let tenant: Tenant
    @State private var capturedImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var formattedDate: String {
        payment.date.formatted(date: .numeric, time: .omitted)
    }
    
    var ticketText: String {
        return """
        🏠 **Inquilino:** \(tenant.firstName) \(tenant.lastName)
        📅 **Fecha:** \(formattedDate)
        💰 **Monto:** $\(String(format: "%.2f", payment.amount))
        """
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Recibo de Pago")
                .font(.title)
                .bold()
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("🏠 **Inquilino:** \(tenant.firstName) \(tenant.lastName)")
                Text("📅 **Fecha:** \(formattedDate)")
                Text("💰 **Monto:** $\(String(format: "%.2f", payment.amount))")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
            .padding()
            
            // Vista previa de la imagen capturada (solo para depuración)
            if let capturedImage = capturedImage {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }
            
            Button(action: captureAndShare) {
                HStack {
                    Image(systemName: "arrowshape.turn.up.right")
                    Text("Compartir por WhatsApp")
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func captureAndShare() {
        // Captura la imagen
        let image = self.snapshot()
        capturedImage = image // Muestra la imagen capturada en la vista previa
        
        // Guarda la imagen en un archivo temporal
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            alertMessage = "No se pudo convertir la imagen a Data."
            showAlert = true
            return
        }
        
        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("ticket.jpg")
        do {
            try imageData.write(to: tempFileURL)
            
            // Crea un UIActivityViewController para compartir la imagen y el texto
            let activityVC = UIActivityViewController(
                activityItems: [ticketText, tempFileURL],
                applicationActivities: nil
            )
            
            // Presenta el UIActivityViewController desde la ventana activa
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                activityVC.popoverPresentationController?.sourceView = rootViewController.view
                rootViewController.present(activityVC, animated: true, completion: nil)
            }
        } catch {
            alertMessage = "No se pudo guardar la imagen temporalmente."
            showAlert = true
        }
    }
}
