# Architecture Documentation

This document describes the architecture and design patterns used in Smart Lab Guardian.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  ┌────────────┐  ┌────────────┐  ┌───────────────────────┐ │
│  │ Dashboard  │  │   Alerts   │  │      Settings         │ │
│  │  Screen    │  │   Screen   │  │       Screen          │ │
│  └────────────┘  └────────────┘  └───────────────────────┘ │
│         ▲                ▲                    ▲              │
└─────────┼────────────────┼────────────────────┼──────────────┘
          │                │                    │
┌─────────┴────────────────┴────────────────────┴──────────────┐
│                   State Management Layer                      │
│                      (Riverpod Providers)                     │
│  ┌────────────────────┐         ┌────────────────────────┐  │
│  │ SensorReadings     │         │   Thresholds           │  │
│  │    Provider        │         │    Provider            │  │
│  └────────────────────┘         └────────────────────────┘  │
│  ┌────────────────────┐                                      │
│  │    Alerts          │                                      │
│  │    Provider        │                                      │
│  └────────────────────┘                                      │
└───────────────────────┬──────────────────┬───────────────────┘
                        │                  │
┌───────────────────────┴──────────────────┴───────────────────┐
│                    Business Logic Layer                       │
│  ┌─────────────────────┐      ┌──────────────────────────┐  │
│  │   SensorService     │      │   StorageService         │  │
│  │ (Data Streaming)    │      │  (Data Persistence)      │  │
│  └─────────────────────┘      └──────────────────────────┘  │
└───────────────────────┬──────────────────┬───────────────────┘
                        │                  │
┌───────────────────────┴──────────────────┴───────────────────┐
│                       Data Layer                              │
│  ┌─────────────────┐  ┌──────────────┐  ┌────────────────┐  │
│  │ SensorReading   │  │  Thresholds  │  │     Alert      │  │
│  │     Model       │  │    Model     │  │     Model      │  │
│  └─────────────────┘  └──────────────┘  └────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

## Design Patterns

### 1. Clean Architecture

The app follows clean architecture principles with clear separation of concerns:

- **Presentation**: UI widgets and screens
- **State Management**: Riverpod providers
- **Business Logic**: Service classes
- **Data**: Models and storage

### 2. Repository Pattern

`StorageService` acts as a repository, abstracting data persistence:
- Easy to swap SharedPreferences for Hive or Firebase
- Single source of truth for data operations
- Testable with mock implementations

### 3. Stream-Based Architecture

`SensorService` uses Dart streams for real-time data:
- Reactive updates to UI
- Automatic garbage collection
- Easy to test with stream controllers

### 4. Provider Pattern (Riverpod)

State management uses Riverpod for:
- Dependency injection
- Automatic disposal
- Compile-time safety
- Easy testing

## Component Details

### Models

#### SensorReading
```dart
class SensorReading {
  final String sensorType;
  final double value;
  final DateTime timestamp;
  final SensorStatus status;
}
```

Represents a single sensor measurement with metadata.

#### SensorThresholds
```dart
class SensorThresholds {
  final double temperatureWarning;
  final double temperatureDanger;
  // ... other thresholds
}
```

Configuration object for alert thresholds.

#### Alert
```dart
class Alert {
  final String id;
  final String sensorType;
  final double value;
  final DateTime timestamp;
  final SensorStatus severity;
  final bool acknowledged;
}
```

Represents a triggered alert event.

### Services

#### SensorService

**Responsibilities:**
- Generate/fetch sensor readings
- Stream data to providers
- Apply threshold logic
- Manage sensor connections

**Key Methods:**
```dart
Stream<Map<String, SensorReading>> get sensorStream;
void setThresholds(SensorThresholds thresholds);
void dispose();
```

**Current Implementation:**
- Simulates sensor data
- Updates every 3 seconds
- Random values within realistic ranges

**Future Implementation:**
- Connect to real sensors via Bluetooth/WiFi
- Handle connection errors
- Support multiple sensor types

#### StorageService

**Responsibilities:**
- Save/load thresholds
- Persist sensor readings
- Store alerts
- Manage local database

**Key Methods:**
```dart
Future<void> saveThresholds(SensorThresholds);
Future<SensorThresholds> loadThresholds();
Future<void> saveSensorReading(SensorReading);
Future<List<SensorReading>> loadReadingHistory();
```

### Providers

#### SensorReadingsProvider
```dart
final sensorReadingsProvider = 
    StreamProvider<Map<String, SensorReading>>;
```

Provides real-time sensor data to UI.

#### ThresholdsProvider
```dart
final thresholdsProvider = 
    StateNotifierProvider<ThresholdsNotifier, SensorThresholds>;
```

Manages threshold configuration and persistence.

#### AlertsProvider
```dart
final alertsProvider = 
    StateNotifierProvider<AlertsNotifier, List<Alert>>;
```

