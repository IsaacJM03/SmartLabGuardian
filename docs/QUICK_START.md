# Quick Start Guide

Get Smart Lab Guardian up and running in minutes!

## Prerequisites

- Flutter SDK 3.0.0 or higher installed
- An IDE (VS Code, Android Studio, or IntelliJ)
- A device or emulator to run the app

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/IsaacJM03/SmartLabGuardian.git
cd SmartLabGuardian
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download all required packages:
- flutter_riverpod (state management)
- shared_preferences (local storage)
- fl_chart (charts)
- intl (date formatting)

### 3. Run the App

**On a connected device or emulator:**

```bash
flutter run
```

**On a specific device:**

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

**For web:**

```bash
flutter run -d chrome
```

## First Run

When you first launch the app, you'll see:

1. **Dashboard Screen**: Shows simulated sensor readings
   - Temperature (°C)
   - Gas Level (PPM)
   - Fire Detector
   - Distance Sensor (cm)
   
2. **Bottom Navigation**: Three tabs
   - Dashboard: Real-time monitoring
   - Alerts: Alert history
   - Settings: Configure thresholds

## Understanding the Simulated Data

The app generates realistic sensor data:

| Sensor | Range | Update Interval |
|--------|-------|----------------|
| Temperature | 15-45°C | 3 seconds |
| Gas | 0-800 PPM | 3 seconds |
| Fire | 0 or 1 | 3 seconds |
| Distance | 0-200 cm | 3 seconds |

## Customizing Thresholds

1. Navigate to **Settings** (bottom navigation)
2. Adjust sliders for each sensor:
   - Warning Threshold (orange alert)
   - Danger Threshold (red alert)
3. Changes are saved automatically

Default thresholds:
- Temperature: 30°C (warning), 40°C (danger)
- Gas: 300 PPM (warning), 500 PPM (danger)
- Distance: 50 cm (warning), 20 cm (danger)

## Testing Alerts

The app automatically generates alerts when sensor readings exceed thresholds:

1. Watch the **Dashboard** for readings in warning/danger zones
2. Navigate to **Alerts** to see triggered alerts
3. Click "Acknowledge" to mark alerts as seen

## Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS App

```bash
flutter build ios --release
```

Note: Requires macOS and Xcode

### Web App

```bash
flutter build web
```

Output: `build/web/`

## Common Commands

```bash
# Check Flutter installation
flutter doctor

# Run tests
flutter test

# Check code for issues
flutter analyze

# Format code
dart format .

# Clean build artifacts
flutter clean

# Update dependencies
flutter pub upgrade
```

## Development Workflow

1. **Make changes** to Dart files
2. **Hot reload** (press 'r' in terminal or save in IDE)
3. **Hot restart** (press 'R' for full restart)
4. **Test** your changes
5. **Commit** when ready

## Troubleshooting

### "pub get failed"
```bash
flutter clean
flutter pub get
```

### "No devices found"
- Start an emulator
- Connect a physical device with USB debugging enabled
- Check with `flutter devices`

### "Gradle build failed" (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### "Pod install failed" (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
```

## Next Steps

- **Integrate Hardware**: See [Hardware Integration Guide](HARDWARE_INTEGRATION.md)
- **Add Firebase**: See [Firebase Setup Guide](FIREBASE_SETUP.md)
- **Contribute**: Read [Contributing Guidelines](../CONTRIBUTING.md)
- **Learn More**: Check the main [README](../README.md)

## Architecture Overview

```
User Interface (Screens)
         ↓
  State Management (Riverpod Providers)
         ↓
  Business Logic (Services)
         ↓
  Data Models
         ↓
  Local Storage (SharedPreferences)
```

## Key Features to Explore

1. **Real-time Updates**: Dashboard auto-updates every 3 seconds
2. **Color-Coded Status**: Green (safe), Orange (warning), Red (danger)
3. **Alert System**: Automatic alert generation
4. **Persistent Settings**: Thresholds saved locally
5. **Clean UI**: Material Design 3

## Resources

- Flutter Documentation: https://docs.flutter.dev/
- Riverpod Guide: https://riverpod.dev/
- Project Issues: https://github.com/IsaacJM03/SmartLabGuardian/issues

## Support

Need help? 
- Open an issue on GitHub
- Check the documentation in the `docs/` folder
- Review the inline code comments

Happy monitoring! 🔬🛡️
