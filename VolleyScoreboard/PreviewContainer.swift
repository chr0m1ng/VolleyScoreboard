//
//  PreviewContainer.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 07/07/24.
//

import Foundation
import SwiftData

@MainActor
struct PreviewContainer {
    let scoreboard: Scoreboard
    let game: Game
    let gameSet: GameSet
    let container: ModelContainer
    
    init() throws {
        let schema = Schema([
            Game.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        container = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let teams = [Team(name: "Time nome grande"), Team(name: "Test 2")]
        for team in teams {
            container.mainContext.insert(team)
        }
        
        game = Game()
        container.mainContext.insert(game)
        game.teams.append(contentsOf: teams)
        gameSet = game.addGameSet(context: container.mainContext)
        scoreboard = gameSet.scoreboard!
    }
}


