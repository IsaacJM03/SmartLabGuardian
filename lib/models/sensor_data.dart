/// Model representing a single sensor reading
class SensorData {
  final double temperature; // Temperature in Celsius
  final double gasLevel; // Gas level (0-100 ppm)
  final bool fireDetected; // Fire detection status
  final double distance; // Distance in cm
  final DateTime timestamp;

  const SensorData({
    required this.temperature,
    required this.gasLevel,
    required this.fireDetected,
    required this.distance,
    required this.timestamp,
  });

  /// Check if any sensor value breaches the threshold
  bool hasAlert(SensorThresholds thresholds) {
    return temperature > thresholds.maxTemperature ||
        gasLevel > thresholds.maxGasLevel ||
        fireDetected ||
        distance < thresholds.minDistance;
  }

  /// Get list of active alerts
  List<String> getAlerts(SensorThresholds thresholds) {
    final alerts = <String>[];
    if (temperature > thresholds.maxTemperature) {
      alerts.add('Temperature exceeds ${thresholds.maxTemperature}°C');
    }
    if (gasLevel > thresholds.maxGasLevel) {
      alerts.add('Gas level exceeds ${thresholds.maxGasLevel} ppm');
    }
    if (fireDetected) {
      alerts.add('Fire detected!');
    }
    if (distance < thresholds.minDistance) {
      alerts.add('Distance below ${thresholds.minDistance} cm');
    }
    return alerts;
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'gasLevel': gasLevel,
        'fireDetected': fireDetected,
        'distance': distance,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        temperature: json['temperature'] as double,
        gasLevel: json['gasLevel'] as double,
        fireDetected: json['fireDetected'] as bool,
        distance: json['distance'] as double,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Model for sensor threshold settings
class SensorThresholds {
  final double maxTemperature;
  final double maxGasLevel;
  final double minDistance;

  const SensorThresholds({
    required this.maxTemperature,
    required this.maxGasLevel,
    required this.minDistance,
  });

  /// Default safe thresholds
  factory SensorThresholds.defaults() => const SensorThresholds(
        maxTemperature: 30.0, // 30°C
        maxGasLevel: 50.0, // 50 ppm
        minDistance: 20.0, // 20 cm
      );

  SensorThresholds copyWith({
    double? maxTemperature,
    double? maxGasLevel,
    double? minDistance,
  }) {
    return SensorThresholds(
      maxTemperature: maxTemperature ?? this.maxTemperature,
      maxGasLevel: maxGasLevel ?? this.maxGasLevel,
      minDistance: minDistance ?? this.minDistance,
    );
  }

  Map<String, dynamic> toJson() => {
        'maxTemperature': maxTemperature,
        'maxGasLevel': maxGasLevel,
        'minDistance': minDistance,
      };

  factory SensorThresholds.fromJson(Map<String, dynamic> json) =>
      SensorThresholds(
        maxTemperature: json['maxTemperature'] as double,
        maxGasLevel: json['maxGasLevel'] as double,
        minDistance: json['minDistance'] as double,
      );
}

/// Model for alert log entry
class AlertLog {
  final String message;
  final DateTime timestamp;
  final AlertSeverity severity;

  const AlertLog({
    required this.message,
    required this.timestamp,
    required this.severity,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'severity': severity.name,
      };

  factory AlertLog.fromJson(Map<String, dynamic> json) => AlertLog(
        message: json['message'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        severity: AlertSeverity.values.firstWhere(
          (e) => e.name == json['severity'],
          orElse: () => AlertSeverity.warning,
        ),
      );
}

enum AlertSeverity {
  info,
  warning,
  critical,
}
