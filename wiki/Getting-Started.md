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

The app and widget share one App Group. That identifier is already the same in three places. Leave it as written unless you change all three together:

- `PositivelyLocked/PositivelyLocked.entitlements`
- `AffirmationWidget/AffirmationWidget.entitlements`
- `AffirmationManager.appGroupIdentifier` in `Shared/AffirmationManager.swift`

The value is `group.com.positivelylocked.shared`. There is no `appGroupID` property.

Bundle identifiers already in the project:

- App: `com.positivelylocked.app`
- Widget: `com.positivelylocked.app.widget`

Version 1.0 (build 1) is set on both targets. The extension build number must stay equal to the app build number.

### 1. Configure the Main App Target

1. In Xcode's left sidebar, select the top-level **PositivelyLocked** project.
2. Under **Targets**, select **PositivelyLocked**.
3. Open **Signing & Capabilities**.
4. Check **Automatically manage signing** and select your developer **Team**.
5. Confirm **App Groups** lists `group.com.positivelylocked.shared` and is checked. If signing says the group is not on the team, register that exact identifier under Apple Developer → Identifiers → App Groups, then enable it for both App IDs.

### 2. Configure the Widget Target

1. Under **Targets**, select **AffirmationWidgetExtension**.
2. Open **Signing & Capabilities**.
3. Select the same **Team**.
4. Confirm `group.com.positivelylocked.shared` is checked.

Lock Screen widgets in this project use WidgetKit accessory families. They do not use Family Controls, Screen Time, or Device Activity, so no extra Apple entitlement approval is required for the widget.

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
