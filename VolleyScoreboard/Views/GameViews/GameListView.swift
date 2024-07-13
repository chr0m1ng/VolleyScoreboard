//
//  GameListView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 03/07/24.
//

import SwiftUI
import SwiftData

struct GameListView: View {
    @Environment(\.modelContext)
    private var modelContext
    @Query(sort: \Game.startDate, order: .reverse)
    private var games: [Game]
    @Query(sort: \Team.name) 
    private var teams: [Team]
    @State private var isPresented = false
    @State private var filterStartDate: Date = .now
    @State private var filterEndDate: Date = .now
    @State private var isFiltering = false
    @Binding var tabSelection: Int

    var body: some View {
        NavigationStack {
            List {
                if isFiltering {
                    HStack {
                        DatePicker("De", selection: $filterStartDate, displayedComponents: .date)
                            .labelsHidden()
                            .onChange(of: filterStartDate){
                                if filterStartDate > filterEndDate {
                                    filterEndDate = filterStartDate
                                }
                            }
                        Image(systemName: "arrow.right")
                        DatePicker("Até", selection: $filterEndDate, displayedComponents: .date)
                            .labelsHidden()
                    }.listRowBackground(Color.clear)
                }
                ForEach(filteredGames, id:\.id) { game in
                    NavigationLink {
                        GameSetListView(game: game)
                    } label: {
                        GameListItemView(game: game)
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
                    Button(action: toogleDateFilter){
                        Label("Filtrar", systemImage: isFiltering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
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
    
    private var filteredGames: [Game] {
        games.filter(filterGameByDate)
    }
    
    private func toogleDateFilter() {
        isFiltering.toggle()
        if !isFiltering {
            filterStartDate = .now
            filterEndDate = .now
        }
    }
    
    private func filterGameByDate(game: Game) -> Bool {
        if !isFiltering {
            return true
        }
        let calendar = Calendar.autoupdatingCurrent
        return calendar.startOfDay(for: game.startDate) >= calendar.startOfDay(for: filterStartDate) 
            && calendar.startOfDay(for: game.startDate) <= filterEndDate
        
    }
    
    private var isNewGameDisabled: Bool {
        teams.count < 2
    }

    private func deleteGame(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let fixedIndex = games.firstIndex(where: {$0.id == filteredGames[index].id })!
                // SwiftData is not updating the team.games so this remove the game manually
                for team in games[fixedIndex].teams {
                    let teamGameIndex = team.games.firstIndex(where: { $0.id == games[fixedIndex].id })
                    team.games.remove(at: teamGameIndex!)
                }
                modelContext.delete(games[fixedIndex])
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
