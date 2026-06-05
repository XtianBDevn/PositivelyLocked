import UIKit

/// Manages haptic feedback for the unlock celebration animation
struct HapticManager {
    
    /// Triggers a celebration haptic pattern when the user unlocks their phone
    static func playUnlockCelebration() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        
        // Follow up with a light impact for the particle burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.prepare()
            impact.impactOccurred()
        }
        
        // Soft impact for the affirmation reveal
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let impact = UIImpactFeedbackGenerator(style: .soft)
            impact.prepare()
            impact.impactOccurred()
        }
    }
    
    /// Light tap feedback for UI interactions
    static func lightTap() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()
        impact.impactOccurred()
    }
    
    /// Selection feedback for category changes
    static func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
