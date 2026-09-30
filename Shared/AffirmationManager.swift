import Foundation
import WidgetKit

/// Manages the collection of positive affirmations shared between the main app and the widget extension.
/// Uses App Groups to share data between the app and its widget.
struct AffirmationManager {
    
    static let appGroupIdentifier = "group.com.positivelylocked.shared"
    private static let currentAffirmationKey = "currentAffirmation"
    private static let lastUpdatedKey = "lastUpdated"
    private static let selectedCategoryKey = "selectedCategory"
    
    /// Complete collection of positive affirmations organized by category
    static let affirmations: [String: [String]] = [
        "Self-Worth": [
            "I am enough, exactly as I am",
            "I deserve love, happiness, and peace",
            "My worth is not determined by others' opinions",
            "I am worthy of all the good things life has to offer",
            "I honor my own journey and trust my path",
            "I am a unique and valuable person",
            "I accept myself unconditionally",
            "I am proud of who I am becoming"
        ],
        "Strength": [
            "I am stronger than any challenge I face",
            "I have the power to create positive change",
            "Every obstacle is an opportunity for growth",
            "I am resilient, capable, and brave",
            "I trust myself to handle whatever comes my way",
            "My strength grows with every experience",
            "I am unstoppable when I believe in myself",
            "Challenges help me grow and become stronger"
        ],
        "Gratitude": [
            "Today is full of endless possibilities",
            "I am grateful for this moment right now",
            "Abundance flows freely into my life",
            "I attract positivity and joy effortlessly",
            "Every day brings new reasons to be thankful",
            "I appreciate the beauty in small moments",
            "My life is filled with blessings",
            "I choose to see the good in every situation"
        ],
        "Peace": [
            "I release what no longer serves me",
            "I am at peace with my past and excited for my future",
            "I choose calm over chaos",
            "My mind is clear, my heart is open",
            "I breathe in peace and exhale worry",
            "Serenity flows through me with every breath",
            "I am grounded, centered, and at peace",
            "I let go of tension and embrace tranquility"
        ],
        "Growth": [
            "I am constantly evolving and improving",
            "Every day I become a better version of myself",
            "I embrace change as a path to growth",
            "My potential is limitless",
            "I learn something valuable from every experience",
            "I am open to new possibilities",
            "Progress, not perfection, is my goal",
            "I celebrate my growth, no matter how small"
        ],
        "Joy": [
            "I choose happiness in this moment",
            "Joy is my natural state of being",
            "I radiate positive energy wherever I go",
            "Laughter and light fill my days",
            "I deserve to feel happy and fulfilled",
            "My smile brightens the world around me",
            "I find joy in the simple things",
            "Happiness is a choice I make every day"
        ]
    ]
    
    /// Returns all affirmations as a flat array
    static var allAffirmations: [String] {
        affirmations.values.flatMap { $0 }
    }
    
    /// Returns a random affirmation from the selected category, or from every category when none is selected.
    static func randomAffirmation() -> String {
        if let category = getSelectedCategory() {
            return randomAffirmation(from: category)
        }
        return allAffirmations.randomElement() ?? "You are amazing just as you are"
    }
    
    /// Returns a random affirmation from a specific category.
    static func randomAffirmation(from category: String) -> String {
        if let affirmation = affirmations[category]?.randomElement() {
            return affirmation
        }
        return allAffirmations.randomElement() ?? "You are amazing just as you are"
    }
    
    /// Gets the current affirmation stored in shared UserDefaults
    static func getCurrentAffirmation() -> String {
        let defaults = UserDefaults(suiteName: appGroupIdentifier)
        return defaults?.string(forKey: currentAffirmationKey) ?? randomAffirmation()
    }
    
    /// Category the user picked in the app, if it still exists in the catalog.
    static func getSelectedCategory() -> String? {
        let defaults = UserDefaults(suiteName: appGroupIdentifier)
        guard let category = defaults?.string(forKey: selectedCategoryKey),
              affirmations[category] != nil else {
            return nil
        }
        return category
    }
    
    /// Saves or clears the category shared with the widget.
    static func saveSelectedCategory(_ category: String?) {
        let defaults = UserDefaults(suiteName: appGroupIdentifier)
        if let category, affirmations[category] != nil {
            defaults?.set(category, forKey: selectedCategoryKey)
        } else {
            defaults?.removeObject(forKey: selectedCategoryKey)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Saves a new affirmation to shared UserDefaults
    static func saveCurrentAffirmation(_ affirmation: String) {
        let defaults = UserDefaults(suiteName: appGroupIdentifier)
        defaults?.set(affirmation, forKey: currentAffirmationKey)
        defaults?.set(Date(), forKey: lastUpdatedKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Generates and saves a new random affirmation
    @discardableResult
    static func refreshAffirmation() -> String {
        let newAffirmation = randomAffirmation()
        saveCurrentAffirmation(newAffirmation)
        return newAffirmation
    }
    
    /// Gets the category for a given affirmation
    static func category(for affirmation: String) -> String? {
        for (category, items) in affirmations {
            if items.contains(affirmation) {
                return category
            }
        }
        return nil
    }
    
    /// Returns all available categories
    static var categories: [String] {
        Array(affirmations.keys).sorted()
    }
}
