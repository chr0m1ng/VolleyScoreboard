//
//  AppView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 04/07/24.
//

import SwiftUI

struct AppView: View {
    @State private var tabSelection = 1
    var body: some View {
        TabView(selection: $tabSelection) {
            Group {
                GameListView(tabSelection: $tabSelection)
                    .tabItem { Label("Jogos", systemImage: "figure.volleyball") }
                    .tag(1)
                TeamListView()
                    .tabItem { Label("Times", systemImage: "person.2.fill") }
                    .tag(2)
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

#Preview {
    let previewer = try! PreviewContainer()
    return AppView()
        .modelContainer(previewer.container)
}
