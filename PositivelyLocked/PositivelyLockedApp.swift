import SwiftUI

@main
struct PositivelyLockedApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    handleScenePhaseChange(from: oldPhase, to: newPhase)
                }
        }
    }
    
    private func handleScenePhaseChange(from oldPhase: ScenePhase, to newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            // User has unlocked the phone and opened the app
            if oldPhase == .background || oldPhase == .inactive {
                appState.triggerUnlockAnimation()
                // Refresh the affirmation for next lock screen display
                AffirmationManager.refreshAffirmation()
            }
        case .background:
            // App moved to background - prepare new affirmation for widget
            AffirmationManager.refreshAffirmation()
        case .inactive:
            break
        @unknown default:
            break
        }
    }
}
