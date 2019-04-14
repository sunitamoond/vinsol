//
//  Schedule.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import Foundation

struct Schedule: Codable {
    var startTime: String
    var endTime: String
    var description: String
    var participants: [String]

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case description = "description"
        case participants = "participants"
    }
}

extension Schedule {

    init(startTime: String, endTime: String, description: String, participants: String) {
        self.startTime = startTime;
        self.endTime = endTime
        self.description = description;
        self.participants = participants.components(separatedBy: ", ");
    }
}
