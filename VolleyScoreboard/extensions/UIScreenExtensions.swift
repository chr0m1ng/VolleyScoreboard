//
//  UIScreenExtensions.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 11/07/24.
//

import Foundation
import SwiftUI

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
    static func widthPercent(_ percent: CGFloat) -> CGFloat {
        return UIScreen.screenWidth * (percent / 100)
    }
}
