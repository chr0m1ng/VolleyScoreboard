//
//  TeamPickerView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import SwiftUI

struct TeamPickerView: View {
    private var title: String
    private var teams: [Team]
    @Binding private var selection: Team?

    init(title: String, selection: Binding<Team?>, teams: [Team]) {
        self.title = title
        self.teams = teams
        self._selection = selection
    }
    
    var body: some View {
        Picker(title, selection: $selection) {
            Text("Selecione um time").tag(nil as Team?)
            ForEach(teams, id: \.name) { team in
                Text(team.name).tag(Optional(team))
            }
        }.pickerStyle(.navigationLink)
    }
}
