//
//  GameListItemView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 10/07/24.
//

import SwiftUI

struct GameListItemView: View {
    @Bindable var game: Game

    var body: some View {
        HStack {
            VStack {
                HStack {
                    let isWinner = game.winner == game.teamA
                    Text(game.teamA.name).frame(maxWidth: .infinity, alignment: .leading).bold(isWinner)
                    if isWinner {
                        Image(systemName: "trophy").foregroundColor(.blue)
                    }
                    Text(String(game.score.teamA)).frame(alignment: .trailing).bold(isWinner)
                }
                Divider()
                HStack {
                    let isWinner = game.winner == game.teamB
                    Text(game.teamB.name).frame(maxWidth: .infinity, alignment: .leading).bold(isWinner)
                    if isWinner {
                        Image(systemName: "trophy").foregroundColor(.blue)
                    }
                    Text(String(game.score.teamB)).frame(alignment: .trailing).bold(isWinner)
                }
            }.frame(minWidth: UIScreen.widthPercent(55))
            Divider()
            HStack {
                Image(systemName: game.isFinished ? "stopwatch.fill" : "stopwatch").foregroundColor(.blue)
                VStack {
                    Text(String(game.startDate.printableString(.short, .none)))
                    Text(String(game.startDate.printableString(.none, .short)))
                    if game.endDate != nil {
                        Text(String(game.endDate!.printableString(.none, .short)))
                    }
                }
            }.frame(minWidth: UIScreen.widthPercent(22)).font(.caption)
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
//    previewer.game.finish()
    return List { GameListItemView(game: previewer.game) }.modelContainer(previewer.container)
}
