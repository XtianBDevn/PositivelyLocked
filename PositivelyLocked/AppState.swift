import SwiftUI
import Combine

/// Observable state object that manages the app's animation and affirmation state
class AppState: ObservableObject {
    @Published var showUnlockAnimation: Bool = false
    @Published var currentAffirmation: String = ""
    @Published var animationPhase: AnimationPhase = .idle
    
    enum AnimationPhase {
        case idle
        case expanding
        case particles
        case affirmationReveal
        case complete
    }
    
    init() {
        currentAffirmation = AffirmationManager.getCurrentAffirmation()
    }
    
    /// Triggers the unlock celebration animation sequence
    func triggerUnlockAnimation() {
        currentAffirmation = AffirmationManager.refreshAffirmation()
        showUnlockAnimation = true
        animationPhase = .expanding
        
        // Animation sequence timing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animationPhase = .particles
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.animationPhase = .affirmationReveal
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            self?.animationPhase = .complete
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.showUnlockAnimation = false
            self?.animationPhase = .idle
        }
    }
    
    /// Dismisses the animation early
    func dismissAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            showUnlockAnimation = false
            animationPhase = .idle
        }
    }
}
