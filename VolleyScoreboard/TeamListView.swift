//
//  TeamListView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import SwiftUI
import SwiftData

struct TeamListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Team.name) private var teams: [Team]
    @State private var teamName = ""
    @State private var isNewTeamPresented = false
    @State private var isEditTeamPresented = false
    @State private var selectedTeam: Team?
    @State private var filterStartDate: Date = .now
    @State private var filterEndDate: Date = .now
    @State private var isFiltering = false
    
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
                ForEach(filteredTeams, id: \.name) { team in
                    TeamListItemView(team: team, filterStartDate: $filterStartDate, filterEndDate: $filterEndDate, isFiltering: $isFiltering)
                    .onTapGesture {
                        selectedTeam = team
                        teamName = team.name
                        isEditTeamPresented.toggle()
                    }
                }
                .onDelete(perform: deleteTeam)
            }
            .listRowSpacing(10)
            .overlay(VStack {
                if teams.isEmpty {
                    Image(systemName: "list.bullet.rectangle.portrait").imageScale(.large)
                    Text("Nenhum time adicionado").padding().font(.title)
                    Button("Adicione um time", action: { isNewTeamPresented.toggle() }).padding()
                }
            })
            .toolbar {
                ToolbarItem {
                    Button(action: toogleDateFilter){
                        Label("Filtrar", systemImage: isFiltering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem {
                    Button(action: { isNewTeamPresented.toggle() }) {
                        Label("Novo time", systemImage: "plus")
                    }
                }
            }
            .alert("Editar time", isPresented: $isEditTeamPresented) {
                TextField("Nome do time", text: $teamName)
                Button("Salvar", action: editTeam)
                Button("Cancelar", role: .cancel) {
                    teamName = ""
                }
            }
            .alert("Novo time", isPresented: $isNewTeamPresented) {
                TextField("Nome do time", text: $teamName)
                Button("Salvar", action: createTeam)
                Button("Cancelar", role: .cancel) {
                    teamName = ""
                }
            }
            .navigationTitle("Times")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var filteredTeams: [Team] {
        teams.filter(filterTeamByDate)
    }
    
    private func filterTeamByDate(team: Team) -> Bool {
        if !isFiltering {
            return true
        }
        return team.getPlayedGamesCount(filterStartDate, filterEndDate) > 0
    }
    
    private func toogleDateFilter() {
        isFiltering.toggle()
        if !isFiltering {
            filterStartDate = .now
            filterEndDate = .now
        }
    }
    
    private func createTeam() {
        withAnimation {
            let newTeam = Team(name: teamName)
            modelContext.insert(newTeam)
            teamName = ""
        }
    }
    
    private func editTeam() {
        withAnimation {
            selectedTeam!.name = teamName
            teamName = ""
        }
    }
    
    private func deleteTeam(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let fixedIndex = teams.firstIndex(where: {$0.id == filteredTeams[index].id})!
                for game in teams[fixedIndex].games {
                    modelContext.delete(game)
                }
                modelContext.delete(teams[fixedIndex])
            }
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
    return TeamListView()
        .modelContainer(previewer.container)
    
}
