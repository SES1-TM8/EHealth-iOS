//
//  Patient.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct PatientModel: Decodable {
    var id: Int
    var name: String
    var phoneNumber: String
    var email: String
    var address: String
    var dateOfBirth: String
    var medicareNumber: String
    var concessionType: ConcessionType
    var concessionCardNumber: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone"
        case email
        case address
        case dateOfBirth = "dob"
        case medicareNumber = "medicareNum"
        case concessionType
        case concessionCardNumber = "concessionNum"
    }
}

enum ConcessionType: String, CaseIterable {
    case pensioner = "pensioner"
    case student = "student"
    case veteran = "veteran"
    case generic = "generic"
    case none = "none"
    
    func displayName() -> String{
        switch(self) {
        case .pensioner:
            return "Pensioner"
        case .student:
            return "Student"
        case .veteran:
            return "Veteran"
        case .generic:
            return "Other"
        case .none:
            return "None"
        }
    }
}

extension PatientModel {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        email = try values.decode(String.self, forKey: .email)
        address = try values.decode(String.self, forKey: .address)
        dateOfBirth = try values.decode(String.self, forKey: .dateOfBirth)
        medicareNumber = try values.decode(String.self, forKey: .medicareNumber)
        concessionType = ConcessionType(rawValue: try values.decode(String.self, forKey: .concessionType)) ?? .none
        concessionCardNumber = try values.decode(String.self, forKey: .concessionCardNumber)
    }
}

struct Patient: Codable {
    var id: Int
    var concessionType: ConcessionType
    var concessionNumber: String
    var medicareNumber: String
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "patientId"
        case concessionType
        case concessionNumber
        case medicareNumber
        case userId
    }
}

extension Patient {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        concessionType = ConcessionType(rawValue: try values.decode(String.self, forKey: .concessionType)) ?? .none
        concessionNumber = try values.decode(String.self, forKey: .concessionNumber)
        medicareNumber = try values.decode(String.self, forKey: .medicareNumber)
        userId = try values.decode(Int.self, forKey: .userId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(concessionType.rawValue, forKey: .concessionType)
        try container.encode(concessionNumber, forKey: .concessionNumber)
        try container.encode(medicareNumber, forKey: .medicareNumber)
        try container.encode(userId, forKey: .userId)
    }
}

extension Patient {
    static func save(patient: Patient){
        let defaults = UserDefaults.standard
        
        defaults.set(try? JSONEncoder().encode(patient), forKey: "ehealth_patient")
    }
    
    static func load() -> Patient? {
        let defaults = UserDefaults.standard
        
        if let encoded = defaults.data(forKey: "ehealth_patient") {
            return try? JSONDecoder().decode(Patient.self, from:encoded)
        }
        
        return nil
    }
    
    
}


