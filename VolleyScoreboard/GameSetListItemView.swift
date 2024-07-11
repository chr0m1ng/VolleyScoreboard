//
//  GameSetListItemView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 10/07/24.
//

import SwiftUI

struct GameSetListItemView: View {
    @Bindable var set: GameSet

    var body: some View {
        HStack {
            VStack {
                HStack {
                    let isWinner = set.winner == set.teamA
                    Text(set.teamA!.name).frame(maxWidth: .infinity, alignment: .leading).bold(isWinner)
                    if isWinner {
                        Image(systemName: "volleyball").foregroundColor(.blue)
                    }
                    Text(String(set.scoreboard!.teamAScore)).frame(alignment: .trailing).bold(isWinner)
                }
                Divider()
                HStack {
                    let isWinner = set.winner == set.teamB
                    Text(set.teamB!.name).frame(maxWidth: .infinity, alignment: .leading).bold(isWinner)
                    if isWinner {
                        Image(systemName: "volleyball").foregroundColor(.blue)
                    }
                    Text(String(set.scoreboard!.teamBScore)).frame(alignment: .trailing).bold(isWinner)
                }
            }.frame(minWidth: UIScreen.widthPercent(55))
            Divider()
            VStack {
                Text(set.name).font(.title3).bold()
                Divider()
                HStack {
                    Image(systemName: set.isFinished ? "stopwatch.fill" : "stopwatch").foregroundColor(.blue)
                    VStack {
                        Text(String(set.startTime.printableString(.none, .short)))
                        if set.endTime != nil {
                            Text(String(set.endTime!.printableString(.none, .short)))
                        }
                    }
                }
            }.frame(minWidth: UIScreen.widthPercent(22)).font(.caption)
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
//    previewer.gameSet.finish()
    return List { GameSetListItemView(set: previewer.gameSet) }.modelContainer(previewer.container)
}
