//
//  Session.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import Foundation

struct Session: Codable {
    
    var id: Int
    var token: String
    var expiry: Int
    var userId: Int
    var firebase: String
    
    enum CodingKeys: String, CodingKey {
        case id = "sessionId"
        case token
        case expiry
        case userId
        case firebase = "firebaseToken"
    }
    
}

extension Session {
    static func save(session: Session){
        let defaults = UserDefaults.standard
        
        defaults.set(try? JSONEncoder().encode(session), forKey: "ehealth_session")
    }
    
    static func load() -> Session? {
        let defaults = UserDefaults.standard
        
        if let encoded = defaults.data(forKey: "ehealth_session") {
            if let session = try? JSONDecoder().decode(Session.self, from: encoded) {
                if Date(timeIntervalSince1970: Double(session.expiry / 1000)) > Date() {
                    return session
                }
            }
        }
        
        return nil
    }
    
    
}
