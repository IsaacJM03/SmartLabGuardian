# Setup Guide for Smart Lab Guardian

This guide will help you set up and run the Smart Lab Guardian Flutter application.

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Dart SDK** (included with Flutter)

3. **Android Studio** or **VS Code** with Flutter extensions

4. **Android SDK** (for Android development)
   - Install via Android Studio
   - Set up an emulator or connect a physical device

5. **Xcode** (for iOS development, macOS only)

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/IsaacJM03/SmartLabGuardian.git
cd SmartLabGuardian
```

### 2. Verify Flutter Installation

```bash
flutter doctor
```

This command checks your environment and displays a report. Fix any issues reported.

### 3. Install Dependencies

```bash
flutter pub get
```

This will download all the required packages specified in `pubspec.yaml`.

### 4. Run the App

#### For Development (Debug Mode)

```bash
# Run on connected device/emulator
flutter run

# Or specify a device
flutter devices  # List available devices
flutter run -d <device-id>
```

#### For Web

```bash
flutter run -d chrome
```

#### For Release Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

## Project Structure

```
SmartLabGuardian/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── sensor_data.dart        # Data models
│   ├── services/
│   │   ├── sensor_service.dart     # Sensor simulation
│   │   └── storage_service.dart    # Local storage
│   ├── providers/
│   │   └── sensor_providers.dart   # State management
│   └── screens/
│       ├── dashboard_screen.dart   # Main dashboard
│       ├── alerts_screen.dart      # Alerts view
│       ├── history_screen.dart     # History logs
│       └── settings_screen.dart    # Settings
├── test/                            # Unit and widget tests
├── android/                         # Android-specific code
├── ios/                            # iOS-specific code
└── web/                            # Web-specific code
```

## Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/sensor_data_test.dart
```

### Run with Coverage

```bash
flutter test --coverage
```

## Troubleshooting

### Common Issues

#### 1. "flutter: command not found"

**Solution:** Add Flutter to your PATH:

```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

Add this to your `.bashrc` or `.zshrc` to make it permanent.

#### 2. "Unable to locate Android SDK"

**Solution:** Set the ANDROID_HOME environment variable:

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

#### 3. "CocoaPods not installed" (iOS only)

**Solution:** Install CocoaPods:

```bash
sudo gem install cocoapods
```

#### 4. Dependencies not resolving

**Solution:** Clean and reinstall:

```bash
flutter clean
flutter pub get
```

#### 5. Build fails due to outdated dependencies

**Solution:** Upgrade dependencies:

```bash
flutter pub upgrade
```

## Real Sensor Integration

The app currently uses simulated sensor data. To integrate real sensors:

### 1. Choose Your Integration Method

- **Serial/USB**: For Arduino, ESP32 via USB
- **HTTP/REST**: For cloud-based sensors or APIs
- **MQTT**: For IoT sensor networks
- **Bluetooth**: For BLE sensors

### 2. Add Required Dependencies

Edit `pubspec.yaml` and add the appropriate package:

```yaml
dependencies:
  # For HTTP
  http: ^1.1.0
  
  # For MQTT
  mqtt_client: ^10.0.0
  
  # For Bluetooth
  flutter_blue_plus: ^1.24.0
  
  # For Serial
  usb_serial: ^0.5.0
```

### 3. Replace SensorService

Open `lib/services/sensor_service.dart` and replace the simulation code with your actual sensor integration. See the detailed comments in the file for examples.

### 4. Update Providers (if needed)

If your sensor service API differs, update `lib/providers/sensor_providers.dart` accordingly.

## Configuration

### Adjusting Sensor Thresholds

Default thresholds are defined in `lib/models/sensor_data.dart`:

```dart
factory SensorThresholds.defaults() => const SensorThresholds(
  maxTemperature: 30.0,  // °C
  maxGasLevel: 50.0,     // ppm
  minDistance: 20.0,     // cm
);
```

Users can adjust these at runtime via the Settings screen.

### Changing Data Storage Limits

Edit `lib/services/storage_service.dart`:

```dart
static const int _maxHistoryItems = 1000;  // Max sensor readings
static const int _maxAlertLogs = 500;      // Max alert logs
```

## Development Tips

### Hot Reload

While the app is running in debug mode:
- Press `r` for hot reload (preserves state)
- Press `R` for hot restart (resets state)
- Press `q` to quit

### Debugging

1. **Use Flutter DevTools:**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

2. **Enable debug logging:**
   Add print statements or use the debugger in your IDE.

3. **Check logs:**
   ```bash
   flutter logs
   ```

### Code Analysis

Run static analysis:

```bash
flutter analyze
```

Fix issues automatically:

```bash
dart fix --apply
```

## Deployment

### Android

1. **Sign the app:**
   - Create a keystore
   - Configure `android/key.properties`
   - Update `android/app/build.gradle`

2. **Build release APK:**
   ```bash
   flutter build apk --release
   ```

3. **Build App Bundle (recommended for Play Store):**
   ```bash
   flutter build appbundle --release
   ```

### iOS

1. **Configure signing in Xcode**

2. **Build for release:**
   ```bash
   flutter build ios --release
   ```

3. **Archive and distribute via Xcode**

### Web

```bash
flutter build web --release
```

Deploy the `build/web` directory to your hosting service.

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [FL Chart Documentation](https://pub.dev/packages/fl_chart)
- [Shared Preferences Documentation](https://pub.dev/packages/shared_preferences)

## Support

For issues or questions:
- Open an issue on GitHub
- Check the README.md for integration examples
- Review the code comments for detailed explanations

## License

MIT License - see LICENSE file for details
