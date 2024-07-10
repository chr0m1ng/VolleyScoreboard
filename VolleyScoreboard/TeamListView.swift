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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(teams, id: \.name) { team in
                    HStack (alignment: .lastTextBaseline) {
                        Text(team.name).frame(maxWidth: .infinity, alignment: .leading)
                        VStack (alignment: .trailing){
                            Text("\(team.playedGames) (J) \(team.wins) (VIT) \(team.loses) (DER) \(team.ties) (E)").font(.caption2).frame(maxWidth: .infinity, alignment: .trailing)
                            Text("\(team.playedSets) (SETS) \(team.setWins) (VIT) \(team.setLoses) (DER)").font(.caption2).frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .onTapGesture {
                        selectedTeam = team
                        teamName = team.name
                        isEditTeamPresented.toggle()
                    }
                }
                .onDelete(perform: deleteTeam)
            }
            .overlay(VStack {
                if teams.isEmpty {
                    Image(systemName: "list.bullet.rectangle.portrait").imageScale(.large)
                    Text("Nenhum time adicionado").padding().font(.title)
                    Button("Adicione um time", action: { isNewTeamPresented.toggle() }).padding()
                }
            })
            .toolbar {
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
                for game in teams[index].games {
                    modelContext.delete(game)
                }
                modelContext.delete(teams[index])
            }
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
    return TeamListView()
        .modelContainer(previewer.container)
    
}
