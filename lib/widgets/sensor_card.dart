import 'package:flutter/material.dart';
import '../models/sensor_reading.dart';

/// Widget that displays a sensor reading card
class SensorCard extends StatelessWidget {
  final SensorReading reading;
  final String unit;
  final IconData icon;

  const SensorCard({
    super.key,
    required this.reading,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final statusText = _getStatusText();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getSensorTitle(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _formatValue(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSensorTitle() {
    switch (reading.sensorType) {
      case 'temperature':
        return 'Temperature';
      case 'gas':
        return 'Gas Level';
      case 'fire':
        return 'Fire Detector';
      case 'distance':
        return 'Distance Sensor';
      default:
        return reading.sensorType.toUpperCase();
    }
  }

  String _formatValue() {
    if (reading.sensorType == 'fire') {
      return reading.value > 0 ? 'FIRE DETECTED' : 'No Fire';
    }
    return '${reading.value.toStringAsFixed(1)} $unit';
  }

  Color _getStatusColor() {
    switch (reading.status) {
      case SensorStatus.safe:
        return Colors.green;
      case SensorStatus.warning:
        return Colors.orange;
      case SensorStatus.danger:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (reading.status) {
      case SensorStatus.safe:
        return 'SAFE';
      case SensorStatus.warning:
        return 'WARNING';
      case SensorStatus.danger:
        return 'DANGER';
    }
  }
}
