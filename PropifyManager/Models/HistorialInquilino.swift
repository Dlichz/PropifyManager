import Foundation

struct HistorialInquilino: Identifiable, Codable {
    let id: UUID
    let inquilinoId: UUID
    let inmuebleId: UUID
    let fechaInicio: Date
    let fechaFin: Date?
    let rentaMensual: Double
    let motivoSalida: String?
    let notas: String?
    
    var duracion: TimeInterval {
        let endDate = fechaFin ?? Date()
        return endDate.timeIntervalSince(fechaInicio)
    }
    
    var duracionFormateada: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: fechaInicio, to: fechaFin ?? Date())
        
        if let years = components.year, years > 0 {
            return "\(years) año\(years > 1 ? "s" : "")"
        } else if let months = components.month {
            return "\(months) mes\(months > 1 ? "es" : "")"
        } else {
            return "Menos de un mes"
        }
    }
}

struct ResumenInquilino: Codable {
    let inquilinoId: UUID
    let inmuebleId: UUID
    let fechaInicio: Date
    let fechaFin: Date?
    let rentaMensual: Double
    let estadoPago: EstadoPago
    let proximoPago: Date?
    let montoProximoPago: Double?
    let pagos: [Pago]
    
    var totalPagado: Double {
        pagos.reduce(0) { $0 + $1.monto }
    }
    
    var inmuebleActual: Bool {
        fechaFin == nil
    }
    
    var estaActivo: Bool {
        fechaFin == nil
    }
    
    var inmueblesHistoricos: [UUID] {
        [inmuebleId]
    }
} 
