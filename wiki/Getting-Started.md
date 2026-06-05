# Getting Started

This guide will walk you through setting up, building, and running **Positively Locked** on your Mac, simulator, or physical iOS device.

## Prerequisites

To compile and run Positively Locked, you need:

- **macOS Sonoma** (14.0) or later
- **Xcode 15.0** or later
- **iOS 17.0** or later (for both simulator and physical device testing)
- An active Apple Developer Account (only if deploying to a physical device)

---

## Installation & Setup

### 1. Clone the Repository

Clone the project to your local machine using git:

```bash
git clone https://github.com/XtianBDevn/PositivelyLocked.git
cd PositivelyLocked
```

### 2. Open the Xcode Project

Open the project in Xcode:

```bash
open PositivelyLocked.xcodeproj
```

---

## Configuring Targets & Capabilities

Because the app shares data with its Lock Screen widget, it uses **App Groups**. You must configure this capability with your developer account.

### 1. Configure the Main App Target

1. In Xcode's left sidebar, select the top-level **PositivelyLocked** project folder.
2. Under **Targets**, select **PositivelyLocked**.
3. Go to the **Signing & Capabilities** tab.
4. Check **Automatically manage signing** and select your developer **Team**.
5. Scroll down to the **App Groups** section.
6. Click the `+` button and add a group named `group.com.yourname.PositivelyLocked` (replace `yourname` with your unique bundle identifier or developer name).
7. Ensure this new App Group is checked.

### 2. Configure the Widget Target

1. Under **Targets**, select **AffirmationWidgetExtension**.
2. Go to the **Signing & Capabilities** tab.
3. Select the same developer **Team**.
4. Scroll down to the **App Groups** section.
5. Check the exact same App Group you created for the main app target (`group.com.yourname.PositivelyLocked`).

### 3. Update the Shared App Group Name in Code

Open `Shared/AffirmationManager.swift` and update the `appGroupID` variable to match your group name:

```swift
// Change this to your actual App Group ID
static let appGroupID = "group.com.yourname.PositivelyLocked"
```

---

## Building and Running

### Running in the Simulator

1. In Xcode's top toolbar, select the **PositivelyLocked** scheme.
2. Select any simulator running **iOS 17+** (e.g., iPhone 15 Pro).
3. Press **⌘R** (or click the Play button) to build and run.
4. Once the app opens, tap on different categories to explore.
5. Go to the home screen, lock the simulator (Device → Lock), and add the widget!

### Deploying to a Physical iPhone

1. Connect your iPhone to your Mac via USB or Wi-Fi.
2. In Xcode's device selector, choose your physical iPhone.
3. Press **⌘R** to build and deploy.
4. If this is your first time deploying, you may need to trust your developer certificate on your phone:
   - Go to **Settings → General → VPN & Device Management**.
   - Under "Developer App", tap your certificate and select **Trust**.
5. Enable Developer Mode on your iPhone if you haven't already:
   - Go to **Settings → Privacy & Security → Developer Mode** and turn it on.
   - Restart your device when prompted.
