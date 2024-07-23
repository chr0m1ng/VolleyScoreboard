//
//  ScoreboardStatus.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 14/07/24.
//

import Foundation

class ScoreboardStatus {
    static let shared = ScoreboardStatus()
    
    var teamAName: String = "Team A"
    var teamAScore: Int = 0
    var teamBName: String = "Team B"
    var teamBScore: Int = 0
    
    func serialize() -> [String: Any] {
        return [
            "teamAName": self.teamAName,
            "teamAScore": self.teamAScore,
            "teamBName": self.teamBName,
            "teamBScore": self.teamBScore
        ]
    }
    
    func updateFromSerializedData(_ data: [String: Any]) {
        self.teamAName = data["teamAName"] as! String
        self.teamAScore = data["teamAScore"] as! Int
        self.teamBName = data["teamBName"] as! String
        self.teamBScore = data["teamBScore"] as! Int
    }
    
    func updateFromDeserializedData(_ data: ScoreboardStatus) {
        self.teamAName = data.teamAName
        self.teamAScore = data.teamAScore
        self.teamBName = data.teamBName
        self.teamBScore = data.teamBScore
    }
}
