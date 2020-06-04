//
//  User.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct User: Codable {
    var userId: Int
    var firstName: String
    var lastName: String
    var dob: String
    var email: String
    var phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case firstName
        case lastName
        case dob
        case email = "emailAddress"
        case phoneNumber
    }
}

extension User {
    static func save(user: User){
        let defaults = UserDefaults.standard
        
        defaults.set(try? JSONEncoder().encode(user), forKey: "ehealth_user")
    }
    
    static func load() -> User? {
        let defaults = UserDefaults.standard
        
        if let encoded = defaults.data(forKey: "ehealth_user") {
            return try? JSONDecoder().decode(User.self, from:encoded)
        }
        
        return nil
    }
    
    
}
