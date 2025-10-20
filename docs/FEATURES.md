# Smart Lab Guardian - Features Overview

This document provides a detailed overview of all features in the Smart Lab Guardian app.

## 📊 Dashboard Screen

The Dashboard is the main screen of the app, providing real-time monitoring of all laboratory sensors.

### Features

#### Real-time Sensor Cards
Each sensor is displayed in a dedicated card showing:
- **Sensor Name and Icon**
  - Temperature: Thermometer icon
  - Gas Level: Cloud icon
  - Fire Detector: Fire department icon
  - Distance: Social distance icon

- **Current Reading**
  - Large, bold numeric display
  - Unit of measurement (°C, PPM, cm)
  - Special display for fire (FIRE DETECTED / No Fire)

- **Status Indicator**
  - Color-coded badge
  - Text status: SAFE / WARNING / DANGER
  - Green (safe), Orange (warning), Red (danger)

#### Update Frequency
- Sensors update every 3 seconds
- Automatic refresh via data stream
- No manual refresh needed (pull-to-refresh available)

#### Information Panel
- Integration notes for developers
- Links to documentation
- Instructions for hardware setup

### User Experience
```
┌─────────────────────────────────────┐
│  Lab Safety Dashboard               │
├─────────────────────────────────────┤
│  Real-time Monitoring               │
│  Sensor readings update every 3s    │
│                                     │
│  ┌─────────────────────────────┐  │
│  │ 🌡️ Temperature              │  │
│  │                             │  │
│  │     25.5 °C                 │  │
│  │     [ SAFE ]                │  │
│  └─────────────────────────────┘  │
│                                     │
│  ┌─────────────────────────────┐  │
│  │ ☁️ Gas Level                 │  │
│  │                             │  │
│  │     150.0 PPM               │  │
│  │     [ SAFE ]                │  │
│  └─────────────────────────────┘  │
│                                     │
│  ┌─────────────────────────────┐  │
│  │ 🔥 Fire Detector             │  │
│  │                             │  │
│  │     No Fire                 │  │
│  │     [ SAFE ]                │  │
│  └─────────────────────────────┘  │
│                                     │
│  ┌─────────────────────────────┐  │
│  │ 📏 Distance Sensor           │  │
│  │                             │  │
│  │     75.0 cm                 │  │
│  │     [ SAFE ]                │  │
│  └─────────────────────────────┘  │
└─────────────────────────────────────┘
```

## 🔔 Alerts Screen

The Alerts screen displays all triggered alerts and allows lab personnel to acknowledge them.

### Features

#### Alert List
- Chronologically ordered (newest first)
- Shows all alerts (acknowledged and unacknowledged)
- Clear visual distinction between states

#### Alert Card Information
- **Alert Icon**: Matches severity level
- **Alert Message**: Human-readable description
- **Sensor Type**: Which sensor triggered alert
- **Timestamp**: When alert was triggered
- **Acknowledge Button**: For active alerts
- **Status Badge**: "Acknowledged" for handled alerts

#### Alert Management
- **Acknowledge**: Mark individual alert as seen
- **Clear Acknowledged**: Remove all acknowledged alerts
- **Empty State**: Friendly message when no alerts

### Alert Types

#### Warning Alerts (Orange)
```
⚠️  WARNING: Temperature is 32.5°C
    Oct 20, 14:30
    [ Acknowledge ]
```

#### Danger Alerts (Red)
```
🔴 CRITICAL: Gas level is 550 PPM
    Oct 20, 14:32
    [ Acknowledge ]
```

```
🔴 CRITICAL: Fire detected!
    Oct 20, 14:35
    [ Acknowledge ]
```

### User Experience
```
┌─────────────────────────────────────┐
│  Alerts                [Clear...]   │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐  │
│  │ 🔴 CRITICAL: Gas level is   │  │
│  │     550 PPM                 │  │
│  │     Oct 20, 14:32          │  │
│  │              [Acknowledge]  │  │
│  └─────────────────────────────┘  │
│                                     │
│  ┌─────────────────────────────┐  │
│  │ ⚠️ WARNING: Temperature is  │  │
│  │     32.5°C                  │  │
│  │     Oct 20, 14:30          │  │
│  │     Acknowledged            │  │
│  └─────────────────────────────┘  │
└─────────────────────────────────────┘
```

## ⚙️ Settings Screen

The Settings screen allows users to configure safety thresholds for each sensor.

### Features

#### Threshold Configuration
For each sensor type:
- **Warning Threshold Slider**
  - Adjustable with clear value display
  - Orange color coding
  - Reasonable min/max ranges

- **Danger Threshold Slider**
  - Adjustable with clear value display
  - Red color coding
  - Reasonable min/max ranges

#### Auto-Save
- Changes saved automatically
- No manual save button needed
- Immediate application to monitoring

#### Sensor Categories

1. **Temperature Sensor (°C)**
   - Warning: 15-50°C (default: 30°C)
   - Danger: 20-60°C (default: 40°C)

2. **Gas Sensor (PPM)**
   - Warning: 100-800 PPM (default: 300 PPM)
   - Danger: 200-1000 PPM (default: 500 PPM)

3. **Distance Sensor (cm)**
   - Warning: 10-150 cm (default: 50 cm)
   - Danger: 5-100 cm (default: 20 cm)

#### Information Panel
- Explanation of thresholds
- Usage guidelines
- Tips for configuration

