import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sensor_data.dart';
import '../services/sensor_service.dart';
import '../services/storage_service.dart';

// ==================== Services ====================

/// Provider for SensorService
final sensorServiceProvider = Provider<SensorService>((ref) {
  final service = SensorService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for StorageService (async initialization)
final storageServiceProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.initialize();
});

// ==================== Sensor Data Stream ====================

/// Provider for real-time sensor data stream
final sensorDataStreamProvider = StreamProvider<SensorData>((ref) {
  final service = ref.watch(sensorServiceProvider);
  return service.startSensorStream(interval: 1000);
});

/// Provider for current sensor data (latest reading)
final currentSensorDataProvider = Provider<AsyncValue<SensorData>>((ref) {
  return ref.watch(sensorDataStreamProvider);
});

// ==================== Thresholds ====================

/// Provider for sensor thresholds with state management
final thresholdsProvider =
    StateNotifierProvider<ThresholdsNotifier, SensorThresholds>((ref) {
  final storage = ref.watch(storageServiceProvider).value;
  return ThresholdsNotifier(storage);
});

class ThresholdsNotifier extends StateNotifier<SensorThresholds> {
  final StorageService? _storage;

  ThresholdsNotifier(this._storage)
      : super(_storage?.loadThresholds() ?? SensorThresholds.defaults());

  Future<void> updateThresholds(SensorThresholds thresholds) async {
    state = thresholds;
    await _storage?.saveThresholds(thresholds);
  }

  Future<void> updateTemperature(double value) async {
    await updateThresholds(state.copyWith(maxTemperature: value));
  }

  Future<void> updateGasLevel(double value) async {
    await updateThresholds(state.copyWith(maxGasLevel: value));
  }

  Future<void> updateMinDistance(double value) async {
    await updateThresholds(state.copyWith(minDistance: value));
  }

  Future<void> resetToDefaults() async {
    await updateThresholds(SensorThresholds.defaults());
  }
}

// ==================== History ====================

/// Provider for sensor history
final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<SensorData>>((ref) {
  final storage = ref.watch(storageServiceProvider).value;
  return HistoryNotifier(storage);
});

class HistoryNotifier extends StateNotifier<List<SensorData>> {
  final StorageService? _storage;

  HistoryNotifier(this._storage) : super(_storage?.loadHistory() ?? []);

  Future<void> addReading(SensorData data) async {
    await _storage?.saveSensorReading(data);
    state = _storage?.loadHistory() ?? [];
  }

  Future<void> clearHistory() async {
    await _storage?.clearHistory();
    state = [];
  }

  void refresh() {
    state = _storage?.loadHistory() ?? [];
  }
}

// ==================== Alert Logs ====================

/// Provider for alert logs
final alertLogsProvider =
    StateNotifierProvider<AlertLogsNotifier, List<AlertLog>>((ref) {
  final storage = ref.watch(storageServiceProvider).value;
  return AlertLogsNotifier(storage);
});

class AlertLogsNotifier extends StateNotifier<List<AlertLog>> {
  final StorageService? _storage;

  AlertLogsNotifier(this._storage) : super(_storage?.loadAlertLogs() ?? []);

  Future<void> addLog(AlertLog log) async {
    await _storage?.saveAlertLog(log);
    state = _storage?.loadAlertLogs() ?? [];
  }

  Future<void> clearLogs() async {
    await _storage?.clearAlertLogs();
    state = [];
  }

  void refresh() {
    state = _storage?.loadAlertLogs() ?? [];
  }
}

// ==================== Active Alerts ====================

/// Provider for active alerts (based on current sensor data and thresholds)
final activeAlertsProvider = Provider<List<String>>((ref) {
  final sensorData = ref.watch(currentSensorDataProvider);
  final thresholds = ref.watch(thresholdsProvider);

  return sensorData.when(
    data: (data) => data.getAlerts(thresholds),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for alert status (whether there are any active alerts)
final hasActiveAlertsProvider = Provider<bool>((ref) {
  final alerts = ref.watch(activeAlertsProvider);
  return alerts.isNotEmpty;
});

// ==================== Auto-save to History ====================

/// Provider that automatically saves sensor readings to history
/// This runs in the background and saves every reading
final autoSaveHistoryProvider = Provider<void>((ref) {
  final sensorData = ref.watch(currentSensorDataProvider);
  final history = ref.watch(historyProvider.notifier);

  sensorData.whenData((data) {
    // Save every 5 seconds to avoid too many writes
    if (data.timestamp.second % 5 == 0) {
      history.addReading(data);
    }
  });
});

/// Provider that automatically logs alerts
final autoLogAlertsProvider = Provider<void>((ref) {
  final sensorData = ref.watch(currentSensorDataProvider);
  final thresholds = ref.watch(thresholdsProvider);
  final alertLogs = ref.watch(alertLogsProvider.notifier);

  sensorData.whenData((data) {
    final alerts = data.getAlerts(thresholds);
    for (final alert in alerts) {
      final severity = data.fireDetected
          ? AlertSeverity.critical
          : data.temperature > thresholds.maxTemperature + 5 ||
                  data.gasLevel > thresholds.maxGasLevel + 20
              ? AlertSeverity.critical
              : AlertSeverity.warning;

      alertLogs.addLog(AlertLog(
        message: alert,
        timestamp: data.timestamp,
        severity: severity,
      ));
    }
  });
});
