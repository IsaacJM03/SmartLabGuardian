# Smart Lab Guardian - UI Overview

This document describes the user interface and screens of the Smart Lab Guardian app.

## App Structure

The app uses a bottom navigation bar with 4 main screens:

```
┌─────────────────────────────────────┐
│         App Bar (Dynamic)           │
├─────────────────────────────────────┤
│                                     │
│         Screen Content              │
│         (Changes per tab)           │
│                                     │
├─────────────────────────────────────┤
│    Dashboard | Alerts | History     │
│              | Settings              │
└─────────────────────────────────────┘
```

## 1. Dashboard Screen

**Purpose**: Real-time monitoring of all sensors

### Layout
```
┌─────────────────────────────────────┐
│  Lab Safety Dashboard          [⚠️] │  ← App bar (red if alerts)
├─────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐          │
│  │  🌡️     │  │  💨     │          │  ← Status grid (2x2)
│  │  25.5°C │  │  30 ppm │          │
│  │Temperature│  │Gas Level│         │
│  └─────────┘  └─────────┘          │
│  ┌─────────┐  ┌─────────┐          │
│  │  🔥     │  │  📏     │          │
│  │  Clear  │  │  50 cm  │          │
│  │Fire Stat│  │Distance │          │
│  └─────────┘  └─────────┘          │
├─────────────────────────────────────┤
│  Temperature (°C)           25.5    │
│  🌡️ [Chart with line graph]        │  ← Chart cards
│  Threshold: 30.0                    │
├─────────────────────────────────────┤
│  Gas Level (ppm)            30.0    │
│  💨 [Chart with line graph]        │
│  Threshold: 50.0                    │
├─────────────────────────────────────┤
│  Distance (cm)              50.0    │
│  📏 [Chart with line graph]        │
│  Threshold: 20.0                    │
└─────────────────────────────────────┘
```

### Features
- **Status Cards**: Show current value with color coding
  - Green/Blue/Orange = Normal
  - Red = Alert condition
- **Charts**: Line graphs showing last 20 readings
  - Smooth curves
  - Threshold line (dashed red)
  - Gradient fill under line
- **Pull to Refresh**: Swipe down to refresh data

### Color Scheme
- Normal: Blue/Green/Orange backgrounds
- Alert: Red background with white text
- App bar: Blue (normal) or Red (alerts active)

## 2. Alerts Screen

**Purpose**: View active alerts and alert history

### Layout
```
┌─────────────────────────────────────┐
│  Alerts & Notifications       [🗑️]  │  ← App bar with clear button
├─────────────────────────────────────┤
│  ⚠️ Active Alerts (2)          [🔴] │  ← Active alerts section
│  🔴 Temperature exceeds 30°C        │     (Red background)
│  🔴 Gas level exceeds 50 ppm        │
├─────────────────────────────────────┤
│  Alert History                      │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [🔴] Temperature Alert       │   │  ← Alert card
│  │ Temperature exceeds 30°C     │
│  │ Oct 20, 2025 14:30:45       │
│  │                   CRITICAL   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [🟠] Gas Level Warning       │   │
│  │ Gas level exceeds 50 ppm     │
│  │ Oct 20, 2025 14:25:12       │
│  │                   WARNING    │
│  └─────────────────────────────┘   │
│                                     │
│  [More alert cards...]              │
└─────────────────────────────────────┘
```

### Features
- **Active Alerts Section**
  - Red background when alerts active
  - Green background when all normal
  - List of current threshold breaches
- **Alert History**
  - Chronological list of all alerts
  - Color-coded by severity:
    - 🔴 Critical (red)
    - 🟠 Warning (orange)
    - 🔵 Info (blue)
  - Timestamp for each alert
  - Severity badge
- **Clear Logs**: Trash icon to clear history

## 3. History Screen

**Purpose**: View past sensor readings

### Layout
```
┌─────────────────────────────────────┐
│  Sensor History               [🗑️]  │  ← App bar with clear button
├─────────────────────────────────────┤
│  Summary Statistics           [ℹ️]  │  ← Summary section
│  🌡️        💨         📏           │     (Blue background)
│  Avg Temp  Avg Gas   Avg Dist      │
│  25.5°C    30 ppm    50 cm         │
│  Total readings: 42                 │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Oct 20, 14:30:45      LATEST│   │  ← Reading card
│  │ 🌡️25.5°C 💨30ppm           │     (Blue for latest)
│  │ 📏50cm   🔥OK              │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Oct 20, 14:30:40            │   │  ← Older readings
│  │ 🌡️25.3°C 💨29ppm           │     (White background)
│  │ 📏51cm   🔥OK              │
│  └─────────────────────────────┘   │
│                                     │
│  [More reading cards...]            │
└─────────────────────────────────────┘
```

