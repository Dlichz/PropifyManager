//
//  AddTenantViewModel.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 18/02/25.
//

import Foundation
import UserNotifications

class AddTenantViewModel {
    // Función para calcular la próxima fecha de pago a partir de la fecha de inicio del contrato.
    func calculateNextPaymentDate(from contractStart: Date) -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: contractStart)
    }
    
    // Función para programar una notificación unos días antes de la próxima fecha de pago.
    func schedulePaymentNotification(for tenantName: String, paymentDate: Date, daysBefore: Int = 3) {
        // Crea el contenido de la notificación.
        let content = UNMutableNotificationContent()
        content.title = "Pago Próximo"
        content.body = "El pago para \(tenantName) vence pronto. Recuerda recordarle."
        content.sound = .default
        
        // Calcula la fecha de la notificación restando 'daysBefore' días a la fecha de pago.
        guard let notificationDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: paymentDate) else {
            return
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        
        // Crea el trigger para la notificación.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Crea la solicitud de notificación.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Programa la notificación.
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error al programar la notificación: \(error.localizedDescription)")
            } else {
                print("Notificación programada para: \(notificationDate)")
            }
        }
    }
    
}
