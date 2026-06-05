# Architecture & Customization

This page covers the technical details of **Positively Locked**, its codebase structure, and how you can customize it with your own animations and affirmations.

---

## Technical Architecture

The project is structured to share data efficiently between the main application target and the Widget extension target using **App Groups**.

```
┌─────────────────────────────────────────────────────────┐
│                    Shared App Group                     │
│               (UserDefaults + AppGroup ID)              │
└────────────────────────────┬────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              ▼                             ▼
┌───────────────────────────┐ ┌───────────────────────────┐
│     Main App Target       │ │     Widget Extension      │
│  - Select Category        │ │  - Reads Active Category  │
│  - Triggers Animations    │ │  - Displays Affirmation   │
│  - Customizes Content     │ │  - Refreshes on Timeline  │
└───────────────────────────┘ └───────────────────────────┘
```

### Core Code Files

- **`Shared/AffirmationManager.swift`**: The single source of truth for all affirmations. It handles reading/writing user preferences (active category, favorites) to shared memory.
- **`PositivelyLocked/AppState.swift`**: An `ObservableObject` that tracks active state, handles scene transitions (locking/unlocking), and manages animation triggers.
- **`PositivelyLocked/UnlockAnimationView.swift`**: The custom particle physics engine that handles rendering the celebratory burst when unlocking.
- **`AffirmationWidget/AffirmationWidget.swift`**: Implements the `TimelineProvider` and SwiftUI views for the Lock Screen widgets.

---

## Customization Guide

### 1. Adding Your Own Affirmations

You can easily add, edit, or remove affirmations by modifying `Shared/AffirmationManager.swift`.

Locate the static dictionary `affirmations`:

```swift
static let affirmations: [String: [String]] = [
    "Self-Worth": [
        "I am enough, exactly as I am",
        "I deserve love, happiness, and peace",
        // Add your custom affirmations here!
    ],
    "My Custom Category": [
        "This is a custom affirmation",
        "Keep moving forward, one step at a time",
    ]
]
```

Adding a new key-value pair to this dictionary will automatically make it appear in the main app's category selector and the lock screen widget!

---

### 2. Modifying the Celebration Animation

The particle animation is fully customizable in `PositivelyLocked/UnlockAnimationView.swift`.

#### Adjust Particle Count & Physics
To change how many particles explode outward, find `generateParticles()`:

```swift
func generateParticles() {
    let count = 40 // Increase for a bigger explosion, decrease for subtle
    var newParticles: [Particle] = []
    
    for _ in 0..<count {
        let angle = Double.random(in: 0...(2 * .pi))
        let speed = Double.random(in: 150...350) // Adjust speed range
        let scale = CGFloat.random(in: 0.4...1.2) // Adjust size scale
        
        // ...
    }
}
```

#### Change Particle Colors
You can change the color palette of the explosion by modifying the `colors` array:

```swift
let colors: [Color] = [
    .pink, .purple, .blue, .yellow, .orange, .mint
]
```

---

### 3. Customizing Haptic Feedback

Tactile feedback is managed by `PositivelyLocked/HapticManager.swift`. It triggers three distinct haptic taps during the unlock sequence.

You can modify the timing or feedback type:

```swift
func triggerUnlockCelebration() {
    // 1. Initial success haptic
    trigger(.success)
    
    // 2. Secondary light impact after a short delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
        self.triggerImpact(style: .light)
    }
    
    // 3. Final soft tap
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
        self.triggerImpact(style: .soft)
    }
}
```

---

### 4. Changing the Widget Refresh Interval

By default, iOS updates the widget timeline every 30 minutes. You can adjust this in `AffirmationWidget/AffirmationWidget.swift`:

```swift
// Generate a timeline for the next 24 hours, updating every 30 minutes
for hourOffset in 0..<48 {
    let entryDate = Calendar.current.date(
        byAdding: .minute, 
        value: hourOffset * 30, // Change 30 to your preferred minute interval
        to: currentDate
    )!
    // ...
}
```
