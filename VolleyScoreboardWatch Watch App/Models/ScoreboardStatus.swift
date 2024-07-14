//
//  ScoreboardStatus.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 14/07/24.
//

import Foundation

struct ScoreboardStatus {
    let teamAName: String
    let teamAScore: Int
    let teamBName: String
    let teamBScore: Int
    
    func toApplicationContext() -> [String: Any] {
        return [
            "teamAName": self.teamAName,
            "teamAScore": self.teamAScore,
            "teamBName": self.teamBName,
            "teamBScore": self.teamBScore
        ]
    }
    
    static func fromApplicationContext(_ applicationContext: [String: Any]) -> ScoreboardStatus {
        return ScoreboardStatus(
            teamAName: applicationContext["teamAName"] as! String,
            teamAScore: applicationContext["teamAScore"] as! Int,
            teamBName: applicationContext["teamBName"] as! String,
            teamBScore: applicationContext["teamBScore"] as! Int
        )
    }
}
