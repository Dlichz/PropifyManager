//
//  Inmueble.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI
import CoreLocation

enum InmuebleType: String, Hashable, Codable {
    case Departamento
    case Oficina
    case Casa
    case LocalComercial = "Local Comercial"
}

struct Inmueble: Hashable, Identifiable, Codable {
    let id: UUID
    let type: InmuebleType
    let name: String
    let direccion: Direccion
    let metrosCuadrados: Double
    var rentaMensual: Double
    var ocupado: Bool
    var inquilino: Inquilino?
    let notas: String?
    var images: [String] // URLs o identificadores de las imágenes
    
    // Nuevas especificaciones
    var numeroRecamaras: Int
    var numeroBanos: Int
    var numeroEstacionamientos: Int
    var aceptaMascotas: Bool
    var dimensiones: Dimensiones
    
    var defaultName: String {
        return "\(direccion.apodo ?? type.rawValue) \(direccion.calle)"
    }
}

struct Direccion: Hashable, Identifiable, Codable {
    let id: UUID
    let calle: String
    let numeroExterior: String
    let numeroInterior: String?
    let colonia: String
    let municipio: String
    let estado: String
    let pais: String
    let codigoPostal: String
    let apodo: String?
    let latitud: Double
    let longitud: Double
    
    var coordenadas: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
    }
}

struct Dimensiones: Hashable, Codable {
    var largo: Double
    var ancho: Double
    var alto: Double
    
    var areaTotal: Double {
        return largo * ancho
    }
}
