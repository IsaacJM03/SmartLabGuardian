# Quick Start Guide

Get Smart Lab Guardian up and running in 5 minutes!

## Prerequisites Check

```bash
# Check Flutter installation
flutter --version

# Should show Flutter 3.0.0 or higher
```

## Installation (3 steps)

### 1. Clone & Navigate
```bash
git clone https://github.com/IsaacJM03/SmartLabGuardian.git
cd SmartLabGuardian
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
# For mobile
flutter run

# For web
flutter run -d chrome
```

That's it! The app will start with simulated sensor data.

## First Time Using the App

### Dashboard Tab (Default)
- View real-time sensor readings
- See charts for temperature, gas, and distance
- Pull down to refresh

### Alerts Tab
- Shows any active alerts (threshold breaches)
- View alert history
- Clear logs if needed

### History Tab
- View all sensor readings
- See summary statistics
- Clear history if needed

### Settings Tab
- Adjust threshold values using sliders
- Reset to defaults
- Clear data

## Understanding the Interface

### Status Colors
- 🟢 **Green**: Normal - All values within safe limits
- 🟠 **Orange**: Normal - Temperature sensor normal range
- 🔵 **Blue**: Normal - Distance/Fire sensors normal
- 🔴 **Red**: Alert! - Threshold breach detected

### Default Thresholds
- Temperature: 30°C max
- Gas Level: 50 ppm max
- Distance: 20 cm min

## Common Tasks

### Change Temperature Threshold
1. Go to Settings tab
2. Find "Temperature" card
3. Drag slider to desired value
4. Changes save automatically

### View Alert History
1. Go to Alerts tab
2. Scroll down past active alerts
3. See all historical alerts with timestamps

### Clear History
1. Go to History tab
2. Tap trash icon in top right
3. Confirm deletion

### Test Alert Conditions
The simulated sensor will occasionally breach thresholds automatically, triggering alerts.

## Integration with Real Sensors

To use real sensors instead of simulation:

1. Choose your sensor type (Arduino, HTTP, MQTT, BLE)
2. Follow examples in `SENSOR_INTEGRATION_EXAMPLES.md`
3. Replace `SensorService` in `lib/services/sensor_service.dart`
4. Run the app

## Troubleshooting

### "flutter: command not found"
Solution: Add Flutter to PATH
```bash
export PATH="$PATH:[path-to-flutter]/flutter/bin"
```

### Dependencies won't install
Solution:
```bash
flutter clean
flutter pub get
```

### App won't run on device
Solution:
```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d [device-id]
```

### Charts not showing
Solution: Wait a few seconds for data to accumulate, then pull to refresh

## Quick Tips

💡 **Tip 1**: Pull down on dashboard to refresh data

💡 **Tip 2**: Adjust thresholds in Settings to test alerts

💡 **Tip 3**: All settings are saved automatically

💡 **Tip 4**: History saves every 5 seconds automatically

💡 **Tip 5**: Badge on Alerts tab shows active alerts

## File Structure Quick Reference

```
lib/
├── main.dart              ← App entry point
├── models/
│   └── sensor_data.dart   ← Data structures
├── services/
│   ├── sensor_service.dart     ← Replace this for real sensors
│   └── storage_service.dart    ← Local storage
├── providers/
│   └── sensor_providers.dart   ← State management
└── screens/
    ├── dashboard_screen.dart   ← Main view
    ├── alerts_screen.dart      ← Alerts view
    ├── history_screen.dart     ← History view
    └── settings_screen.dart    ← Settings view
```

## Next Steps

1. ✅ Run the app with simulated data
2. 📖 Read `FEATURES.md` to understand all features
3. 🔧 Read `SENSOR_INTEGRATION_EXAMPLES.md` to integrate real sensors
4. 🧪 Read `SETUP.md` for detailed setup and testing
5. 🚀 Deploy your customized app!

## Getting Help

- 📚 Documentation in README.md
- 🔧 Setup guide in SETUP.md
- 💡 Integration examples in SENSOR_INTEGRATION_EXAMPLES.md
- 🐛 Report issues on GitHub

## Development

### Hot Reload (while running)
- Press `r` - Hot reload (fast, keeps state)
- Press `R` - Hot restart (full restart)
- Press `q` - Quit

### Run Tests
```bash
flutter test
```

### Build Release
```bash
# Android
flutter build apk --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release
```

---

**You're ready to go!** 🎉

Start the app and begin monitoring your lab safety!
