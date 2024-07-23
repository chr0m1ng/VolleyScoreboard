//
//  WatchConnectivityManager.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 14/07/24.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityManager()
    var session: WCSession
    var lastScoreboardStatus = ScoreboardStatus()
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["request"] as! String == "score" {
            replyHandler(lastScoreboardStatus.serialize())
        }
    }
    
    private func updateApplicationContext(with context: [String: Any]) {
        do {
            try self.session.updateApplicationContext(context)
        } catch {
            print("Updating of application context failed \(error)")
        }
    }
    
    func sendScoreboardStatusToWatch(scoreboardStatus: ScoreboardStatus) {
        lastScoreboardStatus.updateFromDeserializedData(scoreboardStatus)
        if session.isReachable {
            let update = scoreboardStatus.serialize()
            updateApplicationContext(with: update)
        } else {
            print("Session not reachable")
        }
    }
}
