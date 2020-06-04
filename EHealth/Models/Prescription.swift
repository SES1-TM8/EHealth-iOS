//
//  Prescription.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct PrescriptionModel: Decodable {
    var id: Int
    var prescribedBy: Doctor
    var prescribedTo: PatientModel
    var medication: MedicationModel
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

extension PrescriptionModel {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        prescribedBy = try values.decode(Doctor.self, forKey: .prescribedBy)
        prescribedTo = try values.decode(PatientModel.self, forKey: .presribedTo)
        medication = try values.decode(MedicationModel.self, forKey: .medication)
        dosage = try values.decode(Double.self, forKey: .dosage)
        amount = try values.decode(Int.self, forKey: .amount)
        perUnit = TimingOptions(rawValue: try values.decode(String.self, forKey: .perUnit)) ?? .day
        prescriptionDate = try values.decode(Int.self, forKey: .prescriptionDate)
    }
}

struct Prescription: Decodable {
    var id: Int
    var patientId: Int
    var medicationId: Int
    var frequency: Double
    var frequencyUnit: String
    var notes: String
    var doctorId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "prescriptionId"
        case patientId
        case medicationId
        case frequency
        case frequencyUnit
        case notes
        case doctorId = "prescriberId"
    }
}
