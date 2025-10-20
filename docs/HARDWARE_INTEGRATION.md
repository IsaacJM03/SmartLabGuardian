# Hardware Sensor Integration Guide

This guide explains how to integrate physical sensors with the Smart Lab Guardian app.

## Overview

The app currently uses simulated sensor data. To connect real sensors, you'll need to:
1. Choose a communication method (Bluetooth, WiFi, Serial, etc.)
2. Add appropriate Flutter packages
3. Modify the `SensorService` class
4. Handle connections and errors

## Supported Communication Methods

### 1. Bluetooth (Recommended)

**Best for:** Wireless sensors within 10-30 meters

**Package:** `flutter_bluetooth_serial`

**Example Sensors:**
- Arduino with HC-05/HC-06 Bluetooth module
- ESP32 with built-in Bluetooth
- Commercial Bluetooth sensor modules

**Implementation:**
```dart
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SensorService {
  BluetoothConnection? connection;
  
  Future<void> connectToDevice(String address) async {
    connection = await BluetoothConnection.toAddress(address);
    
    connection!.input!.listen((data) {
      // Parse incoming sensor data
      _parseSensorData(String.fromCharCodes(data));
    });
  }
  
  void _parseSensorData(String data) {
    // Parse comma-separated values: "temp:25.5,gas:150,fire:0"
    // Update _currentReadings map
  }
}
```

### 2. WiFi/HTTP API

**Best for:** Network-connected sensors, IoT devices

**Package:** `http` (built-in)

**Example Setup:**
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class SensorService {
  final String sensorApiUrl = 'http://192.168.1.100/sensors';
  
  Future<void> _fetchSensorData() async {
    final response = await http.get(Uri.parse(sensorApiUrl));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _updateReadings(data);
    }
  }
}
```

### 3. MQTT (IoT Protocol)

**Best for:** Multiple sensors, cloud-based systems

**Package:** `mqtt_client`

**Example:**
```dart
import 'package:mqtt_client/mqtt_client.dart';

class SensorService {
  late MqttClient client;
  
  Future<void> connectMqtt() async {
    client = MqttClient('broker.hivemq.com', 'flutter_client');
    await client.connect();
    
    client.subscribe('lab/sensors/#', MqttQos.atLeastOnce);
    
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final topic = messages[0].topic;
      final payload = MqttPublishPayload.bytesToStringAsString(
        (messages[0].payload as MqttPublishMessage).payload.message,
      );
      
      _handleMqttMessage(topic, payload);
    });
  }
}
```

## Sensor Types and Hardware

### Temperature Sensor

**Recommended Hardware:**
- DHT22 (±0.5°C accuracy)
- DS18B20 (±0.5°C accuracy, waterproof options)
- BME280 (temperature + humidity + pressure)

**Connection:**
- DHT22: Single wire + power
- DS18B20: OneWire protocol
- BME280: I2C interface

**Arduino Example:**
```cpp
#include <DHT.h>

DHT dht(2, DHT22);  // Pin 2

void setup() {
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  float temp = dht.readTemperature();
  Serial.print("temp:");
  Serial.println(temp);
  delay(2000);
}
```

### Gas Sensor

**Recommended Hardware:**
- MQ-2 (LPG, smoke, alcohol)
- MQ-135 (air quality, CO2, ammonia)
- MQ-7 (carbon monoxide)

**Important:** Requires warm-up time (24-48 hours for accurate readings)

**Connection:**
- Analog output (0-5V or 0-3.3V)
- Digital output (threshold detection)
- VCC and GND

**Arduino Example:**
```cpp
const int gasPin = A0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int gasValue = analogRead(gasPin);
  Serial.print("gas:");
  Serial.println(gasValue);
  delay(1000);
}
```

### Fire Detector

**Recommended Hardware:**
- IR Flame Sensor (760-1100nm detection)
- UV Flame Sensor (more reliable)

**Connection:**
- Digital output (HIGH/LOW)
- Analog output (flame intensity)

**Arduino Example:**
```cpp
const int firePin = 3;

void setup() {
  pinMode(firePin, INPUT);
  Serial.begin(9600);
}

