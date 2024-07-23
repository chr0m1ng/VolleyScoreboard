//
//  WatchConnectivityManager.swift
//  VolleyScoreboardWatch Watch App
//
//  Created by Gabriel Santos on 14/07/24.
//

import Foundation
import WatchConnectivity
import ClockKit
import WidgetKit

final class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityManager()
    var scoreboardUpdateHandler: ((_ status: ScoreboardStatus) -> ())? = nil
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("[watch] didReceiveApplicationContext")
        if scoreboardUpdateHandler != nil {
            ScoreboardStatus.shared.updateFromSerializedData(applicationContext)
            self.scoreboardUpdateHandler!(ScoreboardStatus.shared)
        }
    }
    
    private func handleScoreUpdate(_ update: [String: Any]) {
        ScoreboardStatus.shared.updateFromSerializedData(update)
        if scoreboardUpdateHandler != nil {
            self.scoreboardUpdateHandler!(ScoreboardStatus.shared)
        }
    }
    
    func requestScoreboard() {
        self.session.sendMessage(["request": "score"], replyHandler: handleScoreUpdate)
    }
}
