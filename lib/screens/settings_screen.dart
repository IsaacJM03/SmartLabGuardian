import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sensor_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thresholds = ref.watch(thresholdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context, ref),
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            'Sensor Thresholds',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adjust threshold values to trigger alerts when sensors exceed these limits.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Temperature threshold
          _buildThresholdCard(
            context,
            ref,
            'Temperature',
            'Maximum safe temperature',
            Icons.thermostat,
            Colors.orange,
            thresholds.maxTemperature,
            '°C',
            15.0,
            50.0,
            (value) => ref
                .read(thresholdsProvider.notifier)
                .updateTemperature(value),
          ),
          const SizedBox(height: 16),

          // Gas level threshold
          _buildThresholdCard(
            context,
            ref,
            'Gas Level',
            'Maximum safe gas concentration',
            Icons.air,
            Colors.green,
            thresholds.maxGasLevel,
            'ppm',
            0.0,
            100.0,
            (value) =>
                ref.read(thresholdsProvider.notifier).updateGasLevel(value),
          ),
          const SizedBox(height: 16),

          // Distance threshold
          _buildThresholdCard(
            context,
            ref,
            'Distance',
            'Minimum safe distance',
            Icons.straighten,
            Colors.blue,
            thresholds.minDistance,
            'cm',
            5.0,
            100.0,
            (value) =>
                ref.read(thresholdsProvider.notifier).updateMinDistance(value),
          ),
          const SizedBox(height: 24),

          // Additional settings section
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Data Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Clear history button
          ElevatedButton.icon(
            onPressed: () => _showClearHistoryDialog(context, ref),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Clear History'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),

          // Clear all data button
          ElevatedButton.icon(
            onPressed: () => _showClearAllDialog(context, ref),
            icon: const Icon(Icons.delete_forever),
            label: const Text('Clear All Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 24),

          // Info section
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Smart Lab Guardian v1.0.0\n\n'
            'A real-time lab safety monitoring system.\n\n'
            'Integration Notes:\n'
            '• Replace SensorService with actual sensor interfaces\n'
            '• Supports Arduino, ESP32, HTTP APIs, MQTT, and BLE\n'
            '• See SensorService comments for integration examples',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdCard(
    BuildContext context,
    WidgetRef ref,
    String title,
    String description,
    IconData icon,
    Color color,
    double currentValue,
    String unit,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${currentValue.toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                thumbColor: color,
                inactiveTrackColor: color.withOpacity(0.3),
              ),
              child: Slider(
                value: currentValue,
                min: min,
                max: max,
                divisions: ((max - min) * 2).toInt(),
                label: currentValue.toStringAsFixed(1),
                onChanged: onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$min $unit',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '$max $unit',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'Are you sure you want to reset all thresholds to their default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(thresholdsProvider.notifier).resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thresholds reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all sensor history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to clear ALL data including history, alerts, and settings? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final storage = await ref.read(storageServiceProvider.future);
              await storage.clearAll();
              ref.invalidate(historyProvider);
              ref.invalidate(alertLogsProvider);
              ref.read(thresholdsProvider.notifier).resetToDefaults();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              }
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
