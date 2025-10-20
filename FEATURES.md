# Smart Lab Guardian - Features & Architecture

## Overview

Smart Lab Guardian is a comprehensive Flutter application designed to monitor laboratory safety in real-time. The app provides continuous monitoring of critical environmental parameters and alerts users when safety thresholds are breached.

## Core Features

### 1. Real-Time Dashboard 📊

The dashboard provides an at-a-glance view of all critical lab parameters:

- **Live Sensor Readings**
  - Temperature monitoring (°C)
  - Gas level detection (ppm)
  - Fire detection status
  - Distance/proximity sensing (cm)

- **Visual Status Indicators**
  - Color-coded cards for each sensor
  - Red indicators for threshold breaches
  - Normal state indicators in blue/green/orange

- **Historical Charts**
  - Line charts showing trends over time
  - Last 20 data points displayed
  - Threshold lines overlaid on charts
  - Smooth curve interpolation for better visualization

- **Auto-Refresh**
  - Pull-to-refresh functionality
  - Real-time updates every second
  - Automatic chart updates

### 2. Alert System 🚨

Comprehensive alert management and logging:

- **Active Alerts Section**
  - Real-time display of current threshold breaches
  - Visual warning indicators
  - Alert count badge
  - Color-coded severity (red for active alerts, green for normal)

- **Alert History**
  - Complete log of all alerts
  - Timestamped entries
  - Severity classification (Info, Warning, Critical)
  - Color-coded alert cards
  - Searchable history

- **Alert Types**
  - Temperature exceeds maximum threshold
  - Gas level exceeds maximum threshold
  - Fire detected
  - Distance below minimum threshold

- **Alert Management**
  - Clear all logs option
  - Persistent storage of alert history
  - Automatic alert generation

### 3. Settings Screen ⚙️

Customizable safety parameters:

- **Threshold Configuration**
  - Temperature threshold (15°C - 50°C)
  - Gas level threshold (0 - 100 ppm)
  - Minimum distance threshold (5 - 100 cm)
  - Interactive sliders for easy adjustment
  - Real-time value display

- **Data Management**
  - Clear sensor history
  - Clear all stored data
  - Reset thresholds to defaults
  - Confirmation dialogs for destructive actions

- **Persistent Storage**
  - Settings saved locally
  - Automatic loading on app restart
  - SharedPreferences integration

### 4. History Logs 📜

Comprehensive data logging:

- **Sensor Reading History**
  - Last 1000 sensor readings stored
  - Timestamped entries
  - All sensor values in each entry
  - Latest reading highlighted

- **Summary Statistics**
  - Average temperature
  - Average gas level
  - Average distance
  - Total reading count

- **Data Visualization**
  - Card-based layout
  - Color-coded sensor values
  - Easy-to-read format
  - Chronological ordering

- **Data Management**
  - Clear history option
  - Automatic pruning (keeps last 1000)
  - Export capability (future enhancement)

### 5. Navigation 🧭

Intuitive bottom navigation bar:

- **Dashboard Tab** - Main monitoring view
- **Alerts Tab** - Alert notifications (with badge when active)
- **History Tab** - Sensor reading logs
- **Settings Tab** - Configuration and data management

### 6. State Management 🔄

Robust state handling with Riverpod:

- **Reactive Updates**
  - Automatic UI updates on state changes
  - Stream-based sensor data
  - Provider-based state propagation

- **Auto-Save Features**
  - Periodic history saving (every 5 seconds)
  - Automatic alert logging
  - Background data persistence

- **Provider Architecture**
  - Separation of concerns
  - Testable components
  - Clean dependency injection

## Technical Architecture

### Data Flow

```
Sensor Service → Stream Provider → UI Components
                       ↓
                 State Notifiers
                       ↓
                 Storage Service
```

### Component Structure

```
┌─────────────────────────────────────┐
│           Main App (Riverpod)       │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       │                │
       ▼                ▼
┌──────────┐     ┌──────────┐
│ Services │     │Providers │
└──────────┘     └──────────┘
       │                │
       ▼                ▼
┌──────────┐     ┌──────────┐
│  Models  │     │ Screens  │
└──────────┘     └──────────┘
```

### Key Components

#### Models
- **SensorData**: Sensor reading data structure
- **SensorThresholds**: Configurable safety limits
- **AlertLog**: Alert event records

#### Services
- **SensorService**: Generates/receives sensor data
- **StorageService**: Persists data locally

