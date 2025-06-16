//
//  Tenant.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct Inquilino: Hashable, Identifiable, Codable {
    var id = UUID()
    
    // Información personal
    var firstName: String
    var lastName: String
    var email: String? = ""
    var phoneNumber: String?
    var imageID: [String?]? = nil
    
    // Información del contrato
    var contratoActualId: UUID?
    var historialIds: [UUID] = []
    var resumenId: UUID?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // Implementación de Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Inquilino, rhs: Inquilino) -> Bool {
        lhs.id == rhs.id
    }
    
    // Implementación de Codable
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case phoneNumber
        case imageID
        case contratoActualId
        case historialIds
        case resumenId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        imageID = try container.decodeIfPresent([String?].self, forKey: .imageID)
        contratoActualId = try container.decodeIfPresent(UUID.self, forKey: .contratoActualId)
        historialIds = try container.decode([UUID].self, forKey: .historialIds)
        resumenId = try container.decodeIfPresent(UUID.self, forKey: .resumenId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(imageID, forKey: .imageID)
        try container.encodeIfPresent(contratoActualId, forKey: .contratoActualId)
        try container.encode(historialIds, forKey: .historialIds)
        try container.encodeIfPresent(resumenId, forKey: .resumenId)
    }
    
    init(id: UUID = UUID(), firstName: String, lastName: String, email: String? = nil, phoneNumber: String? = nil, imageID: [String?]? = nil, contratoActualId: UUID? = nil, historialIds: [UUID] = [], resumenId: UUID? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.imageID = imageID
        self.contratoActualId = contratoActualId
        self.historialIds = historialIds
        self.resumenId = resumenId
    }
}
