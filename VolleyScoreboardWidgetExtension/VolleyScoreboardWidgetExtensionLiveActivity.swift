//
//  VolleyScoreboardWidgetExtensionLiveActivity.swift
//  VolleyScoreboardWidgetExtension
//
//  Created by Gabriel Santos on 13/07/24.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct VolleyScoreboardWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScoreboardContext.self) { context in
            // Lock screen/banner UI goes here
            ScoreboardLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion (.leading) {
                    VStack {
                        Text(context.attributes.teamAName).font(.title)
                        Text(String(context.state.teamAScore)).font(.title2)
                            .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: context.state.teamAScore)
                    }.frame(maxWidth: .infinity)
                }
                DynamicIslandExpandedRegion (.center) {
                    Image(systemName: "volleyball.fill").font(.title)
                }
                DynamicIslandExpandedRegion (.trailing) {
                    VStack {
                        Text(context.attributes.teamBName).font(.title)
                        Text(String(context.state.teamBScore)).font(.title2)
                            .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: context.state.teamBScore)
                    }.frame(maxWidth: .infinity)
                }
            } compactLeading: {
                Text("\(context.attributes.teamAName.first!) - \(context.state.teamAScore)")
            } compactTrailing: {
                Text("\(context.state.teamBScore) - \(context.attributes.teamBName.first!)")
            } minimal: {
                Image(systemName: "volleyball.fill")
            }
        }
    }
}

struct LiveActivitiesPreviewProvider: PreviewProvider {
    static let activityAttributes = ScoreboardContext(teamAName: "Team A", teamBName: "Team B")
    
    static let state = ScoreboardContext.ContentState(teamAScore: 1, teamBScore: 2)
    
    static var previews: some View {
        activityAttributes
            .previewContext(state, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Compact")
        
        activityAttributes
            .previewContext(state, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Expanded")
        
        activityAttributes
            .previewContext(state, viewKind: .content)
            .previewDisplayName("Notification")
        
        activityAttributes
            .previewContext(state, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")

    }
}
