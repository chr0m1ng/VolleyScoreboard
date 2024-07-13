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

    var body: some View {
        NavigationStack {
            List {
                ForEach(game.sets.sorted(using: SortDescriptor(\GameSet.name)), id:\.id) { set in
                    NavigationLink {
                        ScoreboardView(scoreboard: set.scoreboard!)
                    } label: {
                        GameSetListItemView(set: set)
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
    return GameSetListView(game: previewer.game)
        .modelContainer(previewer.container)
}
