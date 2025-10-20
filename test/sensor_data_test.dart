import 'package:flutter_test/flutter_test.dart';
import 'package:smart_lab_guardian/models/sensor_data.dart';

void main() {
  group('SensorData', () {
    test('should create sensor data with values', () {
      final now = DateTime.now();
      final data = SensorData(
        temperature: 25.5,
        gasLevel: 30.0,
        fireDetected: false,
        distance: 50.0,
        timestamp: now,
      );

      expect(data.temperature, 25.5);
      expect(data.gasLevel, 30.0);
      expect(data.fireDetected, false);
      expect(data.distance, 50.0);
      expect(data.timestamp, now);
    });

    test('should detect alert when temperature exceeds threshold', () {
      final data = SensorData(
        temperature: 35.0,
        gasLevel: 20.0,
        fireDetected: false,
        distance: 50.0,
        timestamp: DateTime.now(),
      );

      final thresholds = SensorThresholds.defaults();
      expect(data.hasAlert(thresholds), true);
      expect(data.getAlerts(thresholds).length, 1);
      expect(data.getAlerts(thresholds)[0], contains('Temperature'));
    });

    test('should detect alert when gas level exceeds threshold', () {
      final data = SensorData(
        temperature: 25.0,
        gasLevel: 60.0,
        fireDetected: false,
        distance: 50.0,
        timestamp: DateTime.now(),
      );

      final thresholds = SensorThresholds.defaults();
      expect(data.hasAlert(thresholds), true);
      expect(data.getAlerts(thresholds).length, 1);
      expect(data.getAlerts(thresholds)[0], contains('Gas'));
    });

    test('should detect alert when fire is detected', () {
      final data = SensorData(
        temperature: 25.0,
        gasLevel: 20.0,
        fireDetected: true,
        distance: 50.0,
        timestamp: DateTime.now(),
      );

      final thresholds = SensorThresholds.defaults();
      expect(data.hasAlert(thresholds), true);
      expect(data.getAlerts(thresholds).length, 1);
      expect(data.getAlerts(thresholds)[0], contains('Fire'));
    });

    test('should detect alert when distance is below threshold', () {
      final data = SensorData(
        temperature: 25.0,
        gasLevel: 20.0,
        fireDetected: false,
        distance: 10.0,
        timestamp: DateTime.now(),
      );

      final thresholds = SensorThresholds.defaults();
      expect(data.hasAlert(thresholds), true);
      expect(data.getAlerts(thresholds).length, 1);
      expect(data.getAlerts(thresholds)[0], contains('Distance'));
    });

    test('should not have alerts when all values are within thresholds', () {
      final data = SensorData(
        temperature: 25.0,
        gasLevel: 20.0,
        fireDetected: false,
        distance: 50.0,
        timestamp: DateTime.now(),
      );

      final thresholds = SensorThresholds.defaults();
      expect(data.hasAlert(thresholds), false);
      expect(data.getAlerts(thresholds).isEmpty, true);
    });

    test('should serialize to JSON and back', () {
      final now = DateTime.now();
      final data = SensorData(
        temperature: 25.5,
        gasLevel: 30.0,
        fireDetected: false,
        distance: 50.0,
        timestamp: now,
      );

      final json = data.toJson();
      final restored = SensorData.fromJson(json);

      expect(restored.temperature, data.temperature);
      expect(restored.gasLevel, data.gasLevel);
      expect(restored.fireDetected, data.fireDetected);
      expect(restored.distance, data.distance);
      // Compare timestamps with a small tolerance
      expect(
        restored.timestamp.difference(data.timestamp).inSeconds,
        lessThan(1),
      );
    });
  });

  group('SensorThresholds', () {
    test('should create default thresholds', () {
      final thresholds = SensorThresholds.defaults();

      expect(thresholds.maxTemperature, 30.0);
      expect(thresholds.maxGasLevel, 50.0);
      expect(thresholds.minDistance, 20.0);
    });

    test('should copy with new values', () {
      final thresholds = SensorThresholds.defaults();
      final updated = thresholds.copyWith(maxTemperature: 35.0);

      expect(updated.maxTemperature, 35.0);
      expect(updated.maxGasLevel, thresholds.maxGasLevel);
      expect(updated.minDistance, thresholds.minDistance);
    });

    test('should serialize to JSON and back', () {
      final thresholds = SensorThresholds(
        maxTemperature: 32.0,
        maxGasLevel: 55.0,
        minDistance: 25.0,
      );

      final json = thresholds.toJson();
      final restored = SensorThresholds.fromJson(json);

      expect(restored.maxTemperature, thresholds.maxTemperature);
      expect(restored.maxGasLevel, thresholds.maxGasLevel);
      expect(restored.minDistance, thresholds.minDistance);
    });
  });

  group('AlertLog', () {
    test('should create alert log', () {
      final now = DateTime.now();
      final log = AlertLog(
        message: 'Test alert',
        timestamp: now,
        severity: AlertSeverity.warning,
      );

      expect(log.message, 'Test alert');
      expect(log.timestamp, now);
      expect(log.severity, AlertSeverity.warning);
    });

    test('should serialize to JSON and back', () {
      final now = DateTime.now();
      final log = AlertLog(
        message: 'Test alert',
        timestamp: now,
        severity: AlertSeverity.critical,
      );

      final json = log.toJson();
      final restored = AlertLog.fromJson(json);

      expect(restored.message, log.message);
      expect(restored.severity, log.severity);
      expect(
        restored.timestamp.difference(log.timestamp).inSeconds,
        lessThan(1),
      );
    });
  });
}
