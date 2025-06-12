//
//  PaymentTicketView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct PaymentTicketView: View {
    let payment: Pago
    let tenant: Inquilino
    
    @State private var imageToShare: UIImage?
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
            if let capturedImage = imageToShare {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }
            
            Button(action: captureScreenAndShare) {
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
    
    func captureScreenAndShare() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
        let image = renderer.image { ctx in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }

        shareImage(image)
    }
    
    // Función para compartir la imagen usando UIActivityViewController
    func shareImage(_ image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
}
