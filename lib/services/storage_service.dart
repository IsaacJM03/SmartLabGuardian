import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sensor_reading.dart';
import '../models/sensor_thresholds.dart';
import '../models/alert.dart';

/// Service for local data storage
/// 
/// Uses SharedPreferences for settings and thresholds
/// In a production app, consider using Hive for more complex data
/// or Firebase for cloud sync capabilities
class StorageService {
  static const String _thresholdsKey = 'sensor_thresholds';
  static const String _readingsHistoryKey = 'readings_history';
  static const String _alertsKey = 'alerts';

  /// Saves sensor thresholds
  Future<void> saveThresholds(SensorThresholds thresholds) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(thresholds.toJson());
    await prefs.setString(_thresholdsKey, json);
  }

  /// Loads sensor thresholds
  Future<SensorThresholds> loadThresholds() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_thresholdsKey);
    
    if (jsonString == null) {
      return SensorThresholds.defaults();
    }
    
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return SensorThresholds.fromJson(json);
  }

  /// Saves sensor reading to history
  /// 
  /// For production, consider:
  /// - Using Hive for better performance with large datasets
  /// - Implementing data retention policies (e.g., keep last 1000 readings)
  /// - Adding Firebase sync for cloud backup
  Future<void> saveSensorReading(SensorReading reading) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_readingsHistoryKey);
    
    List<dynamic> history = [];
    if (historyJson != null) {
      history = jsonDecode(historyJson) as List<dynamic>;
    }
    
    history.insert(0, reading.toJson());
    
    // Keep only last 100 readings to avoid storage issues
    if (history.length > 100) {
      history = history.sublist(0, 100);
    }
    
    await prefs.setString(_readingsHistoryKey, jsonEncode(history));
  }

  /// Loads sensor reading history
  Future<List<SensorReading>> loadReadingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_readingsHistoryKey);
    
    if (historyJson == null) {
      return [];
    }
    
    final history = jsonDecode(historyJson) as List<dynamic>;
    return history
        .map((json) => SensorReading.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Saves an alert
  Future<void> saveAlert(Alert alert) async {
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = prefs.getString(_alertsKey);
    
    List<dynamic> alerts = [];
    if (alertsJson != null) {
      alerts = jsonDecode(alertsJson) as List<dynamic>;
    }
    
    alerts.insert(0, alert.toJson());
    
    // Keep only last 50 alerts
    if (alerts.length > 50) {
      alerts = alerts.sublist(0, 50);
    }
    
    await prefs.setString(_alertsKey, jsonEncode(alerts));
  }

  /// Loads all alerts
  Future<List<Alert>> loadAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = prefs.getString(_alertsKey);
    
    if (alertsJson == null) {
      return [];
    }
    
    final alerts = jsonDecode(alertsJson) as List<dynamic>;
    return alerts
        .map((json) => Alert.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Acknowledges an alert
  Future<void> acknowledgeAlert(String alertId) async {
    final alerts = await loadAlerts();
    final updatedAlerts = alerts.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(acknowledged: true);
      }
      return alert;
    }).toList();
    
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = jsonEncode(updatedAlerts.map((a) => a.toJson()).toList());
    await prefs.setString(_alertsKey, alertsJson);
  }

  /// Clears all stored data
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
