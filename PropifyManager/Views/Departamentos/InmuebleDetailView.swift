//
//  InmuebleDetailView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI
import MapKit

struct InmuebleDetailView: View {
    let inmueble: Inmueble
    @State private var selectedImageIndex = 0
    @State private var region: MKCoordinateRegion
    
    init(inmueble: Inmueble) {
        self.inmueble = inmueble
        // Inicializar la región del mapa con las coordenadas del inmueble
        _region = State(initialValue: MKCoordinateRegion(
            center: inmueble.direccion.coordenadas,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Galería de imágenes
                if !inmueble.images.isEmpty {
                    TabView(selection: $selectedImageIndex) {
                        ForEach(0..<inmueble.images.count, id: \.self) { index in
                            AsyncImage(url: URL(string: inmueble.images[index])) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .tag(index)
                        }
                    }
                    .frame(height: 250)
                    .tabViewStyle(PageTabViewStyle())
                }
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(inmueble.defaultName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(inmueble.type.rawValue)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Especificaciones principales
                VStack(alignment: .leading, spacing: 16) {
                    Text("Especificaciones")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            SpecificationItem(icon: "bed.double.fill", title: "Recámaras", value: "\(inmueble.numeroRecamaras)")
                            SpecificationItem(icon: "shower.fill", title: "Baños", value: "\(inmueble.numeroBanos)")
                        }
                        GridRow {
                            SpecificationItem(icon: "car.fill", title: "Estacionamientos", value: "\(inmueble.numeroEstacionamientos)")
                            SpecificationItem(icon: "pawprint.fill", title: "Mascotas", value: inmueble.aceptaMascotas ? "Permitidas" : "No permitidas")
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Dimensiones
                VStack(alignment: .leading, spacing: 16) {
                    Text("Dimensiones")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    DetailRow(title: "Largo", value: "\(String(format: "%.2f", inmueble.dimensiones.largo)) m")
                    DetailRow(title: "Ancho", value: "\(String(format: "%.2f", inmueble.dimensiones.ancho)) m")
                    DetailRow(title: "Alto", value: "\(String(format: "%.2f", inmueble.dimensiones.alto)) m")
                    DetailRow(title: "Área Total", value: "\(String(format: "%.2f", inmueble.dimensiones.areaTotal)) m²")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Dirección
                VStack(alignment: .leading, spacing: 16) {
                    Text("Dirección")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    DetailRow(title: "Calle", value: "\(inmueble.direccion.calle) \(inmueble.direccion.numeroExterior)")
                    DetailRow(title: "Colonia", value: inmueble.direccion.colonia)
                    DetailRow(title: "Municipio", value: inmueble.direccion.municipio)
                    DetailRow(title: "Estado", value: inmueble.direccion.estado)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Estado y renta
                VStack(alignment: .leading, spacing: 16) {
                    Text("Información General")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    DetailRow(title: "Estado", value: inmueble.ocupado ? "Ocupado" : "Disponible")
                    DetailRow(title: "Renta Mensual", value: "$\(String(format: "%.2f", inmueble.rentaMensual))")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                if let notas = inmueble.notas {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notas")
                            .font(.headline)
                        Text(notas)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
                
                // Mapa
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ubicación")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Map(coordinateRegion: $region, annotationItems: [inmueble]) { item in
                        MapMarker(coordinate: item.direccion.coordenadas)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SpecificationItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    InmuebleDetailView(inmueble: Inmueble(
        id: UUID(),
        type: .Departamento,
        name: "Departamento Centro",
        direccion: Direccion(
            id: UUID(),
            calle: "Reforma",
            numeroExterior: "123",
            numeroInterior: "A",
            colonia: "Centro",
            municipio: "Cuauhtémoc",
            estado: "CDMX",
            pais: "México",
            codigoPostal: "06000",
            apodo: "Centro",
            latitud: 19.4326,
            longitud: -99.1332
        ),
        metrosCuadrados: 80.0,
        rentaMensual: 15000.0,
        ocupado: true,
        inquilino: nil,
        notas: "Departamento amueblado",
        images: [],
        numeroRecamaras: 2,
        numeroBanos: 2,
        numeroEstacionamientos: 1,
        aceptaMascotas: true,
        dimensiones: Dimensiones(largo: 8.0, ancho: 10.0, alto: 2.5)
    ))
}
