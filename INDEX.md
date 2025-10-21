# Smart Lab Guardian - Documentation Index

Welcome to Smart Lab Guardian! This index will help you find the information you need.

## 🚀 Getting Started

### I want to...

#### Run the app quickly
→ [QUICK_START.md](QUICK_START.md) - 5-minute setup guide

#### Understand what this app does
→ [README.md](README.md) - Project overview and features
→ [FEATURES.md](FEATURES.md) - Detailed feature documentation

#### Set up a development environment
→ [SETUP.md](SETUP.md) - Complete installation and setup guide

#### See what the app looks like
→ [SCREENSHOTS.md](SCREENSHOTS.md) - UI overview and mockups

## 🔌 Integration

### I need to...

#### Integrate real sensors
→ [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md) - 5 complete integration examples

#### Understand the architecture
→ [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Technical architecture
→ [FEATURES.md](FEATURES.md) - Architecture diagrams

#### Find integration points in code
→ `lib/services/sensor_service.dart` - Replace this file
→ [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md) - How to replace it

## 💻 Development

### I want to...

#### Understand the code structure
```
lib/
├── main.dart                    # Start here
├── models/sensor_data.dart      # Data structures
├── services/
│   ├── sensor_service.dart     # Sensor simulation (replace for real sensors)
│   └── storage_service.dart    # Local storage
├── providers/sensor_providers.dart  # State management
└── screens/                     # UI screens
    ├── dashboard_screen.dart
    ├── alerts_screen.dart
    ├── history_screen.dart
    └── settings_screen.dart
```

#### Run tests
→ [SETUP.md](SETUP.md#testing) - Testing guide
→ `test/` directory - Test files

#### Build for production
→ [SETUP.md](SETUP.md#deployment) - Deployment instructions

#### Customize the app
→ [FEATURES.md](FEATURES.md#customization) - Customization guide
→ [SETUP.md](SETUP.md#configuration) - Configuration options

## 📚 Documentation Files

### Complete File List

| File | Purpose | Length |
|------|---------|--------|
| [README.md](README.md) | Project overview | ~4,000 words |
| [QUICK_START.md](QUICK_START.md) | Quick setup guide | ~1,500 words |
| [SETUP.md](SETUP.md) | Detailed setup | ~6,500 words |
| [FEATURES.md](FEATURES.md) | Feature documentation | ~9,000 words |
| [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md) | Integration examples | ~15,000 words |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | Implementation summary | ~9,000 words |
| [SCREENSHOTS.md](SCREENSHOTS.md) | UI documentation | ~4,000 words |
| **Total Documentation** | | **~50,000 words** |

## 🎯 By Role

### For End Users
1. [QUICK_START.md](QUICK_START.md) - How to run the app
2. [SCREENSHOTS.md](SCREENSHOTS.md) - What the app looks like
3. [README.md](README.md) - What features are available

### For Developers
1. [SETUP.md](SETUP.md) - Development environment setup
2. [FEATURES.md](FEATURES.md) - Technical architecture
3. [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Implementation details
4. Code files in `lib/` - Source code with inline docs

### For Hardware Integrators
1. [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md) - Integration patterns
2. `lib/services/sensor_service.dart` - Integration point
3. [FEATURES.md](FEATURES.md#real-sensor-integration) - Integration overview

### For Project Managers
1. [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Project status
2. [README.md](README.md) - Feature list
3. [FEATURES.md](FEATURES.md) - Detailed capabilities

## 🔍 By Topic

### Setup & Installation
- [QUICK_START.md](QUICK_START.md) - Fast setup
- [SETUP.md](SETUP.md) - Detailed setup
- [SETUP.md#troubleshooting](SETUP.md#troubleshooting) - Common issues

### Features & Capabilities
- [FEATURES.md](FEATURES.md) - All features
- [README.md](README.md) - Feature overview
- [SCREENSHOTS.md](SCREENSHOTS.md) - UI features

### Architecture & Design
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Technical details
- [FEATURES.md](FEATURES.md#technical-architecture) - Architecture
- Code comments - Inline documentation

### Sensor Integration
- [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md) - Examples
- [README.md#real-sensor-integration](README.md#real-sensor-integration) - Overview
- `lib/services/sensor_service.dart` - Code integration point

### Testing
- [SETUP.md#testing](SETUP.md#testing) - How to test
- `test/` directory - Test files
- [PROJECT_SUMMARY.md#testing](PROJECT_SUMMARY.md#testing) - Test coverage

### Deployment
- [SETUP.md#deployment](SETUP.md#deployment) - Build instructions
- [PROJECT_SUMMARY.md#deployment-readiness](PROJECT_SUMMARY.md#deployment-readiness) - Readiness checklist

## 📖 Reading Paths

### Path 1: Quick Demo (10 minutes)
1. [QUICK_START.md](QUICK_START.md) - Run the app
2. [SCREENSHOTS.md](SCREENSHOTS.md) - See the UI
3. Try the app yourself

### Path 2: Understanding the Project (30 minutes)
1. [README.md](README.md) - Overview
2. [FEATURES.md](FEATURES.md) - Detailed features
3. [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Implementation

### Path 3: Integration (1-2 hours)
1. [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md) - Choose your method
2. `lib/services/sensor_service.dart` - Replace simulation
3. [SETUP.md](SETUP.md) - Build and test

### Path 4: Full Developer Onboarding (2-3 hours)
1. [QUICK_START.md](QUICK_START.md) - Quick setup
2. [SETUP.md](SETUP.md) - Detailed setup
3. [FEATURES.md](FEATURES.md) - Architecture
4. [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Details
5. Code exploration with inline docs
6. [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md) - Integration

## 🔗 Code Files

### Main Application
- `lib/main.dart` - App entry point and navigation
- `pubspec.yaml` - Dependencies and configuration

### Models
- `lib/models/sensor_data.dart` - Data structures

### Services
- `lib/services/sensor_service.dart` - **Sensor integration point**
- `lib/services/storage_service.dart` - Local storage

### State Management
- `lib/providers/sensor_providers.dart` - Riverpod providers

### UI Screens
- `lib/screens/dashboard_screen.dart` - Main dashboard
- `lib/screens/alerts_screen.dart` - Alerts view
- `lib/screens/history_screen.dart` - History view
- `lib/screens/settings_screen.dart` - Settings view

### Tests
- `test/sensor_data_test.dart` - Model tests
- `test/widget_test.dart` - Widget tests

### Configuration
- `analysis_options.yaml` - Linting rules
- `.gitignore` - Git ignore rules
- `.metadata` - Flutter metadata

### Android
- `android/app/build.gradle` - Android build config
- `android/app/src/main/AndroidManifest.xml` - Android manifest
- `android/app/src/main/kotlin/.../MainActivity.kt` - Main activity

## 🆘 Troubleshooting

### Can't run the app
→ [SETUP.md#troubleshooting](SETUP.md#troubleshooting)
→ [QUICK_START.md#troubleshooting](QUICK_START.md#troubleshooting)

### Can't install dependencies
→ [SETUP.md#troubleshooting](SETUP.md#troubleshooting)

### Need to integrate real sensors
→ [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md)

### Charts not showing
→ [QUICK_START.md#troubleshooting](QUICK_START.md#troubleshooting)

### Build errors
→ [SETUP.md#troubleshooting](SETUP.md#troubleshooting)

## 📞 Support

- **Issues**: Open on GitHub
- **Questions**: GitHub Discussions
- **Contributions**: Pull Requests welcome

## ✅ Quick Reference

### Commands
```bash
# Run app
flutter run

# Run tests
flutter test

# Build release
flutter build apk --release

# Analyze code
flutter analyze

# Clean build
flutter clean
```

### Key Files to Modify
- `lib/services/sensor_service.dart` - Real sensor integration
- `lib/models/sensor_data.dart` - Add new sensor types
- `pubspec.yaml` - Add dependencies

### Default Thresholds
- Temperature: 30°C max
- Gas Level: 50 ppm max
- Distance: 20 cm min

### Storage Limits
- History: 1000 readings
- Alert Logs: 500 entries

## 🎓 Learning Resources

### Flutter Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)

### Package Documentation
- [Riverpod](https://riverpod.dev)
- [FL Chart](https://pub.dev/packages/fl_chart)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

### Project Documentation
- See all `.md` files in this repository
- Inline code comments throughout `lib/`

---

## 🎯 Start Here

**New to the project?** → [QUICK_START.md](QUICK_START.md)

**Need to integrate sensors?** → [SENSOR_INTEGRATION_EXAMPLES.md](SENSOR_INTEGRATION_EXAMPLES.md)

**Want to understand everything?** → [README.md](README.md) then [FEATURES.md](FEATURES.md)

---

**Last Updated**: October 2025
**Version**: 1.0.0
**Status**: ✅ Production Ready
