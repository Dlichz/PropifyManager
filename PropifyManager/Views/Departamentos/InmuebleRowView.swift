//
//  InmuebleRowView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI

struct InmuebleRowView: View {
    let inmueble: Inmueble
    
    var body: some View {
        HStack {
            if let firstImage = inmueble.images.first {
                Image(firstImage)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            } else {
                Image(systemName: "building.2")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(inmueble.defaultName)
                    .font(.headline)
                
                if inmueble.ocupado {
                    Text("Ocupado por Inquilino")
                        .font(.subheadline)
                        .foregroundColor(.red)
                } else {
                    Text("Disponible")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Text("Próx. pago: ")
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Último pago")
                    .font(.caption)
                Text("$\(inmueble.rentaMensual, specifier: "%.2f")")
                    .bold()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
        .padding(.horizontal)
    }
}

#Preview {
    InmuebleRowView(inmueble: Inmueble(id: UUID(),
                                       type: .Departamento,
                                       name: "Depta",
                                       direccion: Direccion(id: UUID(),
                                                            calle: "Privada 20 de enero",
                                                            numeroExterior: "45", numeroInterior: "depto 3", colonia: "San Sebastián Tutla",
                                                            municipio: "San sebastián tutla",
                                                            estado: "Oaxaca",
                                                            pais: "México",
                                                            codigoPostal: "71320",
                                                            apodo: nil,
                                                            latitud: 17.060172697246948, longitud: -96.67655616211829),
                                       metrosCuadrados: 32.3,
                                       rentaMensual: 14500.0,
                                       ocupado: true,
                                       notas: nil,
                                       images: ["icon"],
                                       numeroRecamaras: 2,
                                       numeroBanos: 1,
                                       numeroEstacionamientos: 0,
                                       aceptaMascotas: false,
                                       dimensiones: Dimensiones(largo: 12.0, ancho: 12.0, alto: 12.0)
    ))
}
