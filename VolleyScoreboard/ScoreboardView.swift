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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack (alignment: .lastTextBaseline) {
                        Section {
                            Text(self.scoreboard.teamA.name).font(.title)
                        }.frame(maxWidth: .infinity)
                        VStack {
                            Image(systemName: "flag.2.crossed").font(.system(size: 30))
                        }
                        Section {
                            Text(self.scoreboard.teamB.name).font(.title)
                        }.frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity).padding(.vertical)
                    HStack {
                        VStack {
                            Button(action: addPointToA, label: {
                                Text("+").frame(maxWidth: .infinity)
                            }).disabled(self.scoreboard.gameSet!.isFinished)
                                .buttonStyle(.borderedProminent)
                            Text(String(self.scoreboard.teamAScore)).font(.title).padding()
                            Button(action: removePointFromA, label: {
                                Text("-").frame(maxWidth: .infinity)
                            }).disabled(self.scoreboard.teamAScore == 0 || self.scoreboard.gameSet!.isFinished)
                                .buttonStyle(.bordered)
                        }.padding()
                        VStack {
                            Button(action: addPointToB, label: {
                                Text("+").frame(maxWidth: .infinity)
                            }).disabled(self.scoreboard.gameSet!.isFinished)
                                .buttonStyle(.borderedProminent)
                            Text(String(self.scoreboard.teamBScore)).font(.title).padding()
                            Button(action: removePointFromB, label: {
                                Text("-").frame(maxWidth: .infinity)
                            }).disabled(self.scoreboard.teamBScore == 0 || self.scoreboard.gameSet!.isFinished)
                                .buttonStyle(.bordered)
                        }.padding()
                    }.frame(maxWidth: .infinity)
                    Spacer()
                    HStack {
                        Button(action: finishSet, label: {
                            Text("Finalizar Set").frame(maxWidth: .infinity)
                        }).disabled(!self.scoreboard.canFinishSet || self.scoreboard.gameSet!.isFinished)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .padding()
                    }.padding().frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
            }
            .padding(.top)
            .navigationTitle(scoreboard.gameSet!.name)
        }
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
