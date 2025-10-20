import 'dart:async';
import 'dart:math';
import '../models/sensor_reading.dart';
import '../models/sensor_thresholds.dart';

/// Service that simulates sensor readings and streams data
/// 
/// In a real implementation, this would connect to actual hardware sensors
/// via Bluetooth, WiFi, or serial connection. The stream would emit real-time
/// data from physical sensors.
class SensorService {
  final Random _random = Random();
  StreamController<Map<String, SensorReading>>? _controller;
  Timer? _timer;
  SensorThresholds _thresholds = SensorThresholds.defaults();

  /// Current sensor readings
  final Map<String, SensorReading> _currentReadings = {};

  /// Sets the thresholds for determining sensor status
  void setThresholds(SensorThresholds thresholds) {
    _thresholds = thresholds;
  }

  /// Stream of sensor readings
  /// Emits a map of all sensor readings every few seconds
  Stream<Map<String, SensorReading>> get sensorStream {
    _controller ??= StreamController<Map<String, SensorReading>>.broadcast(
      onListen: _startSimulation,
      onCancel: _stopSimulation,
    );
    return _controller!.stream;
  }

  /// Starts simulating sensor data
  void _startSimulation() {
    // Generate initial readings
    _generateReadings();
    
    // Update readings every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _generateReadings();
      _controller?.add(Map.from(_currentReadings));
    });
  }

  /// Stops the simulation
  void _stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }

  /// Generates simulated sensor readings
  /// 
  /// Real implementation would read from actual sensors here.
  /// Example integrations:
  /// - Temperature: DS18B20, DHT22 via I2C/OneWire
  /// - Gas: MQ-2, MQ-135 via analog input
  /// - Fire: Flame sensor via digital input
  /// - Distance: HC-SR04 ultrasonic sensor via GPIO
  void _generateReadings() {
    // Temperature sensor (Celsius): 15-45°C range
    final temp = 20.0 + _random.nextDouble() * 25.0;
    _currentReadings['temperature'] = SensorReading(
      sensorType: 'temperature',
      value: temp,
      timestamp: DateTime.now(),
      status: _getTemperatureStatus(temp),
    );

    // Gas sensor (PPM): 0-1000 PPM range
    final gas = _random.nextDouble() * 800.0;
    _currentReadings['gas'] = SensorReading(
      sensorType: 'gas',
      value: gas,
      timestamp: DateTime.now(),
      status: _getGasStatus(gas),
    );

    // Fire detection (0=no fire, 1=fire detected)
    // Simulated as occasionally detecting fire
    final fire = _random.nextDouble() < 0.05 ? 1.0 : 0.0;
    _currentReadings['fire'] = SensorReading(
      sensorType: 'fire',
      value: fire,
      timestamp: DateTime.now(),
      status: fire > 0 ? SensorStatus.danger : SensorStatus.safe,
    );

    // Distance sensor (cm): 0-200 cm range
    final distance = _random.nextDouble() * 200.0;
    _currentReadings['distance'] = SensorReading(
      sensorType: 'distance',
      value: distance,
      timestamp: DateTime.now(),
      status: _getDistanceStatus(distance),
    );
  }

  /// Determines temperature status based on thresholds
  SensorStatus _getTemperatureStatus(double value) {
    if (value >= _thresholds.temperatureDanger) {
      return SensorStatus.danger;
    } else if (value >= _thresholds.temperatureWarning) {
      return SensorStatus.warning;
    }
    return SensorStatus.safe;
  }

  /// Determines gas status based on thresholds
  SensorStatus _getGasStatus(double value) {
    if (value >= _thresholds.gasDanger) {
      return SensorStatus.danger;
    } else if (value >= _thresholds.gasWarning) {
      return SensorStatus.warning;
    }
    return SensorStatus.safe;
  }

  /// Determines distance status based on thresholds
  SensorStatus _getDistanceStatus(double value) {
    if (value <= _thresholds.distanceDanger) {
      return SensorStatus.danger;
    } else if (value <= _thresholds.distanceWarning) {
      return SensorStatus.warning;
    }
    return SensorStatus.safe;
  }

  /// Gets the current readings without subscribing to stream
  Map<String, SensorReading> getCurrentReadings() {
    return Map.from(_currentReadings);
  }

  /// Disposes of resources
  void dispose() {
    _timer?.cancel();
    _controller?.close();
  }
}
