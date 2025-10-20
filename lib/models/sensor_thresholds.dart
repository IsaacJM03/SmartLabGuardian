/// Holds threshold values for each sensor type
class SensorThresholds {
  final double temperatureWarning;
  final double temperatureDanger;
  final double gasWarning;
  final double gasDanger;
  final double distanceWarning;
  final double distanceDanger;

  const SensorThresholds({
    required this.temperatureWarning,
    required this.temperatureDanger,
    required this.gasWarning,
    required this.gasDanger,
    required this.distanceWarning,
    required this.distanceDanger,
  });

  /// Default thresholds
  factory SensorThresholds.defaults() {
    return const SensorThresholds(
      temperatureWarning: 30.0,
      temperatureDanger: 40.0,
      gasWarning: 300.0,
      gasDanger: 500.0,
      distanceWarning: 50.0,
      distanceDanger: 20.0,
    );
  }

  /// Converts to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'temperatureWarning': temperatureWarning,
      'temperatureDanger': temperatureDanger,
      'gasWarning': gasWarning,
      'gasDanger': gasDanger,
      'distanceWarning': distanceWarning,
      'distanceDanger': distanceDanger,
    };
  }

  /// Creates instance from JSON
  factory SensorThresholds.fromJson(Map<String, dynamic> json) {
    return SensorThresholds(
      temperatureWarning: (json['temperatureWarning'] as num).toDouble(),
      temperatureDanger: (json['temperatureDanger'] as num).toDouble(),
      gasWarning: (json['gasWarning'] as num).toDouble(),
      gasDanger: (json['gasDanger'] as num).toDouble(),
      distanceWarning: (json['distanceWarning'] as num).toDouble(),
      distanceDanger: (json['distanceDanger'] as num).toDouble(),
    );
  }

  /// Creates a copy with updated fields
  SensorThresholds copyWith({
    double? temperatureWarning,
    double? temperatureDanger,
    double? gasWarning,
    double? gasDanger,
    double? distanceWarning,
    double? distanceDanger,
  }) {
    return SensorThresholds(
      temperatureWarning: temperatureWarning ?? this.temperatureWarning,
      temperatureDanger: temperatureDanger ?? this.temperatureDanger,
      gasWarning: gasWarning ?? this.gasWarning,
      gasDanger: gasDanger ?? this.gasDanger,
      distanceWarning: distanceWarning ?? this.distanceWarning,
      distanceDanger: distanceDanger ?? this.distanceDanger,
    );
  }
}
