//
//  UrgentCase.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct UrgentCase: Decodable {
    var id: Int
    var description: String
    var imageIds: [Int]
    var patientId: Int
    var resolved: Bool
    var openTime: String
    var closeTime: String?
    var resolvedBy: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case imageIds
        case patientId
        case resolved
        case openTime
        case closeTime
        case resolvedBy = "resolvedById"
    }
}

struct UrgentCaseCallbackResponse: Decodable {
    var id: Int
    var patientId: Int
    var description: String
    var uploads: [S3Uploads]
    var openTime: String
    var resolved: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "urgentId"
        case patientId
        case description
        case uploads
        case openTime
        case resolved
    }
}
