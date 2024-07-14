//
//  DateSeparatorView.swift
//  VolleyScoreboard
//
//  Created by Gabriel Santos on 13/07/24.
//

import SwiftUI

struct DateSeparatorView: View {
    var date: Date
    var calendar: Calendar = .autoupdatingCurrent

    var body: some View {
        VStack {
            Text(dateText)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 10))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
        }.listRowBackground(Color.clear).font(.footnote)
    }
    
    var dateText: String {
        var dateText = date.printableString(.medium, .none)
        if calendar.isDate(date, equalTo: .now, toGranularity: .weekOfYear) {
            dateText = date.printableDay
        } else if (calendar.isDate(date, equalTo: .now, toGranularity: .month)) {
            dateText = date.printableDayDate
        } else if (calendar.isDate(date, equalTo: .now, toGranularity: .year)) {
            dateText = date.printableDayDateMonth
        }
        return dateText
    }
}

#Preview {
    return DateSeparatorView(date: .now)
}
