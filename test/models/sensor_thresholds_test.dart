import 'package:flutter_test/flutter_test.dart';
import 'package:smart_lab_guardian/models/sensor_thresholds.dart';

void main() {
  group('SensorThresholds', () {
    test('creates default thresholds', () {
      final thresholds = SensorThresholds.defaults();

      expect(thresholds.temperatureWarning, 30.0);
      expect(thresholds.temperatureDanger, 40.0);
      expect(thresholds.gasWarning, 300.0);
      expect(thresholds.gasDanger, 500.0);
      expect(thresholds.distanceWarning, 50.0);
      expect(thresholds.distanceDanger, 20.0);
    });

    test('converts to and from JSON', () {
      final original = SensorThresholds(
        temperatureWarning: 25.0,
        temperatureDanger: 35.0,
        gasWarning: 250.0,
        gasDanger: 450.0,
        distanceWarning: 60.0,
        distanceDanger: 30.0,
      );

      final json = original.toJson();
      final restored = SensorThresholds.fromJson(json);

      expect(restored.temperatureWarning, original.temperatureWarning);
      expect(restored.temperatureDanger, original.temperatureDanger);
      expect(restored.gasWarning, original.gasWarning);
      expect(restored.gasDanger, original.gasDanger);
      expect(restored.distanceWarning, original.distanceWarning);
      expect(restored.distanceDanger, original.distanceDanger);
    });

    test('copyWith creates a new instance with updated fields', () {
      final original = SensorThresholds.defaults();
      final updated = original.copyWith(
        temperatureWarning: 35.0,
        gasDanger: 600.0,
      );

      expect(updated.temperatureWarning, 35.0);
      expect(updated.gasDanger, 600.0);
      expect(updated.temperatureDanger, original.temperatureDanger);
      expect(updated.gasWarning, original.gasWarning);
    });
  });
}
