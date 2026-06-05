import SwiftUI

struct UnlockAnimationView: View {
    @EnvironmentObject var appState: AppState
    @State private var particles: [Particle] = []
    @State private var showAffirmation = false
    @State private var glowOpacity: Double = 0
    @State private var ringScale: CGFloat = 0.1
    @State private var ringOpacity: Double = 1.0
    @State private var backgroundOpacity: Double = 0
    @State private var affirmationScale: CGFloat = 0.5
    @State private var affirmationOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Animated gradient background
            animatedBackground
            
            // Expanding ring effect
            expandingRings
            
            // Particle system
            particleSystem
            
            // Central glow
            centralGlow
            
            // Affirmation text reveal
            affirmationReveal
            
            // Tap to dismiss hint
            dismissHint
        }
        .ignoresSafeArea()
        .onAppear {
            startAnimation()
        }
    }
    
    // MARK: - Background
    
    private var animatedBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.1, blue: 0.4),
                Color(red: 0.4, green: 0.1, blue: 0.3),
                Color(red: 0.1, green: 0.1, blue: 0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(backgroundOpacity)
    }
    
    // MARK: - Expanding Rings
    
    private var expandingRings: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.purple, .pink, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .scaleEffect(ringScale + CGFloat(index) * 0.2)
                    .opacity(ringOpacity - Double(index) * 0.3)
            }
        }
        .frame(width: 100, height: 100)
    }
    
    // MARK: - Particle System
    
    private var particleSystem: some View {
        GeometryReader { geometry in
            ForEach(particles) { particle in
                ParticleView(particle: particle)
            }
        }
    }
    
    // MARK: - Central Glow
    
    private var centralGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        .white.opacity(0.8),
                        .purple.opacity(0.3),
                        .clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 150
                )
            )
            .frame(width: 300, height: 300)
            .opacity(glowOpacity)
            .scaleEffect(glowOpacity > 0 ? 1.0 : 0.5)
    }
    
    // MARK: - Affirmation Reveal
    
    private var affirmationReveal: some View {
        VStack(spacing: 20) {
            // Decorative element
            Image(systemName: "sparkles")
                .font(.system(size: 32))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Affirmation text
            Text(appState.currentAffirmation)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: .purple.opacity(0.5), radius: 10)
                .padding(.horizontal, 40)
            
            // Subtle category indicator
            if let category = AffirmationManager.category(for: appState.currentAffirmation) {
                Text(category)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.15))
                    )
            }
        }
        .scaleEffect(affirmationScale)
        .opacity(affirmationOpacity)
    }
    
    // MARK: - Dismiss Hint
    
    private var dismissHint: some View {
        VStack {
            Spacer()
            Text("Tap anywhere to dismiss")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .padding(.bottom, 50)
        }
        .opacity(affirmationOpacity)
    }
    
    // MARK: - Animation Logic
    
    private func startAnimation() {
        // Background fade in
        withAnimation(.easeIn(duration: 0.3)) {
            backgroundOpacity = 1.0
        }
        
        // Ring expansion
        withAnimation(.easeOut(duration: 1.2)) {
            ringScale = 4.0
            ringOpacity = 0
        }
        
        // Central glow
        withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
            glowOpacity = 1.0
        }
        
        // Generate particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            generateParticles()
        }
        
        // Fade glow
        withAnimation(.easeOut(duration: 1.0).delay(1.5)) {
            glowOpacity = 0.3
        }
        
        // Reveal affirmation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.8)) {
            affirmationScale = 1.0
            affirmationOpacity = 1.0
        }
    }
    
    private func generateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        for i in 0..<40 {
            let angle = Double(i) / 40.0 * .pi * 2
            let distance = CGFloat.random(in: 100...300)
            let particle = Particle(
                id: i,
                startX: centerX,
                startY: centerY,
                endX: centerX + cos(angle) * distance,
                endY: centerY + sin(angle) * distance,
                color: particleColors.randomElement() ?? .purple,
                size: CGFloat.random(in: 4...12),
                duration: Double.random(in: 1.0...2.0),
                delay: Double.random(in: 0...0.3),
                shape: ParticleShape.allCases.randomElement() ?? .circle
            )
            particles.append(particle)
        }
    }
    
    private var particleColors: [Color] {
        [.purple, .pink, .orange, .yellow, .mint, .cyan, .white]
    }
}

// MARK: - Particle Model

struct Particle: Identifiable {
    let id: Int
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let color: Color
    let size: CGFloat
    let duration: Double
    let delay: Double
    let shape: ParticleShape
}

enum ParticleShape: CaseIterable {
    case circle
    case star
    case diamond
    case sparkle
}

// MARK: - Particle View

struct ParticleView: View {
    let particle: Particle
    @State private var isAnimating = false
    
    var body: some View {
        particleShape
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .position(
                x: isAnimating ? particle.endX : particle.startX,
                y: isAnimating ? particle.endY : particle.startY
            )
            .opacity(isAnimating ? 0 : 1)
            .scaleEffect(isAnimating ? 0.3 : 1.0)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(
                    .easeOut(duration: particle.duration)
                    .delay(particle.delay)
                ) {
                    isAnimating = true
                }
            }
    }
    
    @ViewBuilder
    private var particleShape: some Shape {
        switch particle.shape {
        case .circle:
            Circle()
        case .star:
            StarShape(points: 5)
        case .diamond:
            DiamondShape()
        case .sparkle:
            StarShape(points: 4)
        }
    }
}

// MARK: - Custom Shapes

struct StarShape: Shape {
    let points: Int
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        
        var path = Path()
        let angleStep = .pi * 2 / Double(points * 2)
        
        for i in 0..<(points * 2) {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = angleStep * Double(i) - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Shape Protocol Conformance Helper

extension Shape {
    @ViewBuilder
    func asAnyShape() -> some View {
        self
    }
}

#Preview {
    UnlockAnimationView()
        .environmentObject(AppState())
}
