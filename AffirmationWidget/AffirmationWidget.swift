import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct AffirmationTimelineProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> AffirmationEntry {
        AffirmationEntry(
            date: Date(),
            affirmation: "You are amazing just as you are",
            category: "Self-Worth"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AffirmationEntry) -> Void) {
        let affirmation = AffirmationManager.getCurrentAffirmation()
        let category = AffirmationManager.category(for: affirmation) ?? "Joy"
        let entry = AffirmationEntry(
            date: Date(),
            affirmation: affirmation,
            category: category
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AffirmationEntry>) -> Void) {
        var entries: [AffirmationEntry] = []
        let currentDate = Date()
        
        // Generate entries for the next 24 hours, updating every 30 minutes
        for hourOffset in 0..<48 {
            let entryDate = Calendar.current.date(
                byAdding: .minute,
                value: hourOffset * 30,
                to: currentDate
            )!
            
            let affirmation = AffirmationManager.randomAffirmation()
            let category = AffirmationManager.category(for: affirmation) ?? "Joy"
            
            let entry = AffirmationEntry(
                date: entryDate,
                affirmation: affirmation,
                category: category
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Timeline Entry

struct AffirmationEntry: TimelineEntry {
    let date: Date
    let affirmation: String
    let category: String
}

// MARK: - Lock Screen Widget Views

/// Circular accessory widget - shows an icon with category color
struct AffirmationCircularView: View {
    let entry: AffirmationEntry
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            Image(systemName: categoryIcon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private var categoryIcon: String {
        switch entry.category {
        case "Self-Worth": return "heart.fill"
        case "Strength": return "bolt.fill"
        case "Gratitude": return "sun.max.fill"
        case "Peace": return "leaf.fill"
        case "Growth": return "arrow.up.right"
        case "Joy": return "face.smiling.fill"
        default: return "sparkles"
        }
    }
}

/// Rectangular accessory widget - shows the full affirmation text
struct AffirmationRectangularView: View {
    let entry: AffirmationEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.caption2)
                Text(entry.category)
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.secondary)
            
            Text(entry.affirmation)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.medium)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Inline accessory widget - shows abbreviated affirmation
struct AffirmationInlineView: View {
    let entry: AffirmationEntry
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "sparkles")
            Text(entry.affirmation)
                .lineLimit(1)
        }
    }
}

// MARK: - Home Screen Widget View

struct AffirmationHomeScreenView: View {
    let entry: AffirmationEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(entry.affirmation)
                    .font(.system(
                        size: family == .systemSmall ? 14 : 18,
                        weight: .semibold,
                        design: .rounded
                    ))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineLimit(family == .systemSmall ? 3 : 4)
                    .minimumScaleFactor(0.7)
                
                if family != .systemSmall {
                    Text(entry.category)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                        )
                }
            }
            .padding()
        }
    }
    
    private var gradientColors: [Color] {
        switch entry.category {
        case "Self-Worth": return [.pink, .purple]
        case "Strength": return [.orange, .red]
        case "Gratitude": return [.yellow, .orange]
        case "Peace": return [.mint, .teal]
        case "Growth": return [.green, .teal]
        case "Joy": return [.purple, .indigo]
        default: return [.purple, .pink]
        }
    }
}

// MARK: - Widget Configuration

struct AffirmationWidget: Widget {
    let kind: String = "AffirmationWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: AffirmationTimelineProvider()
        ) { entry in
            AffirmationWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Positive Affirmation")
        .description("See a positive affirmation every time you glance at your phone.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
            .systemSmall,
            .systemMedium
        ])
    }
}

// MARK: - Widget Entry View Router

struct AffirmationWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: AffirmationEntry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            AffirmationCircularView(entry: entry)
        case .accessoryRectangular:
            AffirmationRectangularView(entry: entry)
        case .accessoryInline:
            AffirmationInlineView(entry: entry)
        case .systemSmall, .systemMedium:
            AffirmationHomeScreenView(entry: entry)
        default:
            AffirmationRectangularView(entry: entry)
        }
    }
}

// MARK: - Widget Bundle

@main
struct AffirmationWidgetBundle: WidgetBundle {
    var body: some Widget {
        AffirmationWidget()
    }
}

// MARK: - Previews

#Preview("Rectangular", as: .accessoryRectangular) {
    AffirmationWidget()
} timeline: {
    AffirmationEntry(date: .now, affirmation: "You are stronger than any challenge you face", category: "Strength")
    AffirmationEntry(date: .now, affirmation: "Today is full of endless possibilities", category: "Gratitude")
}

#Preview("Circular", as: .accessoryCircular) {
    AffirmationWidget()
} timeline: {
    AffirmationEntry(date: .now, affirmation: "I am enough", category: "Self-Worth")
}

#Preview("Inline", as: .accessoryInline) {
    AffirmationWidget()
} timeline: {
    AffirmationEntry(date: .now, affirmation: "I choose happiness in this moment", category: "Joy")
}
