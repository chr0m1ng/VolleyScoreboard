//
//  Scoreboard.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import Foundation
import SwiftData

@Model
class Scoreboard {
    @Relationship(deleteRule: .cascade)
    var points = [Point]()
    var gameSet: GameSet?
    var winnerScore: Int
    
    init(winnerScore: Int) {
        self.winnerScore = winnerScore
    }
    
    var canFinishSet: Bool {
        max(self.teamAScore, self.teamBScore) >= self.winnerScore
    }
    
    var teamA: Team {
        self.gameSet!.game!.teamA
    }
    
    var teamB: Team {
        self.gameSet!.game!.teamB
    }
    
    func getTeamPoints(team: Team) -> [Point] {
        return self.points.filter({ $0.team == team }).sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    var teamAPoints: [Point] {
        self.getTeamPoints(team: self.teamA)
    }
    
    var teamBPoints: [Point] {
        self.getTeamPoints(team: self.teamB)
    }
    
    var teamAScore: Int {
        get { return teamAPoints.count }
    }
    var teamBScore: Int {
        get { return teamBPoints.count }
    }

    private func addTeamPoint(team: Team, context: ModelContext) {
        let point = Point()
        context.insert(point)
        point.team = team
        self.points.append(point)
        
        if self.teamAScore == self.teamBScore && self.teamAScore == self.winnerScore - 1 {
            self.winnerScore += 1
        }
    }

    func addPointToA(context: ModelContext) {
        addTeamPoint(team: self.teamA, context: context)
    }

    func addPointToB(context: ModelContext) {
        addTeamPoint(team: self.teamB, context: context)
    }

    private func removePointFromTeam(teamPoints: [Point], context: ModelContext) {
        let pointId: PersistentIdentifier = teamPoints.last!.id
        context.delete(self.points.remove(at: self.points.firstIndex(where: { $0.id == pointId })!))
    }

    func removePointFromA(context: ModelContext) {
        removePointFromTeam(teamPoints: teamAPoints, context: context)
    }

    func removePointFromB(context: ModelContext) {
        removePointFromTeam(teamPoints: teamBPoints, context: context)
    }
}