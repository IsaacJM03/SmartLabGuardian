import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sensor_data.dart';

/// Service for persisting app data locally
/// Uses SharedPreferences for settings and history logs
class StorageService {
  static const String _thresholdsKey = 'sensor_thresholds';
  static const String _historyKey = 'sensor_history';
  static const String _alertLogsKey = 'alert_logs';
  static const int _maxHistoryItems = 1000;
  static const int _maxAlertLogs = 500;

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initialize storage service
  static Future<StorageService> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // ==================== Thresholds ====================

  /// Save sensor thresholds
  Future<void> saveThresholds(SensorThresholds thresholds) async {
    final json = jsonEncode(thresholds.toJson());
    await _prefs.setString(_thresholdsKey, json);
  }

  /// Load sensor thresholds
  SensorThresholds loadThresholds() {
    final json = _prefs.getString(_thresholdsKey);
    if (json == null) {
      return SensorThresholds.defaults();
    }
    try {
      return SensorThresholds.fromJson(jsonDecode(json));
    } catch (e) {
      return SensorThresholds.defaults();
    }
  }

  // ==================== History ====================

  /// Save sensor reading to history
  Future<void> saveSensorReading(SensorData data) async {
    final history = loadHistory();
    history.insert(0, data);

    // Keep only the most recent items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    final jsonList = history.map((e) => e.toJson()).toList();
    await _prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  /// Load sensor history
  List<SensorData> loadHistory() {
    final json = _prefs.getString(_historyKey);
    if (json == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(json);
      return jsonList.map((e) => SensorData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }

  // ==================== Alert Logs ====================

  /// Save alert log
  Future<void> saveAlertLog(AlertLog log) async {
    final logs = loadAlertLogs();
    logs.insert(0, log);

    // Keep only the most recent alerts
    if (logs.length > _maxAlertLogs) {
      logs.removeRange(_maxAlertLogs, logs.length);
    }

    final jsonList = logs.map((e) => e.toJson()).toList();
    await _prefs.setString(_alertLogsKey, jsonEncode(jsonList));
  }

  /// Load alert logs
  List<AlertLog> loadAlertLogs() {
    final json = _prefs.getString(_alertLogsKey);
    if (json == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(json);
      return jsonList.map((e) => AlertLog.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear all alert logs
  Future<void> clearAlertLogs() async {
    await _prefs.remove(_alertLogsKey);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
