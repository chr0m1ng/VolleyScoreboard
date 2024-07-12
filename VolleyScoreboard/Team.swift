//
//  Team.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import Foundation
import SwiftData

struct Leaderboard {
    var playedGames: Int
    var wins: Int
    var loses: Int
    var ties: Int
    var playedSets: Int
    var setWins: Int
    var setLoses: Int
}

@Model
class Team {
    @Attribute(.unique) 
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Game.teams)
    var games = [Game]()

    init(name: String) {
        self.name = name
    }
    
    func getPlayedSets(_ startDate: Date?, _ endDate: Date?) -> Int {
        return self.getPlayedGames(startDate, endDate).reduce(0, {acc, game in acc + game.sets.count})
    }
    
    func getSetWins(_ startDate: Date?, _ endDate: Date?) -> Int {
        return self.getPlayedGames(startDate, endDate).reduce(0, {acc, game in
            game.teamA == self
            ? acc + game.score.teamA
            : acc + game.score.teamB
        })
    }
    
    func getSetLoses(_ startDate: Date?, _ endDate: Date?) -> Int {
        return self.getPlayedSets(startDate, endDate) - self.getSetWins(startDate, endDate)
    }
    
    func getPlayedGames(_ startDate: Date?, _ endDate: Date?) -> [Game] {
        let calendar = Calendar.autoupdatingCurrent
        if startDate != nil && endDate != nil {
            return games.filter({
                calendar.startOfDay(for: $0.startDate) >= calendar.startOfDay(for: startDate!)
                && calendar.startOfDay(for: $0.startDate) <= endDate!
            })
        }
        return games
    }
    
    func getWins(_ startDate: Date?, _ endDate: Date?) -> Int {
        return self.getPlayedGames(startDate, endDate).filter({$0.winner == self}).count
    }
    
    func getPlayedGamesCount(_ startDate: Date?, _ endDate: Date?) -> Int {
        return self.getPlayedGames(startDate, endDate).filter({$0.isFinished}).count
    }
    
    func getLoses(_ startDate: Date?, _ endDate: Date?) -> Int {
        return self.getPlayedGames(startDate, endDate).filter({$0.isFinished && $0.winner != nil && $0.winner != self}).count
    }
    
    func getTies(_ startDate: Date?, _ endDate: Date?) -> Int {
        return self.getPlayedGamesCount(startDate, endDate) - self.getWins(startDate, endDate) - self.getLoses(startDate, endDate)
    }
    
    func getLeaderboard(_ startDate: Date?, _ endDate: Date?) -> Leaderboard {
        return Leaderboard(
            playedGames: getPlayedGamesCount(startDate, endDate),
            wins: getWins(startDate, endDate),
            loses: getLoses(startDate, endDate),
            ties: getTies(startDate, endDate),
            playedSets: getPlayedSets(startDate, endDate),
            setWins: getSetWins(startDate, endDate),
            setLoses: getSetLoses(startDate, endDate)
        )
    }
}
