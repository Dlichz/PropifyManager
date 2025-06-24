import SwiftUI

enum EstadoPago: String, Codable, CaseIterable {
    case current = "Al Corriente"
    case upcoming = "Próximo"
    case overdue = "Atrasado"
    case inactive = "Inactivo"
    
    var color: Color {
        switch self {
        case .current:
            return .green
        case .upcoming:
            return .yellow
        case .overdue:
            return .red
        case .inactive:
            return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .current:
            return "checkmark.circle.fill"
        case .upcoming:
            return "clock.fill"
        case .overdue:
            return "exclamationmark.circle.fill"
        case .inactive:
            return "circle.fill"
        }
    }
} 
