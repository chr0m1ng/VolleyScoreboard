//
//  DateUtil.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 08/07/24.
//

import Foundation

extension Date {
    func printableString(_ dateStyle: DateFormatter.Style = .medium, _ timeStyle: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
}
