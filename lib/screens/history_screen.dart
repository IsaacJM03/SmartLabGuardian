import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/sensor_providers.dart';
import '../models/sensor_data.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor History'),
        backgroundColor: Colors.blue,
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearDialog(context, ref),
              tooltip: 'Clear history',
            ),
        ],
      ),
      body: history.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildSummaryCard(history),
                const Divider(height: 1),
                Expanded(child: _buildHistoryList(history)),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No history available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sensor readings will be saved here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<SensorData> history) {
    final temps = history.map((e) => e.temperature).toList();
    final gases = history.map((e) => e.gasLevel).toList();
    final distances = history.map((e) => e.distance).toList();

    final avgTemp = temps.reduce((a, b) => a + b) / temps.length;
    final avgGas = gases.reduce((a, b) => a + b) / gases.length;
    final avgDist = distances.reduce((a, b) => a + b) / distances.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Avg Temp',
                '${avgTemp.toStringAsFixed(1)}°C',
                Icons.thermostat,
                Colors.orange,
              ),
              _buildStatItem(
                'Avg Gas',
                '${avgGas.toStringAsFixed(1)} ppm',
                Icons.air,
                Colors.green,
              ),
              _buildStatItem(
                'Avg Dist',
                '${avgDist.toStringAsFixed(1)} cm',
                Icons.straighten,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Total readings: ${history.length}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(List<SensorData> history) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final data = history[index];
        return _buildHistoryCard(data, index == 0);
      },
    );
  }

  Widget _buildHistoryCard(SensorData data, bool isLatest) {
    final dateFormat = DateFormat('MMM dd, HH:mm:ss');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isLatest ? 4 : 2,
      color: isLatest ? Colors.blue.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(data.timestamp),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (isLatest)
                  Chip(
                    label: const Text(
                      'LATEST',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDataPoint(
                  Icons.thermostat,
                  Colors.orange,
                  '${data.temperature}°C',
                ),
                _buildDataPoint(
                  Icons.air,
                  Colors.green,
                  '${data.gasLevel} ppm',
                ),
                _buildDataPoint(
                  Icons.straighten,
                  Colors.blue,
                  '${data.distance} cm',
                ),
                _buildDataPoint(
                  Icons.local_fire_department,
                  data.fireDetected ? Colors.red : Colors.grey,
                  data.fireDetected ? 'FIRE' : 'OK',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataPoint(IconData icon, Color color, String value) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
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
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
