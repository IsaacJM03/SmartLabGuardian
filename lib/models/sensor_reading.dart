/// Represents a single sensor reading with timestamp
class SensorReading {
  final String sensorType;
  final double value;
  final DateTime timestamp;
  final SensorStatus status;

  SensorReading({
    required this.sensorType,
    required this.value,
    required this.timestamp,
    required this.status,
  });

  /// Creates a copy with updated fields
  SensorReading copyWith({
    String? sensorType,
    double? value,
    DateTime? timestamp,
    SensorStatus? status,
  }) {
    return SensorReading(
      sensorType: sensorType ?? this.sensorType,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  /// Converts to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'sensorType': sensorType,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  /// Creates instance from JSON
  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      sensorType: json['sensorType'] as String,
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: SensorStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
    );
  }
}

/// Sensor status enum
enum SensorStatus {
  safe,
  warning,
  danger,
}
