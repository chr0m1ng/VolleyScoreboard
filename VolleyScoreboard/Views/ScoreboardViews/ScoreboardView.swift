//
//  ScoreboardView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 05/07/24.
//

import SwiftUI
import SwiftData

struct ScoreboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Bindable var scoreboard: Scoreboard
    @State private var flipTeams = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Section {
                            Text(teams.first!.name).font(.title)
                                .animation(.easeInOut(duration: 0.5), value: teams.first!.name)
                        }.frame(maxWidth: .infinity)
                        VStack {
                            Button{
                                flipTeams.toggle()
                            } label: {
                                Image(systemName: "arrow.left.arrow.right").font(.title)
                            }
                        }
                        Section {
                            Text(teams.last!.name).font(.title)
                                .animation(.easeInOut(duration: 0.5), value: teams.last!.name)
                        }.frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity).padding(.vertical)
                    getScoreViews()
                    Spacer()
                    HStack {
                        if scoreboard.gameSet!.isFinished {
                            Button(action: scoreboard.gameSet!.reopen, label: {
                                Text("Reabrir Set").frame(maxWidth: .infinity)
                            })
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .padding()
                        } else {
                            Button(role: .destructive, action: finishSet, label: {
                                Text("Finalizar Set").frame(maxWidth: .infinity)
                            }).disabled(!self.scoreboard.canFinishSet || self.scoreboard.gameSet!.isFinished)
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .padding()
                        }
                    }.padding().frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
            }
            .padding(.top)
            .navigationTitle(scoreboard.gameSet!.name)
        }.onAppear(perform: self.scoreboard.updateAppleWatchApp)
    }
    
    var teams: [Team] {
        flipTeams
        ? [scoreboard.teamB, scoreboard.teamA]
        : [scoreboard.teamA, scoreboard.teamB]
    }
    
    func getScoreViews() -> some View {
        var scoreViews = [
            ScoreView(addPointToTeam: addPointToA, removePointFromTeam: removePointFromA, isFinished: scoreboard.gameSet!.isFinished, teamScore: scoreboard.teamAScore),
            ScoreView(addPointToTeam: addPointToB, removePointFromTeam: removePointFromB, isFinished: scoreboard.gameSet!.isFinished, teamScore: scoreboard.teamBScore)
        ]
        if flipTeams {
            scoreViews.reverse()
        }
        return HStack {
            scoreViews.first!
            scoreViews.last!
        }.frame(maxWidth: .infinity)
    }
    
    func canRemoveScore(score: Int) -> Bool {
        return score == 0 || self.scoreboard.gameSet!.isFinished
    }
    
    func finishSet() {
        withAnimation {
            self.scoreboard.gameSet!.finish()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func addPointToA() {
        withAnimation {
            self.scoreboard.addPointToA(context: modelContext)
        }
    }
    
    func removePointFromA() {
        withAnimation {
            self.scoreboard.removePointFromA(context: modelContext)
        }
    }
    
    func addPointToB() {
        withAnimation {
            self.scoreboard.addPointToB(context: modelContext)
        }
    }
    
    func removePointFromB() {
        withAnimation {
            self.scoreboard.removePointFromB(context: modelContext)
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
    return ScoreboardView(scoreboard: previewer.scoreboard)
        .modelContainer(previewer.container)
}
