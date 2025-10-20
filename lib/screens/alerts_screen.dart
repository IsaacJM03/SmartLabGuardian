import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sensor_providers.dart';
import '../models/sensor_data.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAlerts = ref.watch(activeAlertsProvider);
    final alertLogs = ref.watch(alertLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        backgroundColor: activeAlerts.isNotEmpty ? Colors.red : Colors.blue,
        actions: [
          if (alertLogs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearDialog(context, ref),
              tooltip: 'Clear all logs',
            ),
        ],
      ),
      body: Column(
        children: [
          // Active alerts section
          if (activeAlerts.isNotEmpty)
            _buildActiveAlertsSection(activeAlerts)
          else
            _buildNoActiveAlerts(),

          const Divider(height: 1),

          // Alert history section
          Expanded(
            child: _buildAlertHistory(alertLogs),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlertsSection(List<String> alerts) {
    return Container(
      color: Colors.red.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(
                'Active Alerts (${alerts.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...alerts.map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alert,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNoActiveAlerts() {
    return Container(
      color: Colors.green.shade50,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Text(
            'All systems normal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertHistory(List<AlertLog> logs) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No alert history',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildAlertLogCard(log);
      },
    );
  }

  Widget _buildAlertLogCard(AlertLog log) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm:ss');
    Color color;
    IconData icon;

    switch (log.severity) {
      case AlertSeverity.critical:
        color = Colors.red;
        icon = Icons.error;
        break;
      case AlertSeverity.warning:
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case AlertSeverity.info:
        color = Colors.blue;
        icon = Icons.info;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          log.message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          dateFormat.format(log.timestamp),
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Chip(
          label: Text(
            log.severity.name.toUpperCase(),
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Alert Logs'),
        content: const Text(
          'Are you sure you want to clear all alert logs? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(alertLogsProvider.notifier).clearLogs();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alert logs cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
