import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sensor_provider.dart';
import '../widgets/sensor_card.dart';
import '../models/sensor_reading.dart';

/// Dashboard screen showing real-time sensor readings
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorReadingsAsync = ref.watch(sensorReadingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Safety Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: sensorReadingsAsync.when(
        data: (readings) => _buildDashboard(context, readings),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, Map<String, SensorReading> readings) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh is handled automatically by the stream
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Real-time Monitoring',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sensor readings update every 3 seconds',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            
            // Temperature sensor
            if (readings.containsKey('temperature'))
              SensorCard(
                reading: readings['temperature']!,
                unit: '°C',
                icon: Icons.thermostat,
              ),
            const SizedBox(height: 16),
            
            // Gas sensor
            if (readings.containsKey('gas'))
              SensorCard(
                reading: readings['gas']!,
                unit: 'PPM',
                icon: Icons.cloud,
              ),
            const SizedBox(height: 16),
            
            // Fire sensor
            if (readings.containsKey('fire'))
              SensorCard(
                reading: readings['fire']!,
                unit: '',
                icon: Icons.local_fire_department,
              ),
            const SizedBox(height: 16),
            
            // Distance sensor
            if (readings.containsKey('distance'))
              SensorCard(
                reading: readings['distance']!,
                unit: 'cm',
                icon: Icons.social_distance,
              ),
            
            const SizedBox(height: 32),
            
            // Information card for users
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          'Integration Notes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This app currently displays simulated sensor data. '
                      'To integrate real sensors:\n\n'
                      '1. Modify SensorService to connect to actual hardware\n'
                      '2. Add sensor-specific libraries (e.g., flutter_bluetooth_serial)\n'
                      '3. Implement proper error handling and reconnection logic\n'
                      '4. Configure sensor calibration in the Settings screen',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
