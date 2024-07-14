//
//  GameSet.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import Foundation
import SwiftData

@Model
class GameSet {
    var game: Game?
    @Relationship(deleteRule: .cascade, inverse: \Scoreboard.gameSet)
    var scoreboard: Scoreboard?
    var winner: Team?
    var winnerScore: Int
    var startTime: Date
    var endTime: Date?
    var isFinished = false
    var name: String
    
    init(startTime: Date? = nil, winnerScore: Int = 15, setNumber: Int) {
        self.startTime = startTime ?? .now
        self.winnerScore = winnerScore
        self.name = "Set \(setNumber)"
    }
    
    var teamA: Team? {
        self.game?.teamA
    }
    
    var teamB: Team? {
        self.game?.teamB
    }
    
    @discardableResult
    func addScoreboard(context: ModelContext) -> Scoreboard {
        let scoreboard = Scoreboard(winnerScore: self.winnerScore)
        context.insert(scoreboard)
        self.scoreboard = scoreboard
        return scoreboard
    }

    func finish() {
        self.endTime = .now
        self.winner = self.scoreboard!.teamAScore > self.scoreboard!.teamBScore
            ? self.game!.teamA : self.scoreboard!.teamAScore < self.scoreboard!.teamBScore
            ? self.game!.teamB : nil
        self.isFinished = true
    }
    
    func reopen() {
        self.endTime = nil
        self.winner = nil
        self.isFinished = false
    }
}