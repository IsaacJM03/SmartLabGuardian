import 'package:flutter_test/flutter_test.dart';
import 'package:smart_lab_guardian/models/sensor_reading.dart';

void main() {
  group('SensorReading', () {
    test('creates a sensor reading with all fields', () {
      final reading = SensorReading(
        sensorType: 'temperature',
        value: 25.5,
        timestamp: DateTime(2024, 1, 1),
        status: SensorStatus.safe,
      );

      expect(reading.sensorType, 'temperature');
      expect(reading.value, 25.5);
      expect(reading.status, SensorStatus.safe);
    });

    test('converts to and from JSON', () {
      final original = SensorReading(
        sensorType: 'gas',
        value: 150.0,
        timestamp: DateTime(2024, 1, 1, 12, 0),
        status: SensorStatus.warning,
      );

      final json = original.toJson();
      final restored = SensorReading.fromJson(json);

      expect(restored.sensorType, original.sensorType);
      expect(restored.value, original.value);
      expect(restored.status, original.status);
    });

    test('copyWith creates a new instance with updated fields', () {
      final original = SensorReading(
        sensorType: 'temperature',
        value: 25.0,
        timestamp: DateTime(2024, 1, 1),
        status: SensorStatus.safe,
      );

      final updated = original.copyWith(
        value: 35.0,
        status: SensorStatus.warning,
      );

      expect(updated.value, 35.0);
      expect(updated.status, SensorStatus.warning);
      expect(updated.sensorType, original.sensorType);
    });
  });

  group('SensorStatus', () {
    test('has correct enum values', () {
      expect(SensorStatus.values.length, 3);
      expect(SensorStatus.values.contains(SensorStatus.safe), true);
      expect(SensorStatus.values.contains(SensorStatus.warning), true);
      expect(SensorStatus.values.contains(SensorStatus.danger), true);
    });
  });
}
