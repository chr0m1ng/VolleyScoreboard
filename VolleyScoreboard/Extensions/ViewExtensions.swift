//
//  ViewExtensions.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 11/07/24.
//

import Foundation
import SwiftUI

extension View {
    func newGameSheet(isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            NewGameView()
        }
    }
}