### Features
- **Summary Statistics**
  - Average values for all sensors
  - Total reading count
  - Color-coded icons
- **Reading Cards**
  - Latest reading highlighted (blue background)
  - All sensor values in compact format
  - Timestamps
  - Scrollable list

## 4. Settings Screen

**Purpose**: Configure thresholds and manage data

### Layout
```
┌─────────────────────────────────────┐
│  Settings                      [🔄]  │  ← App bar with reset button
├─────────────────────────────────────┤
│  Sensor Thresholds                  │
│  Adjust threshold values to trigger │
│  alerts when sensors exceed limits. │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🌡️ Temperature       30.0°C  │   │  ← Threshold card
│  │ Maximum safe temperature     │
│  │ [========•===========]       │   ← Slider
│  │ 15°C              50°C       │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💨 Gas Level         50.0ppm │   │
│  │ Maximum safe gas level       │
│  │ [========•===========]       │
│  │ 0ppm             100ppm      │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📏 Distance          20.0cm  │   │
│  │ Minimum safe distance        │
│  │ [========•===========]       │
│  │ 5cm              100cm       │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────────  │
│  Data Management                    │
│                                     │
│  [🗑️ Clear History        ]        │  ← Action buttons
│  [🗑️ Clear All Data       ]        │
│                                     │
│  ─────────────────────────────────  │
│  About                              │
│  Smart Lab Guardian v1.0.0          │
│  A real-time lab safety monitoring  │
│  system. Integration Notes...       │
└─────────────────────────────────────┘
```

### Features
- **Threshold Cards**
  - Interactive sliders
  - Real-time value display
  - Color-coded by sensor type
  - Min/max labels
  - Icon representation
- **Data Management**
  - Clear history button (orange)
  - Clear all data button (red)
  - Confirmation dialogs
- **About Section**
  - Version information
  - Integration notes

## 5. Bottom Navigation Bar

```
┌─────────────────────────────────────┐
│  [📊]    [🔔]    [📜]    [⚙️]      │
│Dashboard Alerts History Settings    │
└─────────────────────────────────────┘
```

### Features
- **4 Tabs**: Dashboard, Alerts, History, Settings
- **Badge**: Red badge on Alerts tab when active alerts
- **Active Indicator**: Blue highlight on selected tab
- **Icons**: Material Design icons for clarity

## Alert States

### Normal State (No Alerts)
```
App Bar: Blue background
Alerts Tab: Green "All systems normal" banner
Badge: No badge on navigation
```

### Alert State (Threshold Breach)
```
App Bar: Red background + warning icon
Alerts Tab: Red "Active Alerts" banner
Badge: Red dot on Alerts navigation item
Dashboard: Red status cards for affected sensors
```

## Color Palette

### Status Colors
- **Normal**: 
  - Blue: #2196F3
  - Green: #4CAF50
  - Orange: #FF9800
- **Alert**: Red #F44336
- **Critical**: Dark Red #D32F2F

### UI Colors
- **Primary**: Blue #2196F3
- **Background**: White #FFFFFF
- **Card**: White with elevation
- **Text Primary**: Black #000000
- **Text Secondary**: Grey #757575

## Responsive Design

The app automatically adapts to:
- Different screen sizes (phones, tablets)
- Portrait and landscape orientations
- Light mode (default)
- Material Design 3 guidelines

## Accessibility Features

- High contrast colors
- Clear text labels
- Large touch targets (48x48 dp minimum)
- Color + icon + text for status
- Screen reader compatible

## Typography

- **Headers**: Bold, 24sp
- **Subheaders**: Bold, 18sp
- **Body**: Regular, 14sp
- **Captions**: Regular, 12sp
- **Values**: Bold, 20sp (sensor readings)

## Animations

- Smooth chart updates (real-time)
- Fade transitions between tabs
- Slider drag with haptic feedback
- Pull-to-refresh animation
- Card elevation on tap

## Icons

- Temperature: 🌡️ Thermometer
- Gas: 💨 Wind/Air
- Fire: 🔥 Fire
- Distance: 📏 Ruler/Straighten
- Alert: ⚠️ Warning
- Error: 🔴 Red Circle
- Success: ✅ Check Mark
- History: 📜 Scroll
- Settings: ⚙️ Gear

---

## Implementation Details

All screens use:
- Material Design 3 components
- Consistent spacing (16dp padding)
- Card elevation for depth
- Color-coded status indicators
- Responsive layouts
- Pull-to-refresh on scrollable content

## Testing the UI

To see the UI in action:

1. Run the app: `flutter run`
2. Navigate through all 4 tabs
3. Adjust sliders in Settings
4. Wait for simulated alerts to trigger
5. Pull to refresh on Dashboard
6. Clear logs and history to test actions

The simulated sensor will automatically create alert conditions for testing.
