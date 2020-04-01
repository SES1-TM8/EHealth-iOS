//
//  Appointment.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

struct Appointment: Decodable {
    var patient: Patient
    var doctor: Doctor
    var reason: String?
    var time: Double
    var imageUrls: [String]?
    
    enum CodingKeys: String, CodingKey {
        case patient
        case doctor
        case reason
        case time
        case imageUrls = "urls"
    }
    
}
