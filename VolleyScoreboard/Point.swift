//
//  Point.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import Foundation
import SwiftData

@Model
class Point {
    var timestamp: Date
    var team: Team?
    
    init(timestamp: Date? = nil) {
        self.timestamp = timestamp ?? .now
    }
}
