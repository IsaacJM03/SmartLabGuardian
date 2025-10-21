import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/sensor_providers.dart';
import '../models/sensor_data.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorData = ref.watch(currentSensorDataProvider);
    final hasAlerts = ref.watch(hasActiveAlertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Safety Dashboard'),
        backgroundColor: hasAlerts ? Colors.red : Colors.blue,
        actions: [
          if (hasAlerts)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.warning, color: Colors.white),
            ),
        ],
      ),
      body: sensorData.when(
        data: (data) => _buildDashboard(context, ref, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(
      BuildContext context, WidgetRef ref, SensorData data) {
    final thresholds = ref.watch(thresholdsProvider);
    final history = ref.watch(historyProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentSensorDataProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status indicators
            _buildStatusGrid(data, thresholds),
            const SizedBox(height: 24),

            // Temperature chart
            _buildChartCard(
              'Temperature (°C)',
              Icons.thermostat,
              Colors.orange,
              data.temperature,
              thresholds.maxTemperature,
              history.map((e) => e.temperature).toList(),
            ),
            const SizedBox(height: 16),

            // Gas level chart
            _buildChartCard(
              'Gas Level (ppm)',
              Icons.air,
              Colors.green,
              data.gasLevel,
              thresholds.maxGasLevel,
              history.map((e) => e.gasLevel).toList(),
            ),
            const SizedBox(height: 16),

            // Distance chart
            _buildChartCard(
              'Distance (cm)',
              Icons.straighten,
              Colors.blue,
              data.distance,
              thresholds.minDistance,
              history.map((e) => e.distance).toList(),
              isMinThreshold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusGrid(SensorData data, SensorThresholds thresholds) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatusCard(
          'Temperature',
          '${data.temperature}°C',
          Icons.thermostat,
          data.temperature > thresholds.maxTemperature
              ? Colors.red
              : Colors.orange,
          data.temperature > thresholds.maxTemperature,
        ),
        _buildStatusCard(
          'Gas Level',
          '${data.gasLevel} ppm',
          Icons.air,
          data.gasLevel > thresholds.maxGasLevel ? Colors.red : Colors.green,
          data.gasLevel > thresholds.maxGasLevel,
        ),
        _buildStatusCard(
          'Fire Status',
          data.fireDetected ? 'DETECTED' : 'Clear',
          Icons.local_fire_department,
          data.fireDetected ? Colors.red : Colors.blue,
          data.fireDetected,
        ),
        _buildStatusCard(
          'Distance',
          '${data.distance} cm',
          Icons.straighten,
          data.distance < thresholds.minDistance ? Colors.red : Colors.blue,
          data.distance < thresholds.minDistance,
        ),
      ],
    );
  }

  Widget _buildStatusCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isAlert,
  ) {
    return Card(
      elevation: 4,
      color: isAlert ? color.withOpacity(0.1) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isAlert ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(
    String title,
    IconData icon,
    Color color,
    double currentValue,
    double threshold,
    List<double> history, {
    bool isMinThreshold = false,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  currentValue.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: _buildLineChart(
                history,
                color,
                threshold,
                isMinThreshold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Threshold: ${threshold.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(
    List<double> data,
    Color color,
    double threshold,
    bool isMinThreshold,
  ) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Take last 20 data points
    final displayData = data.length > 20 ? data.sublist(0, 20) : data;
    final spots = displayData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
        .reversed
        .toList();

    final minY = displayData.reduce((a, b) => a < b ? a : b) * 0.9;
    final maxY = displayData.reduce((a, b) => a > b ? a : b) * 1.1;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
        ),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 35),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: threshold,
              color: Colors.red.withOpacity(0.5),
              strokeWidth: 2,
              dashArray: [5, 5],
            ),
          ],
        ),
      ),
    );
  }
}
