import SwiftUI

class InmueblesViewModel: ObservableObject {
    @Published var inmuebles: [Inmueble] = []
    
    var totalInmuebles: Int {
        inmuebles.count
    }
    
    var inmueblesDisponibles: Int {
        inmuebles.filter { !$0.ocupado }.count
    }
    
    var inmueblesOcupados: Int {
        inmuebles.filter { $0.ocupado }.count
    }
    
    var inmueblesPorTipo: [InmuebleType: Int] {
        Dictionary(grouping: inmuebles, by: { $0.type })
            .mapValues { $0.count }
    }
    
    // TODO: Implement data loading from your data source
    func loadInmuebles() {
        // This is where you'll load your data
        // For now, we'll use sample data
        inmuebles = [
            Inmueble(id: UUID(),
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
                    ),
        ]
    }
}

