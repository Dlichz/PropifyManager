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
    
    init(id: UUID = UUID(), type: InmuebleType, name: String, direccion: Direccion, metrosCuadrados: Double, rentaMensual: Double, ocupado: Bool, inquilino: Inquilino?, notas: String?, images: [String], numeroRecamaras: Int, numeroBanos: Int, numeroEstacionamientos: Int, aceptaMascotas: Bool, dimensiones: Dimensiones) {
        self.id = id
        self.type = type
        self.name = name
        self.direccion = direccion
        self.metrosCuadrados = metrosCuadrados
        self.rentaMensual = rentaMensual
        self.ocupado = ocupado
        self.inquilino = inquilino
        self.notas = notas
        self.images = images
        self.numeroRecamaras = numeroRecamaras
        self.numeroBanos = numeroBanos
        self.numeroEstacionamientos = numeroEstacionamientos
        self.aceptaMascotas = aceptaMascotas
        self.dimensiones = dimensiones
    }
    
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
    
    init(id: UUID = UUID(), calle: String, numeroExterior: String, numeroInterior: String?, colonia: String, municipio: String, estado: String, pais: String, codigoPostal: String, apodo: String?, latitud: Double, longitud: Double) {
        self.id = id
        self.calle = calle
        self.numeroExterior = numeroExterior
        self.numeroInterior = numeroInterior
        self.colonia = colonia
        self.municipio = municipio
        self.estado = estado
        self.pais = pais
        self.codigoPostal = codigoPostal
        self.apodo = apodo
        self.latitud = latitud
        self.longitud = longitud
    }
    
    var coordenadas: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
    }
}

struct Dimensiones: Hashable, Codable {
    var largo: Double
    var ancho: Double
    var alto: Double
    
    init(largo: Double, ancho: Double, alto: Double) {
        self.largo = largo
        self.ancho = ancho
        self.alto = alto
    }
    
    var areaTotal: Double {
        return largo * ancho
    }
}
