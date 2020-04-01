//
//  Prescription.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct Prescription: Decodable {
    var id: Int
    var prescribedBy: Doctor
    var prescribedTo: Patient
    var medication: Medication
    var dosage: Double // TODO: Create actual units (assuming mg at the moment)
    var amount: Int
    var perUnit: TimingOptions
    var prescriptionDate: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case prescribedBy = "prescriber"
        case presribedTo = "patient"
        case medication
        case dosage
        case amount
        case perUnit = "unit"
        case prescriptionDate = "date"
    }
}

enum TimingOptions: String {
    case day = "day"
    case week = "week"
    case month = "month"
    case hour = "hour"
}

extension Prescription {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        prescribedBy = try values.decode(Doctor.self, forKey: .prescribedBy)
        prescribedTo = try values.decode(Patient.self, forKey: .presribedTo)
        medication = try values.decode(Medication.self, forKey: .medication)
        dosage = try values.decode(Double.self, forKey: .dosage)
        amount = try values.decode(Int.self, forKey: .amount)
        perUnit = TimingOptions(rawValue: try values.decode(String.self, forKey: .perUnit)) ?? .day
        prescriptionDate = try values.decode(Int.self, forKey: .prescriptionDate)
    }
}