void loop() {
  int fireDetected = digitalRead(firePin);
  Serial.print("fire:");
  Serial.println(fireDetected);
  delay(500);
}
```

### Distance/Proximity Sensor

**Recommended Hardware:**
- HC-SR04 (ultrasonic, 2cm-400cm)
- VL53L0X (laser, 0-200cm, more accurate)
- Sharp IR sensors (analog)

**HC-SR04 Connection:**
- Trigger pin
- Echo pin
- VCC (5V) and GND

**Arduino Example:**
```cpp
const int trigPin = 9;
const int echoPin = 10;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
}

void loop() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  long duration = pulseIn(echoPin, HIGH);
  float distance = duration * 0.034 / 2;
  
  Serial.print("distance:");
  Serial.println(distance);
  delay(1000);
}
```

## Complete Arduino Example

**Multi-Sensor Arduino Sketch:**

```cpp
#include <DHT.h>

#define DHTPIN 2
#define DHTTYPE DHT22
#define GAS_PIN A0
#define FIRE_PIN 3
#define TRIG_PIN 9
#define ECHO_PIN 10

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
  pinMode(FIRE_PIN, INPUT);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void loop() {
  // Temperature
  float temp = dht.readTemperature();
  
  // Gas
  int gasValue = analogRead(GAS_PIN);
  
  // Fire
  int fire = digitalRead(FIRE_PIN);
  
  // Distance
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  long duration = pulseIn(ECHO_PIN, HIGH);
  float distance = duration * 0.034 / 2;
  
  // Send data as JSON
  Serial.print("{");
  Serial.print("\"temp\":");
  Serial.print(temp);
  Serial.print(",\"gas\":");
  Serial.print(gasValue);
  Serial.print(",\"fire\":");
  Serial.print(fire);
  Serial.print(",\"distance\":");
  Serial.print(distance);
  Serial.println("}");
  
  delay(3000);  // Match app update interval
}
```

## Modifying SensorService

Replace the mock data generation in `lib/services/sensor_service.dart`:

```dart
void _generateReadings() async {
  // Replace this entire method with actual sensor reading code
  
  // Example for Bluetooth:
  if (connection != null && connection!.isConnected) {
    // Data is received via connection.input stream
    // and parsed in a separate method
  }
  
  // Example for HTTP:
  final response = await http.get(Uri.parse(sensorApiUrl));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    _currentReadings['temperature'] = SensorReading(
      sensorType: 'temperature',
      value: data['temp'].toDouble(),
      timestamp: DateTime.now(),
      status: _getTemperatureStatus(data['temp'].toDouble()),
    );
    // ... update other sensors
  }
}
```

## Testing

1. **Test sensors individually** before integration
2. **Use serial monitor** to verify data format
3. **Implement error handling** for connection issues
4. **Add reconnection logic** for dropped connections
5. **Calibrate sensors** according to manufacturer specs

## Troubleshooting

### Connection Issues
- Check Bluetooth pairing
- Verify WiFi network access
- Test with serial monitor first

### Inaccurate Readings
- Allow warm-up time for gas sensors
- Calibrate against known values
- Check power supply voltage
- Verify sensor placement

### Data Parsing Errors
- Print raw data to debug
- Check data format consistency
- Handle missing or invalid values

## Safety Considerations

1. **Gas sensors** may require external power
2. **Fire detectors** should be tested regularly
3. **Electrical safety** when connecting sensors
4. **Environmental factors** affect accuracy
5. **Regular calibration** is essential

## Next Steps

1. Choose your hardware platform (Arduino, ESP32, Raspberry Pi)
2. Purchase necessary sensors
3. Build and test circuit
4. Implement communication protocol
5. Update SensorService
6. Test thoroughly in target environment

## Resources

- [Arduino Documentation](https://www.arduino.cc/reference/en/)
- [ESP32 Documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/)
- [Flutter Bluetooth Serial](https://pub.dev/packages/flutter_bluetooth_serial)
- [Sensor datasheets](https://www.sparkfun.com/) - SparkFun, Adafruit

For questions, open an issue on GitHub.
