import 'sensor_reading.dart';

/// Represents an alert triggered by sensor reading
class Alert {
  final String id;
  final String sensorType;
  final double value;
  final DateTime timestamp;
  final SensorStatus severity;
  final String message;
  final bool acknowledged;

  Alert({
    required this.id,
    required this.sensorType,
    required this.value,
    required this.timestamp,
    required this.severity,
    required this.message,
    this.acknowledged = false,
  });

  /// Creates a copy with updated fields
  Alert copyWith({
    String? id,
    String? sensorType,
    double? value,
    DateTime? timestamp,
    SensorStatus? severity,
    String? message,
    bool? acknowledged,
  }) {
    return Alert(
      id: id ?? this.id,
      sensorType: sensorType ?? this.sensorType,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      message: message ?? this.message,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }

  /// Converts to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sensorType': sensorType,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity.toString().split('.').last,
      'message': message,
      'acknowledged': acknowledged,
    };
  }

  /// Creates instance from JSON
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      sensorType: json['sensorType'] as String,
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: SensorStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['severity'],
      ),
      message: json['message'] as String,
      acknowledged: json['acknowledged'] as bool,
    );
  }
}
