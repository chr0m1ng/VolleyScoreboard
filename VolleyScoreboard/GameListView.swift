//
//  GameListView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 03/07/24.
//

import SwiftUI
import SwiftData

struct GameListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Game.startDate, order: .reverse) private var games: [Game]
    @Query(sort: \Team.name) private var teams: [Team]
    @State private var isPresented = false
    @Binding var tabSelection: Int

    var body: some View {
        NavigationStack {
            List {
                ForEach(games, id:\.id) { game in
                    NavigationLink {
                        GameSetListView(game: Bindable(game))
                    } label: {
                        HStack (alignment: .center) {
                            HStack {
                                Label("", systemImage: game.isFinished ? "volleyball.fill" : "volleyball")
                            }
                            VStack(alignment: .listRowSeparatorLeading) {
                                HStack {
                                    Text(game.teamA.name).frame(maxWidth: .infinity, alignment: .leading).bold(game.winner == game.teamA)
                                    Text("\(game.score.teamA)").frame(maxWidth: .infinity, alignment: .trailing).bold(game.winner == game.teamA)
                                }
                                Divider()
                                HStack {
                                    Text(game.teamB.name).frame(maxWidth: .infinity, alignment: .leading).bold(game.winner == game.teamB)
                                    Text("\(game.score.teamB)").frame(maxWidth: .infinity, alignment: .trailing).bold(game.winner == game.teamB)
                                }
                            }
                            Divider()
                            HStack {
                                Label("", systemImage: game.isFinished ? "stopwatch.fill" : "stopwatch").font(.caption)
                                if game.isFinished {
                                    VStack {
                                        Text("\(game.startDate.printableString(.medium, .none))").font(.caption)
                                        Text("\(game.startDate.printableString(.none, .short))").font(.caption)
                                        Text("\(game.endDate!.printableString(.none, .short))").font(.caption)
                                    }
                                } else {
                                    Text("\(game.startDate.printableString())").font(.caption)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteGame)
            }
            .overlay(VStack {
                if isNewGameDisabled {
                    Image(systemName: "list.bullet.rectangle.portrait").imageScale(.large)
                    Text("Você precisa adicionar 2 times para iniciar um jogo").padding().font(.title)
                    Button("Adicionar times", action: { tabSelection = 2 }).padding()
                }
                if games.isEmpty && !isNewGameDisabled {
                    Image(systemName: "list.bullet.rectangle.portrait").imageScale(.large)
                    Text("Nenhum jogo iniciado").padding().font(.title)
                    Button("Novo jogo", action: { isPresented.toggle() }).padding()
                }
            })
            .listRowSpacing(10)
            .toolbar {
                ToolbarItem {
                    Button(action: { isPresented.toggle() }) {
                        Label("Novo jogo", systemImage: "plus")
                    }.disabled(isNewGameDisabled)
                }
            }
            .newGameSheet(isPresented: $isPresented)
            .navigationTitle("Jogos")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    
    var isNewGameDisabled: Bool {
        teams.count < 2
    }

    private func deleteGame(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                // SwiftData is not updating the team.games so this remove the game manually
                for team in games[index].teams {
                    let gameIndex = team.games.firstIndex(where: { $0.id == games[index].id })
                    team.games.remove(at: gameIndex!)
                }
                modelContext.delete(games[index])
            }
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
    @State var tabSelection = 1
    return GameListView(tabSelection: $tabSelection)
        .modelContainer(previewer.container)
    
}
