# Smart Lab Guardian

A Flutter application for monitoring lab safety with real-time sensor data, alerts, and history tracking.

## Features

- **Real-time Dashboard**: Monitor temperature, gas levels, fire detection, and distance sensors with live charts
- **Alert System**: Automatic threshold breach detection with visual and logged notifications
- **Settings Management**: Adjustable safety thresholds saved locally
- **History Tracking**: Complete log of all sensor readings
- **State Management**: Riverpod for reactive state management
- **Local Storage**: SharedPreferences for persistent data storage

## Architecture

```
lib/
├── main.dart                    # App entry point with bottom navigation
├── models/
│   └── sensor_data.dart        # Data models for sensors, thresholds, and alerts
├── services/
│   ├── sensor_service.dart     # Simulated sensor data service (replace with real sensors)
│   └── storage_service.dart    # Local storage with SharedPreferences
├── providers/
│   └── sensor_providers.dart   # Riverpod providers for state management
└── screens/
    ├── dashboard_screen.dart   # Real-time monitoring with charts
    ├── alerts_screen.dart      # Active alerts and alert history
    ├── history_screen.dart     # Sensor reading history
    └── settings_screen.dart    # Threshold configuration
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/IsaacJM03/SmartLabGuardian.git
cd SmartLabGuardian
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Real Sensor Integration

The app currently uses simulated sensor data. To integrate real sensors, replace `SensorService` in `lib/services/sensor_service.dart` with your actual sensor interface.

### Supported Integration Patterns

#### 1. Arduino/ESP32 via Serial/USB
```dart
class ArduinoSensorService extends SensorService {
  final SerialPort port;
  
  Stream<SensorData> startSensorStream() {
    return port.inputStream.map((data) {
      final line = String.fromCharCodes(data);
      // Parse format: "TEMP:25.5,GAS:30.2,FIRE:0,DIST:45.3"
      return _parseArduinoData(line);
    });
  }
}
```

#### 2. HTTP/REST API
```dart
class HttpSensorService extends SensorService {
  final String apiUrl;
  
  Stream<SensorData> startSensorStream() {
    return Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
      final response = await http.get(Uri.parse(apiUrl));
      return SensorData.fromJson(jsonDecode(response.body));
    });
  }
}
```

#### 3. MQTT
```dart
class MqttSensorService extends SensorService {
  final MqttClient client;
  
  Stream<SensorData> startSensorStream() {
    return client.updates!.map((messages) {
      final payload = MqttPublishPayload.bytesToStringAsString(
        messages[0].payload.message
      );
      return SensorData.fromJson(jsonDecode(payload));
    });
  }
}
```

#### 4. Bluetooth Low Energy
```dart
class BleSensorService extends SensorService {
  final BluetoothDevice device;
  
  Stream<SensorData> startSensorStream() async {
    await device.connect();
    final services = await device.discoverServices();
    final characteristic = services[0].characteristics[0];
    await characteristic.setNotifyValue(true);
    
    return characteristic.value.map((bytes) {
      return _parseBleSensorData(bytes);
    });
  }
}
```

### Integration Steps

1. Add required packages to `pubspec.yaml` (e.g., `http`, `mqtt_client`, `flutter_blue_plus`, `usb_serial`)
2. Replace `SensorService` implementation in `lib/services/sensor_service.dart`
3. Update the provider in `lib/providers/sensor_providers.dart` if needed
4. Keep the `SensorData` model structure - it works with any data source

## Default Thresholds

- **Temperature**: 30°C maximum
- **Gas Level**: 50 ppm maximum
- **Distance**: 20 cm minimum

These can be adjusted in the Settings screen and are persisted locally.

## Storage

The app uses SharedPreferences for local storage:
- **Thresholds**: User-configured alert thresholds
- **History**: Last 1000 sensor readings
- **Alert Logs**: Last 500 alert events

## State Management

The app uses Riverpod for state management with the following providers:
- `sensorServiceProvider`: Sensor service instance
- `storageServiceProvider`: Storage service instance
- `sensorDataStreamProvider`: Real-time sensor data stream
- `thresholdsProvider`: Configurable thresholds
- `historyProvider`: Sensor reading history
- `alertLogsProvider`: Alert event logs
- `activeAlertsProvider`: Current active alerts

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.