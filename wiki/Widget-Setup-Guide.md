# Widget Setup Guide

Positively Locked uses iOS 17+ WidgetKit to deliver affirmations directly to your Lock Screen. This guide covers how to add, configure, and troubleshoot your widgets.

---

## Adding the Lock Screen Widget

<p align="center">
  <img src="https://raw.githubusercontent.com/XtianBDevn/PositivelyLocked/main/docs/screenshots/setup-widget-step1.png" alt="Step 1" width="250">
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/XtianBDevn/PositivelyLocked/main/docs/screenshots/setup-widget-step2.png" alt="Step 2" width="250">
</p>

### Step-by-Step Instructions

1. **Wake your iPhone** so you see the Lock Screen (do not swipe up to go home).
2. **Long-press** on an empty area of your Lock Screen until the **Customize** button appears at the bottom. Tap it.
3. Tap **Lock Screen** (the left preview).
4. Tap the rectangular area **directly below the digital clock** to open the iOS Widget Gallery.
5. Scroll down the list of apps and select **"Positive Affirmation"**.
6. Choose your preferred widget size:
   - **Rectangular**: Displays the full text of the affirmation (Recommended).
   - **Circular**: Displays a beautifully styled icon representing your active category.
   - **Inline (Above Clock)**: Displays a short text above the clock.
7. Tap or drag the widget to add it to your Lock Screen.
8. Tap the close (`X`) button, then tap **Done** in the top right corner.

---

## Widget Styles & Behaviors

| Widget Type | Best Used For | Content Displayed |
| :--- | :--- | :--- |
| **Rectangular** | Main Affirmation | Full text of active affirmation, category label, and decorative sparkle. |
| **Circular** | Minimalist Icon | A stylized symbol matching your active category (e.g., Heart for Self-Worth). |
| **Inline** | Subtle Reminder | Short text preview displayed directly above the lock screen clock. |

---

## How Widgets Refresh

iOS optimizes battery life by scheduling widget updates. Positively Locked manages this efficiently:

- **30-Minute Timeline**: Every 30 minutes, the widget automatically cycles to a new random affirmation from your chosen category.
- **Immediate App Updates**: When you open the main app and change your active category, the app forces WidgetKit to immediately reload all active timelines.
- **Low Power Mode**: If your iPhone is in Low Power Mode, iOS may delay widget refreshes to conserve battery.

---

## Troubleshooting Widgets

### Widget is blank or showing placeholder text
1. **Open the main app**: Launch the main Positively Locked app. This initializes the database and writes default values to the App Group.
2. **Verify App Group ID**: Ensure the App Group identifier in `AffirmationManager.swift` matches the capability in Xcode exactly.

### Widget does not appear in the gallery
1. **Restart your device**: iOS sometimes fails to register newly installed widget extensions. A quick device restart resolves this 99% of the time.
2. **Verify Target iOS Version**: Ensure your physical device is running iOS 17.0 or later.
