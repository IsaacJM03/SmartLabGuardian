import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alert.dart';
import '../models/sensor_reading.dart';

/// Widget that displays an alert card
class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback onAcknowledge;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getAlertColor();
    final dateFormat = DateFormat('MMM dd, HH:mm');

    return Card(
      elevation: alert.acknowledged ? 1 : 4,
      color: alert.acknowledged ? Colors.grey.shade100 : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getAlertIcon(),
                  color: color,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.message,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: alert.acknowledged
                              ? Colors.grey.shade600
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(alert.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!alert.acknowledged)
                  ElevatedButton(
                    onPressed: onAcknowledge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                    ),
                    child: const Text('Acknowledge'),
                  ),
              ],
            ),
            if (alert.acknowledged)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Acknowledged',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getAlertColor() {
    switch (alert.severity) {
      case SensorStatus.safe:
        return Colors.green;
      case SensorStatus.warning:
        return Colors.orange;
      case SensorStatus.danger:
        return Colors.red;
    }
  }

  IconData _getAlertIcon() {
    switch (alert.severity) {
      case SensorStatus.safe:
        return Icons.check_circle;
      case SensorStatus.warning:
        return Icons.warning;
      case SensorStatus.danger:
        return Icons.error;
    }
  }
}