#### Providers
- **sensorServiceProvider**: Service instance
- **storageServiceProvider**: Storage instance
- **sensorDataStreamProvider**: Real-time data stream
- **thresholdsProvider**: Threshold configuration
- **historyProvider**: Reading history
- **alertLogsProvider**: Alert logs
- **activeAlertsProvider**: Current alerts

#### Screens
- **DashboardScreen**: Main monitoring interface
- **AlertsScreen**: Alert management
- **HistoryScreen**: Data logs
- **SettingsScreen**: Configuration

## Data Storage

### SharedPreferences Keys

- `sensor_thresholds`: Threshold configuration JSON
- `sensor_history`: Array of last 1000 readings
- `alert_logs`: Array of last 500 alerts

### Storage Limits

- **History**: 1000 sensor readings (~100KB)
- **Alerts**: 500 alert logs (~50KB)
- **Total**: ~150KB maximum storage

## Sensor Simulation

The app includes a sophisticated sensor simulator:

- **Temperature**: 20°C - 40°C range with gradual drift
- **Gas Level**: 0 - 100 ppm with fluctuations
- **Fire Detection**: Random 2% probability events
- **Distance**: 5 - 200 cm with movement simulation

### Simulation Features

- Realistic value changes
- Natural variations
- Threshold breach scenarios
- Easily replaceable with real sensors

## Real Sensor Integration

The app is designed for easy integration with real sensors:

### Supported Integration Types

1. **Serial/USB** (Arduino, ESP32)
2. **HTTP/REST APIs**
3. **MQTT** (IoT networks)
4. **Bluetooth Low Energy**
5. **WebSocket** (real-time connections)

### Integration Points

All sensor integration happens in `SensorService`:
- Clear interface definition
- Stream-based architecture
- JSON data format
- Comprehensive documentation

See `SENSOR_INTEGRATION_EXAMPLES.md` for detailed examples.

## Performance

### Optimization Features

- Stream-based updates (no polling overhead)
- Efficient chart rendering (last 20 points)
- Lazy loading of history
- Automatic data pruning
- Memory-efficient storage

### Update Frequencies

- Sensor data: 1 Hz (1 reading/second)
- History save: 0.2 Hz (every 5 seconds)
- UI refresh: Real-time on data change
- Chart update: Real-time on data change

## Security Considerations

### Data Privacy

- All data stored locally
- No cloud synchronization (by default)
- No user tracking
- No analytics collection

### Permissions

- No special permissions required for simulation mode
- Real sensor mode may require:
  - Bluetooth (for BLE sensors)
  - Location (Android BLE requirement)
  - Internet (for HTTP/MQTT sensors)
  - USB (for serial sensors)

## Accessibility

- High contrast indicators
- Color-coded status (accessible color palette)
- Clear text labels
- Large touch targets
- Screen reader compatible (Material Design)

## Customization

### Easily Modifiable Parameters

In `lib/services/storage_service.dart`:
```dart
static const int _maxHistoryItems = 1000;
static const int _maxAlertLogs = 500;
```

In `lib/models/sensor_data.dart`:
```dart
factory SensorThresholds.defaults() => const SensorThresholds(
  maxTemperature: 30.0,
  maxGasLevel: 50.0,
  minDistance: 20.0,
);
```

In `lib/providers/sensor_providers.dart`:
```dart
return service.startSensorStream(interval: 1000);
```

## Future Enhancements

Potential additions:

- [ ] Export data to CSV/Excel
- [ ] Email/SMS notifications
- [ ] Cloud synchronization
- [ ] Multiple location monitoring
- [ ] Historical data analysis
- [ ] Predictive alerts
- [ ] Sensor calibration interface
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Widget for home screen

## Testing

### Test Coverage

- Unit tests for data models
- Widget tests for UI components
- Integration tests (can be added)
- Simulation testing included

### Test Files

- `test/sensor_data_test.dart` - Model tests
- `test/widget_test.dart` - UI tests

## Dependencies

### Core Dependencies

- `flutter_riverpod` - State management
- `fl_chart` - Chart rendering
- `shared_preferences` - Local storage
- `intl` - Date formatting

### Optional Dependencies (for real sensors)

- `http` - REST API integration
- `mqtt_client` - MQTT integration
- `flutter_blue_plus` - BLE integration
- `usb_serial` - Serial integration
- `web_socket_channel` - WebSocket integration

## License

MIT License - Free for personal and commercial use

## Support

For questions or issues:
- Check README.md
- Review SETUP.md
- See SENSOR_INTEGRATION_EXAMPLES.md
- Open GitHub issue
