//
//  ScoreboardLiveActivityView.swift
//  VolleyScoreboardWidgetExtensionExtension
//
//  Created by Gabriel Santos on 13/07/24.
//

import SwiftUI
import WidgetKit

struct ScoreboardLiveActivityView: View {
    let context: ActivityViewContext<ScoreboardContext>
   
    var body: some View {
        HStack {
            VStack {
                Text(context.attributes.teamAName).font(.title2).bold()
                Text(String(context.state.teamAScore)).font(.title3)
                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: context.state.teamAScore)
            }.frame(maxWidth: .infinity)
            Image(systemName: "volleyball.fill").font(.title).padding(.horizontal)
            VStack {
                Text(context.attributes.teamBName).font(.title2).bold()
                Text(String(context.state.teamBScore)).font(.title3)
                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: context.state.teamBScore)
            }.frame(maxWidth: .infinity)
        }.padding()
    }
}

#Preview(as: .content, using: ScoreboardContext(teamAName: "Team A", teamBName: "Team B")) {
    VolleyScoreboardWidgetLiveActivity()
} contentStates: {
    ScoreboardContext.ContentState(teamAScore: 1, teamBScore: 2)
}
