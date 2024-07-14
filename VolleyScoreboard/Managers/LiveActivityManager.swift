//
//  LiveActivityManager.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 13/07/24.
//

import Foundation
import ActivityKit

final class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var scoreActivity: Activity<ScoreboardContext>? = nil

    func start(teamAName: String, teamAScore: Int, teamBName: String, teamBScore: Int, relevanceScore: Double = 1.0) {
        let scoreAttributes = ScoreboardContext(teamAName: teamAName, teamBName: teamBName)
        let currentState = ScoreboardContext.ContentState(teamAScore: teamAScore, teamBScore: teamBScore)
        let content = ActivityContent(state: currentState, staleDate: nil, relevanceScore: relevanceScore)
        do {
            scoreActivity = try Activity.request(
                attributes: scoreAttributes,
                content: content,
                pushType: nil
            )
        } catch {
            print(error)
        }
    }
    
    func update(teamAScore: Int, teamBScore: Int) async {
        await scoreActivity?.update(
            ActivityContent<ScoreboardContext.ContentState>(
                state: ScoreboardContext.ContentState(teamAScore: teamAScore, teamBScore: teamBScore),
                staleDate: nil
            )
        )
    }
    
    func end(teamAScore: Int, teamBScore: Int) async {
        let currentState = ScoreboardContext.ContentState(teamAScore: teamAScore, teamBScore: teamBScore)
        let content = ActivityContent(state: currentState, staleDate: nil)
        await scoreActivity?.end(content, dismissalPolicy: .immediate)
    }
}
