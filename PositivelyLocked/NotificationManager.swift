import Foundation
import UserNotifications
import WidgetKit

/// Manages notification scheduling and widget timeline refresh
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Requests notification permission from the user
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound])
            return granted
        } catch {
            return false
        }
    }
    
    /// Schedules a morning affirmation notification
    func scheduleMorningAffirmation() {
        let content = UNMutableNotificationContent()
        content.title = "Good Morning ✨"
        content.body = AffirmationManager.randomAffirmation()
        content.sound = .default
        
        // Schedule for 8:00 AM daily
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "morning-affirmation",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// Refreshes the widget timeline to show a new affirmation
    func refreshWidget() {
        AffirmationManager.refreshAffirmation()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Called when the app becomes active to ensure fresh content
    func handleAppBecameActive() {
        refreshWidget()
    }
}
