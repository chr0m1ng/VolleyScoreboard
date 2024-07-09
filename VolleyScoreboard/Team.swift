//
//  Team.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import Foundation
import SwiftData

@Model
class Team {
    @Attribute(.unique) 
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Game.teams)
    var games = [Game]()

    init(name: String) {
        self.name = name
    }
    
    var wins: Int {
        self.games.filter({$0.winner == self}).count
    }
    
    var playedGames: Int {
        self.games.filter({$0.isFinished}).count
    }
    
    var loses: Int {
        self.games.filter({$0.isFinished && $0.winner != nil && $0.winner != self}).count
    }
    
    var ties: Int {
        self.playedGames - self.wins - self.loses
    }
}
