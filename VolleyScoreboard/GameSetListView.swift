//
//  GameSetListView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 05/07/24.
//

import SwiftUI
import SwiftData

struct GameSetListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var game: Game
    
    init(game: Bindable<Game>){
        self._game = game
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(game.sets.sorted(using: SortDescriptor(\GameSet.name)), id:\.id) { set in
                    NavigationLink {
                        ScoreboardView(scoreboard: set.scoreboard!)
                    } label: {
                        HStack (alignment: .center) {
                            if set.isFinished {
                                HStack {
                                    Label("", systemImage: "volleyball.fill" )
                                }
                            }
                            VStack(alignment: .listRowSeparatorLeading) {
                                HStack {
                                    Text(game.teamA.name).frame(maxWidth: .infinity, alignment: .leading).bold(set.winner == game.teamA)
                                    Text("\(set.scoreboard!.teamAScore)").frame(maxWidth: .infinity, alignment: .trailing).bold(set.winner == game.teamA)
                                }
                                Divider()
                                HStack {
                                    Text(game.teamB.name).frame(maxWidth: .infinity, alignment: .leading).bold(set.winner == game.teamB)
                                    Text("\(set.scoreboard!.teamBScore)").frame(maxWidth: .infinity, alignment: .trailing).bold(set.winner == game.teamB)
                                }
                            }
                            Divider()
                            VStack (alignment: .leading) {
                                Text(set.name).font(.title3).bold().padding(.vertical)
                                HStack (alignment: .center) {
                                    Label("", systemImage: set.isFinished ? "stopwatch.fill" : "stopwatch").font(.caption2)
                                    VStack {
                                        Text("\(set.startTime.printableString(.none, .short))").font(.caption)
                                        if set.isFinished {
                                            Text("\(set.endTime!.printableString(.none, .short))").font(.caption)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .overlay(VStack {
                if self.game.sets.isEmpty {
                    Image(systemName: "list.bullet.rectangle.portrait").imageScale(.large)
                    Text("Nenhum set iniciado").padding().font(.title)
                    Button("Novo set", action: createGameSet).padding()
                }
            })
            .listRowSpacing(10)
            .toolbar {
                ToolbarItem {
                    Button(action: createGameSet) {
                        Label("Novo set", systemImage: "plus")
                    }.disabled(self.game.isFinished)
                }
            }
            .navigationTitle("Sets")
            .navigationBarTitleDisplayMode(.large)
            if game.isFinished {
                Button(action: game.reopen, label: {
                    Text("Reabrir Jogo")
                }).buttonStyle(.borderedProminent).padding(.bottom)
            } else {
                Button(role: .destructive, action: finishGame, label: {
                    Text("Finalizar Jogo")
                }).buttonStyle(.borderedProminent).disabled(self.game.sets.isEmpty || self.game.isFinished).padding(.bottom)
            }
        }
    }
    
    func createGameSet() {
        self.game.addGameSet(context: modelContext)
    }
    
    func finishGame() {
        withAnimation {
            for set in self.game.sets {
                if !set.isFinished {
                    set.finish()
                }
            }
            self.game.finish()
            dismiss()
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
    return GameSetListView(game: Bindable(previewer.game))
        .modelContainer(previewer.container)
}
