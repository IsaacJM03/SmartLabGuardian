import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sensor_provider.dart';

/// Settings screen for configuring sensor thresholds
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thresholds = ref.watch(thresholdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Sensor Thresholds',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure warning and danger thresholds for each sensor',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Temperature settings
          _buildSectionHeader('Temperature Sensor (°C)'),
          _buildThresholdSlider(
            context,
            label: 'Warning Threshold',
            value: thresholds.temperatureWarning,
            min: 15.0,
            max: 50.0,
            color: Colors.orange,
            onChanged: (value) {
              ref
                  .read(thresholdsProvider.notifier)
                  .updateTemperatureWarning(value);
            },
          ),
          _buildThresholdSlider(
            context,
            label: 'Danger Threshold',
            value: thresholds.temperatureDanger,
            min: 20.0,
            max: 60.0,
            color: Colors.red,
            onChanged: (value) {
              ref
                  .read(thresholdsProvider.notifier)
                  .updateTemperatureDanger(value);
            },
          ),
          const Divider(height: 32),
          
          // Gas settings
          _buildSectionHeader('Gas Sensor (PPM)'),
          _buildThresholdSlider(
            context,
            label: 'Warning Threshold',
            value: thresholds.gasWarning,
            min: 100.0,
            max: 800.0,
            color: Colors.orange,
            onChanged: (value) {
              ref.read(thresholdsProvider.notifier).updateGasWarning(value);
            },
          ),
          _buildThresholdSlider(
            context,
            label: 'Danger Threshold',
            value: thresholds.gasDanger,
            min: 200.0,
            max: 1000.0,
            color: Colors.red,
            onChanged: (value) {
              ref.read(thresholdsProvider.notifier).updateGasDanger(value);
            },
          ),
          const Divider(height: 32),
          
          // Distance settings
          _buildSectionHeader('Distance Sensor (cm)'),
          _buildThresholdSlider(
            context,
            label: 'Warning Threshold',
            value: thresholds.distanceWarning,
            min: 10.0,
            max: 150.0,
            color: Colors.orange,
            onChanged: (value) {
              ref
                  .read(thresholdsProvider.notifier)
                  .updateDistanceWarning(value);
            },
          ),
          _buildThresholdSlider(
            context,
            label: 'Danger Threshold',
            value: thresholds.distanceDanger,
            min: 5.0,
            max: 100.0,
            color: Colors.red,
            onChanged: (value) {
              ref
                  .read(thresholdsProvider.notifier)
                  .updateDistanceDanger(value);
            },
          ),
          const SizedBox(height: 32),
          
          // Information card
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
                        'About Thresholds',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Warning thresholds trigger notifications to alert lab personnel. '
                    'Danger thresholds indicate critical conditions requiring immediate action.\n\n'
                    'Settings are saved automatically and will be applied to real-time monitoring.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThresholdSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 2).toInt(),
          activeColor: color,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