Manages alerts, listens to sensor readings, creates new alerts.

### Screens

#### DashboardScreen
- Displays real-time sensor cards
- Shows status with color coding
- Pull-to-refresh support

#### AlertsScreen
- Lists all alerts
- Allows acknowledgment
- Clear acknowledged alerts

#### SettingsScreen
- Slider controls for thresholds
- Real-time preview
- Auto-save functionality

## Data Flow

### Reading Sensors

```
SensorService (generates data)
    ↓
sensorReadingsProvider (streams data)
    ↓
DashboardScreen (displays data)
```

### Creating Alerts

```
SensorService (generates reading with warning/danger status)
    ↓
sensorReadingsProvider (emits reading)
    ↓
AlertsProvider (listens, creates alert)
    ↓
StorageService (persists alert)
    ↓
AlertsScreen (displays alert)
```

### Updating Thresholds

```
SettingsScreen (user adjusts slider)
    ↓
ThresholdsNotifier (updates state)
    ↓
SensorService (updates thresholds)
    ↓
StorageService (persists changes)
```

## State Management Flow

```
User Action
    ↓
Widget calls Provider method
    ↓
Provider updates state
    ↓
Service performs operation
    ↓
Storage persists data (if needed)
    ↓
Provider notifies listeners
    ↓
Widgets rebuild with new state
```

## Testing Strategy

### Unit Tests
- Models: Serialization, copyWith
- Services: Business logic, data generation
- Providers: State updates, side effects

### Widget Tests
- Individual widgets: SensorCard, AlertCard
- User interactions: Tap, scroll, input
- State changes: Loading, error, data

### Integration Tests
- Full user flows
- Screen navigation
- Data persistence

## Performance Considerations

### Optimizations

1. **Stream Management**
   - Single shared stream for sensors
   - Automatic disposal with providers
   - Efficient broadcast stream

2. **Widget Rebuilds**
   - Riverpod minimizes unnecessary rebuilds
   - Const constructors where possible
   - Selective watching of providers

3. **Data Storage**
   - Limited history (last 100 readings)
   - Lazy loading of data
   - Efficient JSON serialization

### Scalability

**Current Limitations:**
- Local storage only
- Single device
- Fixed sensor types

**Future Improvements:**
- Cloud sync with Firebase
- Multi-device support
- Dynamic sensor configuration
- Batch data operations

## Error Handling

### Strategy

1. **Service Layer**
   - Try-catch blocks
   - Default values for failures
   - Error logging

2. **Provider Layer**
   - AsyncValue for loading states
   - Error state propagation
   - Retry mechanisms

3. **UI Layer**
   - Error messages to user
   - Fallback UI
   - Offline support

## Security Considerations

### Current Implementation
- Local storage only (no network exposure)
- No authentication required
- Data stored in app sandbox

### Future Considerations
- Encrypt sensitive data
- Secure Firebase rules
- User authentication
- API key protection
- HTTPS only for network calls

## Extensibility

### Adding New Sensor Types

1. Update `SensorService._generateReadings()`
2. Add thresholds to `SensorThresholds`
3. Update Settings UI
4. Add icon and formatting

### Adding Cloud Sync

1. Add Firebase packages
2. Extend `StorageService`
3. Update providers for sync
4. Add authentication

### Adding Notifications

1. Add notification service
2. Integrate with alert creation
3. Handle permissions
4. Background notification handling

## Dependencies

### Core Dependencies
- `flutter`: Framework
- `flutter_riverpod`: State management
- `shared_preferences`: Local storage

### UI Dependencies
- `fl_chart`: Charts
- `intl`: Date formatting

### Future Dependencies
- `firebase_core`: Firebase initialization
- `cloud_firestore`: Cloud database
- `firebase_messaging`: Push notifications
- `flutter_bluetooth_serial`: Bluetooth sensors

## Build Configuration

### Development
```bash
flutter run --debug
```

### Production
```bash
flutter build apk --release
flutter build ios --release
```

### Testing
```bash
flutter test
flutter test --coverage
```

## Monitoring and Logging

### Current Logging
- Print statements for debugging
- Error messages in catch blocks

### Recommended Production Logging
- Firebase Crashlytics
- Sentry for error tracking
- Analytics for usage patterns
- Custom logging service

## Deployment

### Android
- APK/AAB distribution
- Google Play Store
- Side-loading support

### iOS
- IPA distribution
- Apple App Store
- TestFlight for beta testing

### Web
- Static hosting (Firebase Hosting, Netlify)
- Progressive Web App support
- HTTPS required

## Maintenance

### Regular Tasks
- Update dependencies
- Review security issues
- Performance monitoring
- User feedback incorporation

### Code Quality
- Run `flutter analyze`
- Use `dart format`
- Maintain test coverage
- Code reviews

## Resources

- [Flutter Architecture](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Riverpod Documentation](https://riverpod.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

For implementation details, see the source code and inline comments.
