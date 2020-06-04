//
//  Appointment.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

struct AppointmentModel: Decodable {
    var patient: PatientModel
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

struct Appointment: Decodable {
    var id: Int
    var patientId: Int
    var doctorId: Int
    var start: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "appointmentId"
        case patientId, doctorId, start
    }
}

struct AppointmentResponse: Decodable {
    var infoId: Int
    var appointment: Appointment
    var desc: String
    var uploads: [S3Uploads]
    
    enum CodingKeys: String, CodingKey {
        case infoId = "appointmentInfoId"
        case appointment
        case desc = "description"
        case uploads
    }
}

struct S3Uploads: Decodable {
    var uploadUrl: String
    var callbackUrl: String
    
    enum CodingKeys: String, CodingKey {
        case uploadUrl = "uploadURL"
        case callbackUrl = "callbackURL"
    }
}

struct AppointmentInformation: Codable {
    var id: Int
    var description: String
    var imageIds: [Int]
    var appointmentId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case imageIds
        case appointmentId
    }
}


