//
//  ScoreboardContext.swift
//  VolleyScoreboardWidgetExtensionExtension
//
//  Created by Gabriel Santos on 13/07/24.
//

import Foundation
import ActivityKit

struct ScoreboardContext: ActivityAttributes {
    
    struct ContentState: Codable, Hashable {
        let teamAScore: Int
        let teamBScore: Int
    }
    
    let teamAName: String
    let teamBName: String
}
