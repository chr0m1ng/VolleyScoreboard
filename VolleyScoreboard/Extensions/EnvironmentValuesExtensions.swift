//
//  EnvironmentValuesExtensions.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 03/09/24.
//

import Foundation
import SwiftUI

final class Navigation: ObservableObject {
    @Published var path = NavigationPath()
}

extension EnvironmentValues {
    private struct NavigationKey: EnvironmentKey {
        static let defaultValue = Navigation()
    }

    var navigation: Navigation {
        get { self[NavigationKey.self] }
        set { self[NavigationKey.self] = newValue }
    }
}
