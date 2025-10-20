import 'package:flutter_test/flutter_test.dart';
import 'package:smart_lab_guardian/services/sensor_service.dart';
import 'package:smart_lab_guardian/models/sensor_thresholds.dart';

void main() {
  group('SensorService', () {
    late SensorService service;

    setUp(() {
      service = SensorService();
    });

    tearDown(() {
      service.dispose();
    });

    test('emits sensor readings when subscribed', () async {
      final thresholds = SensorThresholds.defaults();
      service.setThresholds(thresholds);

      final readings = await service.sensorStream.first;

      expect(readings.containsKey('temperature'), true);
      expect(readings.containsKey('gas'), true);
      expect(readings.containsKey('fire'), true);
      expect(readings.containsKey('distance'), true);
    });

    test('temperature values are within expected range', () async {
      final readings = await service.sensorStream.first;
      final temp = readings['temperature']!.value;

      expect(temp, greaterThanOrEqualTo(15.0));
      expect(temp, lessThanOrEqualTo(45.0));
    });

    test('gas values are within expected range', () async {
      final readings = await service.sensorStream.first;
      final gas = readings['gas']!.value;

      expect(gas, greaterThanOrEqualTo(0.0));
      expect(gas, lessThanOrEqualTo(800.0));
    });

    test('fire detection returns binary value', () async {
      final readings = await service.sensorStream.first;
      final fire = readings['fire']!.value;

      expect(fire == 0.0 || fire == 1.0, true);
    });

    test('distance values are within expected range', () async {
      final readings = await service.sensorStream.first;
      final distance = readings['distance']!.value;

      expect(distance, greaterThanOrEqualTo(0.0));
      expect(distance, lessThanOrEqualTo(200.0));
    });

    test('emits multiple readings over time', () async {
      final stream = service.sensorStream;
      final readings = await stream.take(2).toList();

      expect(readings.length, 2);
      expect(readings[0].containsKey('temperature'), true);
      expect(readings[1].containsKey('temperature'), true);
    });
  });
}
