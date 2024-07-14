//
//  DateExtensions.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 08/07/24.
//

import Foundation

extension Date {
    static func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter
    }
    
    func formattedString(dateFormat: String) -> String {
        let dateFormatter = Date.getDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    var printableDay: String {
        self.formattedString(dateFormat: "EEEE")
    }
    
    var printableDayDate: String {
        self.formattedString(dateFormat: "EEEE, d")
    }
    
    var printableDayDateMonth: String {
        self.formattedString(dateFormat: "EEEE, d 'de' MMM")
    }
    
    func isSameDay(date: Date) -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    func printableString(_ dateStyle: DateFormatter.Style = .medium, _ timeStyle: DateFormatter.Style = .short) -> String {
        let dateFormatter = Date.getDateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }
}
