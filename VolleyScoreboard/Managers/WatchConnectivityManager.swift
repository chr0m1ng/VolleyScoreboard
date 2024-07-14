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
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    private func updateApplicationContext(with context: [String: Any]) {
        do {
            try self.session.updateApplicationContext(context)
        } catch {
            print("Updating of application context failed \(error)")
        }
    }
    
    func sendScoreboardStatusToWatch(scoreboardStatus: ScoreboardStatus) {
        if session.isReachable {
            updateApplicationContext(with: scoreboardStatus.toApplicationContext())
        } else {
            print("Session not reachable")
        }
    }
}
