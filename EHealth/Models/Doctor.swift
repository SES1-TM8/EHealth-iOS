//
//  Doctor.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct Doctor: Decodable {
    var id: Int
    var name: String
    var phoneNumber: String
    var email: String
    var beginTime: Int
    var endTime: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone"
        case email
        case beginTime = "beginHours"
        case endTime = "endHours"
    }
    
}

struct DoctorAPI: Codable {
    var doctorId: Int
    var registration: String
    var userId: Int
    var verified: Bool
    
    enum CodingKeys: String, CodingKey {
        case doctorId
        case registration = "registraitonNumber"
        case userId
        case verified
    }
}

extension DoctorAPI {
    
    static func save(doctor: DoctorAPI){
        let defaults = UserDefaults.standard
        
        defaults.set(try? JSONEncoder().encode(doctor), forKey: "ehealth_doctor")
    }
    
    static func load() -> DoctorAPI? {
        let defaults = UserDefaults.standard
        
        if let encoded = defaults.data(forKey: "ehealth_doctor") {
            return try? JSONDecoder().decode(DoctorAPI.self, from:encoded)
        }
        
        return nil
    }
    
}
