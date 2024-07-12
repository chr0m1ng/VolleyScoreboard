//
//  TeamListItemView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 11/07/24.
//

import SwiftUI

struct TeamListItemView: View {
    @Bindable var team: Team
    @Binding var filterStartDate: Date
    @Binding var filterEndDate: Date
    @Binding var isFiltering: Bool
    
    var body: some View {
        HStack (alignment: .lastTextBaseline) {
            Text(team.name).frame(maxWidth: .infinity, alignment: .leading)
            VStack (alignment: .trailing){
                let lb = team.getLeaderboard(isFiltering ? filterStartDate : nil, isFiltering ? filterEndDate : nil)
                Text("\(lb.playedGames) (J) \(lb.wins) (VIT) \(lb.loses) (DER) \(lb.ties) (E)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("\(lb.playedSets) (SETS) \(lb.setWins) (VIT) \(lb.setLoses) (DER)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(maxWidth: .infinity).font(.caption2)
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
    @State var date: Date = .now
    @State var isFiltering = false
    return List {
        TeamListItemView(team: previewer.teams.first!, filterStartDate: $date, filterEndDate: $date, isFiltering: $isFiltering)
    }.modelContainer(previewer.container)
}
