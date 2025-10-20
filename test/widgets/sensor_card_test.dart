import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_lab_guardian/models/sensor_reading.dart';
import 'package:smart_lab_guardian/widgets/sensor_card.dart';

void main() {
  group('SensorCard', () {
    testWidgets('displays temperature reading', (WidgetTester tester) async {
      final reading = SensorReading(
        sensorType: 'temperature',
        value: 25.5,
        timestamp: DateTime.now(),
        status: SensorStatus.safe,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SensorCard(
              reading: reading,
              unit: '°C',
              icon: Icons.thermostat,
            ),
          ),
        ),
      );

      expect(find.text('Temperature'), findsOneWidget);
      expect(find.text('25.5 °C'), findsOneWidget);
      expect(find.text('SAFE'), findsOneWidget);
      expect(find.byIcon(Icons.thermostat), findsOneWidget);
    });

    testWidgets('displays warning status with orange color', (WidgetTester tester) async {
      final reading = SensorReading(
        sensorType: 'gas',
        value: 350.0,
        timestamp: DateTime.now(),
        status: SensorStatus.warning,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SensorCard(
              reading: reading,
              unit: 'PPM',
              icon: Icons.cloud,
            ),
          ),
        ),
      );

      expect(find.text('WARNING'), findsOneWidget);
      expect(find.text('350.0 PPM'), findsOneWidget);
    });

    testWidgets('displays danger status with red color', (WidgetTester tester) async {
      final reading = SensorReading(
        sensorType: 'temperature',
        value: 45.0,
        timestamp: DateTime.now(),
        status: SensorStatus.danger,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SensorCard(
              reading: reading,
              unit: '°C',
              icon: Icons.thermostat,
            ),
          ),
        ),
      );

      expect(find.text('DANGER'), findsOneWidget);
      expect(find.text('45.0 °C'), findsOneWidget);
    });

    testWidgets('displays fire detection correctly', (WidgetTester tester) async {
      final reading = SensorReading(
        sensorType: 'fire',
        value: 1.0,
        timestamp: DateTime.now(),
        status: SensorStatus.danger,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SensorCard(
              reading: reading,
              unit: '',
              icon: Icons.local_fire_department,
            ),
          ),
        ),
      );

      expect(find.text('Fire Detector'), findsOneWidget);
      expect(find.text('FIRE DETECTED'), findsOneWidget);
      expect(find.text('DANGER'), findsOneWidget);
    });
  });
}
