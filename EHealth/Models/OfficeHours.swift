//
//  OfficeHours.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct OfficeHours: Decodable {
    var id: Int
    var doctorId: Int
    var startTime: String
    var endTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctorId
        case startTime
        case endTime
    }
}
