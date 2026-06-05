import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Main app content
            MainView()
            
            // Unlock animation overlay
            if appState.showUnlockAnimation {
                UnlockAnimationView()
                    .transition(.opacity)
                    .zIndex(100)
                    .onTapGesture {
                        appState.dismissAnimation()
                    }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.showUnlockAnimation)
    }
}

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: String? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    headerSection
                    
                    // Current Affirmation Card
                    currentAffirmationCard
                    
                    // Category Selection
                    categorySection
                    
                    // Instructions
                    instructionsSection
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.93, blue: 1.0),
                        Color(red: 1.0, green: 0.97, blue: 0.93)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("✨")
                .font(.system(size: 48))
            
            Text("Positively Locked")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .pink, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("Your daily dose of positivity")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var currentAffirmationCard: some View {
        VStack(spacing: 16) {
            Text("Today's Affirmation")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(1.2)
            
            Text(appState.currentAffirmation)
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            if let category = AffirmationManager.category(for: appState.currentAffirmation) {
                Text(category)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.1))
                    .foregroundColor(.purple)
                    .clipShape(Capsule())
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
                .shadow(color: .purple.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categories")
                .font(.headline)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(AffirmationManager.categories, id: \.self) { category in
                    CategoryCard(
                        category: category,
                        count: AffirmationManager.affirmations[category]?.count ?? 0,
                        isSelected: selectedCategory == category
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            if selectedCategory == category {
                                selectedCategory = nil
                            } else {
                                selectedCategory = category
                                appState.currentAffirmation = AffirmationManager.randomAffirmation(from: category)
                                AffirmationManager.saveCurrentAffirmation(appState.currentAffirmation)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var instructionsSection: some View {
        VStack(spacing: 16) {
            Text("How It Works")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                InstructionRow(icon: "lock.fill", text: "Add the widget to your Lock Screen")
                InstructionRow(icon: "hand.raised.fill", text: "Pick up your phone to see your affirmation")
                InstructionRow(icon: "sparkles", text: "Unlock to enjoy a celebration animation")
                InstructionRow(icon: "arrow.clockwise", text: "A new affirmation appears each time")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.7))
            )
        }
        .padding(.top, 8)
    }
}

struct CategoryCard: View {
    let category: String
    let count: Int
    let isSelected: Bool
    
    private var categoryIcon: String {
        switch category {
        case "Self-Worth": return "heart.fill"
        case "Strength": return "bolt.fill"
        case "Gratitude": return "sun.max.fill"
        case "Peace": return "leaf.fill"
        case "Growth": return "arrow.up.right"
        case "Joy": return "face.smiling.fill"
        default: return "star.fill"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case "Self-Worth": return .pink
        case "Strength": return .orange
        case "Gratitude": return .yellow
        case "Peace": return .mint
        case "Growth": return .green
        case "Joy": return .purple
        default: return .blue
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: categoryIcon)
                .font(.title2)
                .foregroundColor(categoryColor)
            
            Text(category)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text("\(count) affirmations")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? categoryColor.opacity(0.15) : .white)
                .shadow(color: categoryColor.opacity(isSelected ? 0.2 : 0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? categoryColor.opacity(0.5) : .clear, lineWidth: 2)
        )
    }
}

struct InstructionRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.purple)
                .frame(width: 28)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
