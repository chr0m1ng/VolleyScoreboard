//
//  VolleyScoreboardApp.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 03/07/24.
//

import SwiftUI
import SwiftData

@main
struct VolleyScoreboardApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Game.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(sharedModelContainer)
    }
}
