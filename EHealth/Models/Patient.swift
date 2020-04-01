//
//  Patient.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct Patient: Decodable {
    var id: Int
    var name: String
    var phoneNumber: String
    var email: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone"
        case email
        case address
    }
}
