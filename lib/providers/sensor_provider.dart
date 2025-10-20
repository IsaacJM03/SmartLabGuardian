import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sensor_reading.dart';
import '../models/sensor_thresholds.dart';
import '../services/sensor_service.dart';
import '../services/storage_service.dart';

/// Provider for SensorService instance
final sensorServiceProvider = Provider<SensorService>((ref) {
  final service = SensorService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

/// Provider for StorageService instance
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Provider for sensor readings stream
final sensorReadingsProvider = StreamProvider<Map<String, SensorReading>>((ref) {
  final sensorService = ref.watch(sensorServiceProvider);
  return sensorService.sensorStream;
});

/// Provider for sensor thresholds
final thresholdsProvider = StateNotifierProvider<ThresholdsNotifier, SensorThresholds>((ref) {
  return ThresholdsNotifier(
    ref.watch(storageServiceProvider),
    ref.watch(sensorServiceProvider),
  );
});

/// Notifier for managing sensor thresholds
class ThresholdsNotifier extends StateNotifier<SensorThresholds> {
  final StorageService _storageService;
  final SensorService _sensorService;

  ThresholdsNotifier(this._storageService, this._sensorService) 
      : super(SensorThresholds.defaults()) {
    _loadThresholds();
  }

  /// Loads thresholds from storage
  Future<void> _loadThresholds() async {
    final thresholds = await _storageService.loadThresholds();
    state = thresholds;
    _sensorService.setThresholds(thresholds);
  }

  /// Updates thresholds and saves to storage
  Future<void> updateThresholds(SensorThresholds thresholds) async {
    state = thresholds;
    _sensorService.setThresholds(thresholds);
    await _storageService.saveThresholds(thresholds);
  }

  /// Updates a specific threshold value
  Future<void> updateTemperatureWarning(double value) async {
    await updateThresholds(state.copyWith(temperatureWarning: value));
  }

  Future<void> updateTemperatureDanger(double value) async {
    await updateThresholds(state.copyWith(temperatureDanger: value));
  }

  Future<void> updateGasWarning(double value) async {
    await updateThresholds(state.copyWith(gasWarning: value));
  }

  Future<void> updateGasDanger(double value) async {
    await updateThresholds(state.copyWith(gasDanger: value));
  }

  Future<void> updateDistanceWarning(double value) async {
    await updateThresholds(state.copyWith(distanceWarning: value));
  }

  Future<void> updateDistanceDanger(double value) async {
    await updateThresholds(state.copyWith(distanceDanger: value));
  }
}
