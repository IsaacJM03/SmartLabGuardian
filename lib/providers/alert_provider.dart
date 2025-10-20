import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alert.dart';
import '../models/sensor_reading.dart';
import '../services/storage_service.dart';
import 'sensor_provider.dart';

/// Provider for alerts
final alertsProvider = StateNotifierProvider<AlertsNotifier, List<Alert>>((ref) {
  return AlertsNotifier(
    ref.watch(storageServiceProvider),
    ref,
  );
});

/// Notifier for managing alerts
class AlertsNotifier extends StateNotifier<List<Alert>> {
  final StorageService _storageService;
  final Ref _ref;

  AlertsNotifier(this._storageService, this._ref) : super([]) {
    _loadAlerts();
    _listenToSensorReadings();
  }

  /// Loads alerts from storage
  Future<void> _loadAlerts() async {
    final alerts = await _storageService.loadAlerts();
    state = alerts;
  }

  /// Listens to sensor readings and creates alerts for dangerous conditions
  void _listenToSensorReadings() {
    _ref.listen<AsyncValue<Map<String, SensorReading>>>(
      sensorReadingsProvider,
      (previous, next) {
        next.whenData((readings) {
          for (final reading in readings.values) {
            if (reading.status == SensorStatus.danger ||
                reading.status == SensorStatus.warning) {
              _createAlert(reading);
            }
          }
        });
      },
    );
  }

  /// Creates and saves a new alert
  Future<void> _createAlert(SensorReading reading) async {
    // Don't create duplicate alerts for the same condition
    if (state.any((alert) =>
        alert.sensorType == reading.sensorType &&
        alert.severity == reading.status &&
        !alert.acknowledged &&
        DateTime.now().difference(alert.timestamp).inMinutes < 5)) {
      return;
    }

    final alert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sensorType: reading.sensorType,
      value: reading.value,
      timestamp: reading.timestamp,
      severity: reading.status,
      message: _generateAlertMessage(reading),
    );

    await _storageService.saveAlert(alert);
    state = [alert, ...state];
  }

  /// Generates a human-readable alert message
  String _generateAlertMessage(SensorReading reading) {
    final sensorName = reading.sensorType.toUpperCase();
    final statusText = reading.status == SensorStatus.danger ? 'CRITICAL' : 'WARNING';
    
    switch (reading.sensorType) {
      case 'temperature':
        return '$statusText: Temperature is ${reading.value.toStringAsFixed(1)}°C';
      case 'gas':
        return '$statusText: Gas level is ${reading.value.toStringAsFixed(0)} PPM';
      case 'fire':
        return 'CRITICAL: Fire detected!';
      case 'distance':
        return '$statusText: Object detected at ${reading.value.toStringAsFixed(0)} cm';
      default:
        return '$statusText: $sensorName sensor alert';
    }
  }

  /// Acknowledges an alert
  Future<void> acknowledgeAlert(String alertId) async {
    await _storageService.acknowledgeAlert(alertId);
    state = state.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(acknowledged: true);
      }
      return alert;
    }).toList();
  }

  /// Clears all acknowledged alerts
  Future<void> clearAcknowledgedAlerts() async {
    final unacknowledged = state.where((alert) => !alert.acknowledged).toList();
    state = unacknowledged;
    // Note: In production, you'd want to also update storage
  }
}
