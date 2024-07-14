//
//  WatchConnectivityManager.swift
//  VolleyScoreboardWatch Watch App
//
//  Created by Gabriel Santos on 14/07/24.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
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
        if scoreboardUpdateHandler != nil {
            self.scoreboardUpdateHandler!(ScoreboardStatus.fromApplicationContext(applicationContext))
        }
    }
}
