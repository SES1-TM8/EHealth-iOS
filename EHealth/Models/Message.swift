//
//  Message.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

struct Message: Decodable {
    var id: Int
    var userId: Int
    var groupId: Int
    var content: String
    var timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case id = "messageId"
        case userId
        case groupId = "messageGroupId"
        case content
        case timestamp
    }
}

struct MessageGroup: Codable {
    var id: Int
    var name: String?
    var direct: Bool
    var timestamp: String
    var members: [User]
    var appointmentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "messageGroupId"
        case name
        case direct
        case timestamp
        case members
        case appointmentId
    }
}

struct MessageGroupCombined: Codable {
    var group: MessageGroup
    var appointmentId: Int
    
    enum CodingKeys: String, CodingKey {
        case group
        case appointmentId
    }
}

extension MessageGroupCombined {
    static func save(combined: MessageGroupCombined) {
        guard let data = try? JSONEncoder().encode(combined) else { return }
        UserDefaults.standard.set(data, forKey: "ehealth_combined_\(combined.appointmentId)")
    }
    
    static func load(appointmentId: Int) -> MessageGroupCombined? {
        let defaults = UserDefaults.standard
        
        if let model = try? JSONDecoder().decode(MessageGroupCombined.self, from: defaults.data(forKey: "ehealth_combined_\(appointmentId)") ?? Data()) {
            return model
        }
        
        return nil
    }
}
