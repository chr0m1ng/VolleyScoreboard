//
//  ContentView.swift
//  VolleyScoreboardWatch Watch App
//
//  Created by Gabriel Santos on 14/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var teamAName: String = ""
    @State var teamAScore: Int = 0
    @State var teamBName: String = ""
    @State var teamBScore: Int = 0
    @StateObject var connectivityManager = WatchConnectivityManager()

    var body: some View {
        HStack {
            VStack {
                Text(teamAName).font(.headline).bold()
                Text(String(teamAScore)).font(.headline)
                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: teamAScore)
            }.frame(maxWidth: .infinity)
            Image(systemName: "volleyball.fill").font(.title).padding(.horizontal)
            VStack {
                Text(teamBName).font(.headline).bold()
                Text(String(teamBScore)).font(.headline)
                    .contentTransition(.numericText()).animation(.spring(duration: 0.2), value: teamBScore)
            }.frame(maxWidth: .infinity)
        }.padding()
        .onAppear(){
            self.connectivityManager.scoreboardUpdateHandler = handleScoreUpdate
            connectivityManager.requestScoreboard()
        }.onTapGesture {
            connectivityManager.requestScoreboard()
        }
    }
    
    func handleScoreUpdate(_ scoreboardStatus: ScoreboardStatus) {
        self.teamAName = scoreboardStatus.teamAName
        self.teamAScore = scoreboardStatus.teamAScore
        self.teamBName = scoreboardStatus.teamBName
        self.teamBScore = scoreboardStatus.teamBScore
    }
}

#Preview {
    ContentView()
}
