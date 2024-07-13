//
//  ScoreView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 10/07/24.
//

import SwiftUI

struct ScoreView: View {
    var addPointToTeam: () -> ()
    var removePointFromTeam: () -> ()
    var isFinished: Bool
    var teamScore: Int
    
    var body: some View {
        VStack {
            Button(action: addPointToTeam, label: {
                Text("+").frame(maxWidth: .infinity)
            }).disabled(isFinished)
                .buttonStyle(.borderedProminent)
            Text(String(teamScore)).font(.title).padding()
            Button(action: removePointFromTeam, label: {
                Text("-").frame(maxWidth: .infinity)
            }).disabled(teamScore == 0 || isFinished)
                .buttonStyle(.bordered)
        }.padding()
    }
}
