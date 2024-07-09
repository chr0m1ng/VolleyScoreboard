//
//  NewGameView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import SwiftUI
import SwiftData

struct NewGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Team.name) private var teams: [Team]
    @Environment(\.dismiss) private var dismiss
    @Query private var games: [Game]
    @State private var teamA: Team?
    @State private var teamB: Team?
    @State private var setWinnerScore: Int = 15

    var body: some View {
        NavigationStack {
            Form {
                TeamPickerView(title: "Time 1", selection: $teamA, teams: teams.filter { teamB?.name != $0.name })
                TeamPickerView(title: "Time 2", selection: $teamB, teams: teams.filter { teamA?.name != $0.name })
                Stepper("Pontos por set: \(setWinnerScore)", value: $setWinnerScore, in: 1...100, step: 1)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Iniciar jogo", action: startGame)
                        .disabled(isStartGameDisabled)
                }
                ToolbarItem(placement: .principal) {
                    Text("Novo Jogo")
                }
            }
        }
    }
    
    var isStartGameDisabled: Bool {
        teamA == nil || teamB == nil
    }
    
    private func startGame() {
        withAnimation {
            let newGame = Game(setWinnerScore: setWinnerScore)
            modelContext.insert(newGame)
            newGame.teams.append(contentsOf: [teamA!, teamB!])
            dismiss()
        }
    }
}

extension View {
    func newGameSheet(isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            NewGameView()
        }
    }
}
