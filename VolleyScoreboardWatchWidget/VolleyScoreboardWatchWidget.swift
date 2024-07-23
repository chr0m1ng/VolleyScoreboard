//
//  VolleyScoreboardWatchWidget.swift
//  VolleyScoreboardWatchWidget
//
//  Created by Gabriel Santos on 14/07/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    var currentEntry: Entry {
        .init(
            date: .now, 
            scoreboardUpdate: ScoreboardStatus.shared
        )
    }
    
    func placeholder(in context: Context) -> ScoreboardEntry {
        ScoreboardEntry(date: Date(), scoreboardUpdate: ScoreboardStatus.shared)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScoreboardEntry) -> ()) {
        let entry = ScoreboardEntry(date: Date(), scoreboardUpdate: ScoreboardStatus.shared)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ScoreboardEntry] = []
        let entry = ScoreboardEntry(date: Date(), scoreboardUpdate: ScoreboardStatus.shared)
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ScoreboardEntry: TimelineEntry {
    let date: Date
    let scoreboardUpdate: ScoreboardStatus
}

struct VolleyScoreboardWatchWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            Text("Placar de Vôlei")
            Image(systemName: "volleyball.fill")
        }
    }
}

@main
struct VolleyScoreboardWatchComplication: Widget {
    let kind: String = "VolleyScoreboardWatchComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                VolleyScoreboardWatchWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                VolleyScoreboardWatchWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Volley Scoreboard")
        .description("Volley Scoreboard")
        .supportedFamilies([.accessoryCorner, .accessoryCircular, .accessoryInline])
    }
}

#Preview(as: .accessoryInline) {
    VolleyScoreboardWatchComplication()
} timeline: {
    ScoreboardEntry(date: .now, scoreboardUpdate: ScoreboardStatus.shared)
}
