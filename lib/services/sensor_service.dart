import 'dart:async';
import 'dart:math';
import '../models/sensor_data.dart';

/// Service that simulates sensor data for lab monitoring
/// 
/// **REAL SENSOR INTEGRATION NOTES:**
/// Replace this service with actual sensor integration:
/// 1. For Arduino/ESP32: Use serial communication (e.g., flutter_blue_plus, usb_serial)
/// 2. For HTTP/REST API: Use http package to fetch real sensor data
/// 3. For MQTT: Use mqtt_client package to subscribe to sensor topics
/// 4. For Bluetooth: Use flutter_blue_plus to connect to BLE sensors
/// 
/// The SensorData model structure can remain the same for real sensors.
/// Simply replace the _generateSimulatedData() method with your actual
/// sensor reading logic.
class SensorService {
  final _random = Random();
  StreamController<SensorData>? _streamController;
  Timer? _timer;

  // Base values for simulation
  double _baseTemperature = 25.0;
  double _baseGasLevel = 10.0;
  double _baseDistance = 50.0;

  /// Start the sensor data stream
  /// Emits new sensor readings every [interval] milliseconds
  Stream<SensorData> startSensorStream({int interval = 1000}) {
    _streamController?.close();
    _streamController = StreamController<SensorData>.broadcast();

    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      final data = _generateSimulatedData();
      _streamController?.add(data);
    });

    return _streamController!.stream;
  }

  /// Stop the sensor data stream
  void stopSensorStream() {
    _timer?.cancel();
    _streamController?.close();
  }

  /// Generate simulated sensor data with realistic variations
  /// 
  /// **REAL SENSOR INTEGRATION:**
  /// Replace this method with actual sensor reading logic:
  /// ```dart
  /// Future<SensorData> _readRealSensors() async {
  ///   // Example for HTTP endpoint:
  ///   final response = await http.get(Uri.parse('http://sensor-api/data'));
  ///   final json = jsonDecode(response.body);
  ///   return SensorData.fromJson(json);
  ///   
  ///   // Example for serial communication:
  ///   final data = await _serialPort.read();
  ///   return _parseSensorData(data);
  /// }
  /// ```
  SensorData _generateSimulatedData() {
    // Simulate gradual temperature changes
    _baseTemperature += _random.nextDouble() * 2 - 1; // -1 to +1
    _baseTemperature = _baseTemperature.clamp(20.0, 40.0);

    // Simulate gas level fluctuations
    _baseGasLevel += _random.nextDouble() * 10 - 5; // -5 to +5
    _baseGasLevel = _baseGasLevel.clamp(0.0, 100.0);

    // Simulate distance sensor (object detection)
    _baseDistance += _random.nextDouble() * 20 - 10; // -10 to +10
    _baseDistance = _baseDistance.clamp(5.0, 200.0);

    // Occasional fire detection (low probability)
    final fireDetected = _random.nextDouble() < 0.02; // 2% chance

    return SensorData(
      temperature: double.parse(_baseTemperature.toStringAsFixed(1)),
      gasLevel: double.parse(_baseGasLevel.toStringAsFixed(1)),
      fireDetected: fireDetected,
      distance: double.parse(_baseDistance.toStringAsFixed(1)),
      timestamp: DateTime.now(),
    );
  }

  /// Get a single sensor reading
  /// Useful for testing or one-time checks
  SensorData getSingleReading() {
    return _generateSimulatedData();
  }

  /// Trigger alert conditions for testing
  /// In real implementation, this would not be needed
  void simulateAlertCondition() {
    _baseTemperature = 35.0;
    _baseGasLevel = 70.0;
    _baseDistance = 10.0;
  }

  /// Reset to normal conditions
  void resetToNormal() {
    _baseTemperature = 25.0;
    _baseGasLevel = 10.0;
    _baseDistance = 50.0;
  }

  /// Clean up resources
  void dispose() {
    _timer?.cancel();
    _streamController?.close();
  }
}

/// Example integration patterns for real sensors:
/// 
/// **1. Arduino/ESP32 via Serial/USB:**
/// ```dart
/// class ArduinoSensorService extends SensorService {
///   final SerialPort port;
///   
///   Stream<SensorData> startSensorStream() {
///     return port.inputStream.map((data) {
///       final line = String.fromCharCodes(data);
///       // Parse format: "TEMP:25.5,GAS:30.2,FIRE:0,DIST:45.3"
///       return _parseArduinoData(line);
///     });
///   }
/// }
/// ```
/// 
/// **2. HTTP/REST API:**
/// ```dart
/// class HttpSensorService extends SensorService {
///   final String apiUrl;
///   
///   Stream<SensorData> startSensorStream() {
///     return Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
///       final response = await http.get(Uri.parse(apiUrl));
///       return SensorData.fromJson(jsonDecode(response.body));
///     });
///   }
/// }
/// ```
/// 
/// **3. MQTT:**
/// ```dart
/// class MqttSensorService extends SensorService {
///   final MqttClient client;
///   
///   Stream<SensorData> startSensorStream() {
///     return client.updates!.map((messages) {
///       final payload = MqttPublishPayload.bytesToStringAsString(
///         messages[0].payload.message
///       );
///       return SensorData.fromJson(jsonDecode(payload));
///     });
///   }
/// }
/// ```
/// 
/// **4. Bluetooth Low Energy:**
/// ```dart
/// class BleSensorService extends SensorService {
///   final BluetoothDevice device;
///   BluetoothCharacteristic? characteristic;
///   
///   Stream<SensorData> startSensorStream() async {
///     await device.connect();
///     final services = await device.discoverServices();
///     characteristic = services[0].characteristics[0];
///     await characteristic!.setNotifyValue(true);
///     
///     return characteristic!.value.map((bytes) {
///       return _parseBleSensorData(bytes);
///     });
///   }
/// }
/// ```
