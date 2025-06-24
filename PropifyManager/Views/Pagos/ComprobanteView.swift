//
//  ComprobanteView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct ComprobanteView: View {
    let url: String
    let titulo: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: url) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        VStack {
                            Image(systemName: "doc.text")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("Cargando comprobante...")
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        Text("URL de comprobante inválida")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("No se pudo cargar el comprobante")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(titulo)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                if let url = URL(string: url) {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Abrir") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ComprobanteView(url: "https://example.com/comprobante.pdf", titulo: "Comprobante de Pago")
} 