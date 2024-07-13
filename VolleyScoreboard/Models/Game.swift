//
//  Game.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import Foundation
import SwiftData

struct FinalScore {
    var teamA: Int
    var teamB: Int
}

@Model
class Game {
    @Relationship(deleteRule: .cascade, inverse: \GameSet.game)
    var sets = [GameSet]()
    @Relationship
    var teams = [Team]()
    var startDate: Date
    var endDate: Date?
    var isFinished = false
    var setWinnerScore: Int
    var winner: Team?
    
    init(startDate: Date? = nil, setWinnerScore: Int = 15) {
        self.startDate = startDate ?? .now
        self.setWinnerScore = setWinnerScore
    }
    
    @discardableResult
    func addGameSet(context: ModelContext) -> GameSet {
        let gameSet = GameSet(winnerScore: self.setWinnerScore, setNumber: self.sets.count + 1)
        context.insert(gameSet)
        self.sets.append(gameSet)
        gameSet.addScoreboard(context: context)
        return gameSet
    }
    
    func finish() {
        self.endDate = .now
        self.isFinished = true
        self.winner = score.teamA > score.teamB ? self.teamA : score.teamA < score.teamB ? self.teamB : nil
    }
    
    func reopen() {
        self.endDate = nil
        self.isFinished = false
        self.winner = nil
    }
    
    var score: FinalScore {
        let teamAWins = self.sets.filter({ $0.winner == self.teamA }).count
        let teamBWins = self.sets.filter({ $0.winner == self.teamB }).count
        return FinalScore(teamA: teamAWins, teamB: teamBWins)
    }
    
    var teamA: Team {
        self.teams.sorted(using: SortDescriptor(\.name)).first!
    }
    
    var teamB: Team {
        self.teams.sorted(using: SortDescriptor(\.name)).last!
    }
}