### User Experience
```
┌─────────────────────────────────────┐
│  Settings                           │
├─────────────────────────────────────┤
│  Sensor Thresholds                  │
│  Configure warning and danger...    │
│                                     │
│  Temperature Sensor (°C)            │
│  ┌─────────────────────────────┐  │
│  │ Warning Threshold      30.0 │  │
│  │ ─────●──────────────────── │  │
│  └─────────────────────────────┘  │
│  ┌─────────────────────────────┐  │
│  │ Danger Threshold       40.0 │  │
│  │ ─────────●──────────────── │  │
│  └─────────────────────────────┘  │
│                                     │
│  Gas Sensor (PPM)                   │
│  ┌─────────────────────────────┐  │
│  │ Warning Threshold     300.0 │  │
│  │ ─────●──────────────────── │  │
│  └─────────────────────────────┘  │
│  ┌─────────────────────────────┐  │
│  │ Danger Threshold      500.0 │  │
│  │ ─────────●──────────────── │  │
│  └─────────────────────────────┘  │
└─────────────────────────────────────┘
```

## 🧭 Navigation

Bottom navigation bar with three tabs:

```
┌─────────────────────────────────────┐
│                                     │
│         [Screen Content]            │
│                                     │
├─────────────────────────────────────┤
│  📊          🔔          ⚙️         │
│  Dashboard   Alerts     Settings   │
└─────────────────────────────────────┘
```

### Navigation Features
- Always visible
- Current tab highlighted
- Smooth transitions
- State preservation

## 🎨 Design System

### Color Scheme

#### Status Colors
- **Safe**: Green (#4CAF50)
- **Warning**: Orange (#FF9800)
- **Danger**: Red (#F44336)

#### UI Colors
- **Primary**: Blue (Material Design)
- **Background**: White
- **Card**: White with shadow
- **Text**: Black/Grey

### Typography
- **Headings**: Bold, 24pt
- **Sensor Values**: Bold, 32pt
- **Body Text**: Regular, 14pt
- **Status Labels**: Bold, 12pt

### Spacing
- Card padding: 16px
- Card spacing: 16px
- Section spacing: 24px

### Material Design 3
- Rounded corners
- Elevation/shadows
- Ripple effects
- Smooth animations

## 📱 Responsive Design

### Screen Sizes Supported
- **Small phones**: 320x568
- **Standard phones**: 375x667
- **Large phones**: 414x896
- **Tablets**: 768x1024+

### Adaptive Layout
- Cards stack vertically
- Scrollable content
- Flexible spacing
- Touch-friendly controls

## ⚡ Real-time Updates

### Data Flow
```
Sensor Service (generates reading)
    ↓ (every 3 seconds)
Stream Provider (emits data)
    ↓ (reactive)
UI Widgets (rebuild)
    ↓ (smooth)
User sees update
```

### Performance
- Efficient stream subscriptions
- Minimal widget rebuilds
- Smooth 60 FPS animations
- Low battery impact

## 🔐 Data Persistence

### What's Saved
- Sensor thresholds
- Alert history (last 50)
- Sensor reading history (last 100)

### Storage Method
- SharedPreferences for settings
- JSON serialization
- Automatic load on startup
- Automatic save on change

## 🔧 Developer Features

### Mock Data Generation
- Realistic value ranges
- Random variations
- Occasional alerts
- Configurable thresholds

### Integration Points
- Replace `SensorService._generateReadings()`
- Add real sensor communication
- Keep existing architecture
- Minimal code changes

### Debugging
- Console logs for key events
- Error messages in UI
- Stack traces in debug mode

## 🚀 Future Features

### Planned Enhancements
- [ ] Historical data charts
- [ ] Export data to CSV/PDF
- [ ] Push notifications
- [ ] Email/SMS alerts
- [ ] Multi-lab support
- [ ] User authentication
- [ ] Cloud synchronization
- [ ] Advanced analytics
- [ ] Custom alert rules
- [ ] Dark mode
- [ ] Multi-language support

### Integration Ready
- Firebase (dependencies included)
- Hive database (configured)
- Charts (FL Chart added)
- Bluetooth sensors (architecture ready)

## 📖 User Guide

### Getting Started
1. Install app
2. Grant required permissions
3. View Dashboard
4. Configure thresholds in Settings
5. Monitor alerts

### Daily Use
1. Check Dashboard regularly
2. Acknowledge alerts as they appear
3. Adjust thresholds as needed
4. Review alert history

### Best Practices
- Set conservative thresholds initially
- Adjust based on lab conditions
- Acknowledge alerts promptly
- Review alert history weekly
- Test sensors regularly

## 🎯 Key Benefits

### For Lab Personnel
- ✅ Real-time safety monitoring
- ✅ Instant hazard alerts
- ✅ Easy threshold configuration
- ✅ Alert history tracking
- ✅ Intuitive interface

### For Lab Managers
- ✅ Reduced safety incidents
- ✅ Compliance documentation
- ✅ Data-driven decisions
- ✅ Cost-effective solution
- ✅ Scalable architecture

### For Developers
- ✅ Clean architecture
- ✅ Well-documented code
- ✅ Easy hardware integration
- ✅ Extensive test coverage
- ✅ Active maintenance

---

For technical details, see [ARCHITECTURE.md](ARCHITECTURE.md)  
For setup instructions, see [QUICK_START.md](QUICK_START.md)  
For hardware integration, see [HARDWARE_INTEGRATION.md](HARDWARE_INTEGRATION.md)
