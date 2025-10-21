# Sensor Integration Examples

This document provides detailed examples of how to integrate real sensors with the Smart Lab Guardian app.

## Table of Contents

1. [Arduino/ESP32 via Serial](#arduinoesp32-via-serial)
2. [HTTP/REST API](#httprest-api)
3. [MQTT](#mqtt)
4. [Bluetooth Low Energy (BLE)](#bluetooth-low-energy-ble)
5. [WebSocket](#websocket)

---

## Arduino/ESP32 via Serial

### Arduino Code

```cpp
// Arduino/ESP32 sensor reading code
#include <DHT.h>

#define DHTPIN 4
#define GAS_PIN A0
#define FIRE_PIN 7
#define TRIG_PIN 9
#define ECHO_PIN 10

DHT dht(DHTPIN, DHT22);

void setup() {
  Serial.begin(9600);
  dht.begin();
  pinMode(FIRE_PIN, INPUT);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void loop() {
  float temp = dht.readTemperature();
  float gas = analogRead(GAS_PIN) * (100.0 / 1023.0);
  int fire = digitalRead(FIRE_PIN);
  
  // Ultrasonic distance
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  long duration = pulseIn(ECHO_PIN, HIGH);
  float distance = duration * 0.034 / 2;
  
  // Send data in JSON format
  Serial.print("{\"temperature\":");
  Serial.print(temp);
  Serial.print(",\"gasLevel\":");
  Serial.print(gas);
  Serial.print(",\"fireDetected\":");
  Serial.print(fire == HIGH ? "true" : "false");
  Serial.print(",\"distance\":");
  Serial.print(distance);
  Serial.println("}");
  
  delay(1000);
}
```

### Flutter Integration

Add dependency to `pubspec.yaml`:
```yaml
dependencies:
  usb_serial: ^0.5.0
```

Create `lib/services/arduino_sensor_service.dart`:

```dart
import 'dart:async';
import 'dart:convert';
import 'package:usb_serial/usb_serial.dart';
import '../models/sensor_data.dart';

class ArduinoSensorService {
  UsbPort? _port;
  StreamController<SensorData>? _streamController;
  StreamSubscription? _subscription;

  Future<bool> connect() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) return false;

    _port = await devices[0].create();
    bool opened = await _port!.open();
    if (!opened) return false;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    return true;
  }

  Stream<SensorData> startSensorStream() {
    _streamController?.close();
    _streamController = StreamController<SensorData>.broadcast();

    _subscription = _port!.inputStream!.listen((data) {
      final line = String.fromCharCodes(data).trim();
      if (line.isNotEmpty) {
        try {
          final json = jsonDecode(line);
          final sensorData = SensorData(
            temperature: (json['temperature'] as num).toDouble(),
            gasLevel: (json['gasLevel'] as num).toDouble(),
            fireDetected: json['fireDetected'] as bool,
            distance: (json['distance'] as num).toDouble(),
            timestamp: DateTime.now(),
          );
          _streamController?.add(sensorData);
        } catch (e) {
          print('Error parsing sensor data: $e');
        }
      }
    });

    return _streamController!.stream;
  }

  void dispose() {
    _subscription?.cancel();
    _streamController?.close();
    _port?.close();
  }
}
```

---

## HTTP/REST API

### Server Example (Node.js/Express)

```javascript
const express = require('express');
const app = express();

app.get('/api/sensors', (req, res) => {
  // Read from actual sensors
  const data = {
    temperature: readTemperatureSensor(),
    gasLevel: readGasSensor(),
    fireDetected: readFireSensor(),
    distance: readDistanceSensor()
  };
  res.json(data);
});

app.listen(3000);
```

### Flutter Integration

Add dependency to `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

Create `lib/services/http_sensor_service.dart`:

```dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class HttpSensorService {
  final String apiUrl;
  Timer? _timer;
  StreamController<SensorData>? _streamController;

  HttpSensorService({required this.apiUrl});

  Stream<SensorData> startSensorStream({int interval = 1000}) {
    _streamController?.close();
    _streamController = StreamController<SensorData>.broadcast();

    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) async {
      try {
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final data = SensorData(
            temperature: (json['temperature'] as num).toDouble(),
            gasLevel: (json['gasLevel'] as num).toDouble(),
            fireDetected: json['fireDetected'] as bool,
            distance: (json['distance'] as num).toDouble(),
            timestamp: DateTime.now(),
          );
          _streamController?.add(data);
        }
      } catch (e) {
        print('Error fetching sensor data: $e');
      }
    });

    return _streamController!.stream;
  }

  void dispose() {
    _timer?.cancel();
    _streamController?.close();
  }
}
```

---

## MQTT

### MQTT Broker Setup

Configure your sensors to publish to MQTT topics:
- `sensors/temperature`
- `sensors/gas`
- `sensors/fire`
- `sensors/distance`

### Flutter Integration

Add dependency to `pubspec.yaml`:
```yaml
dependencies:
  mqtt_client: ^10.0.0
```

Create `lib/services/mqtt_sensor_service.dart`:

```dart
import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/sensor_data.dart';

class MqttSensorService {
  final String broker;
  final int port;
  MqttServerClient? _client;
  StreamController<SensorData>? _streamController;

  double _temperature = 0;
  double _gasLevel = 0;
  bool _fireDetected = false;
  double _distance = 0;

  MqttSensorService({
    required this.broker,
    this.port = 1883,
  });

  Future<bool> connect() async {
    _client = MqttServerClient(broker, 'flutter_client');
    _client!.port = port;
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
    } catch (e) {
      print('Connection error: $e');
      return false;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      _subscribeToTopics();
      return true;
    }

    return false;
  }

  void _subscribeToTopics() {
    _client!.subscribe('sensors/temperature', MqttQos.atLeastOnce);
    _client!.subscribe('sensors/gas', MqttQos.atLeastOnce);
    _client!.subscribe('sensors/fire', MqttQos.atLeastOnce);
    _client!.subscribe('sensors/distance', MqttQos.atLeastOnce);
  }

  Stream<SensorData> startSensorStream() {
    _streamController?.close();
    _streamController = StreamController<SensorData>.broadcast();

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final payload = MqttPublishPayload.bytesToStringAsString(
          (message.payload as MqttPublishMessage).payload.message,
        );

        final topic = message.topic;
        
        if (topic == 'sensors/temperature') {
          _temperature = double.parse(payload);
        } else if (topic == 'sensors/gas') {
          _gasLevel = double.parse(payload);
        } else if (topic == 'sensors/fire') {
          _fireDetected = payload == 'true' || payload == '1';
        } else if (topic == 'sensors/distance') {
          _distance = double.parse(payload);
        }

        // Emit combined sensor data
        _streamController?.add(SensorData(
          temperature: _temperature,
          gasLevel: _gasLevel,
          fireDetected: _fireDetected,
          distance: _distance,
          timestamp: DateTime.now(),
        ));
      }
    });

    return _streamController!.stream;
  }

  void _onDisconnected() {
    print('MQTT client disconnected');
  }

  void dispose() {
    _streamController?.close();
    _client?.disconnect();
  }
}
```

---

## Bluetooth Low Energy (BLE)

### BLE Sensor Configuration

Configure your BLE sensor with a service UUID and characteristics for each sensor type.

### Flutter Integration

Add dependency to `pubspec.yaml`:
```yaml
dependencies:
  flutter_blue_plus: ^1.24.0
```

Create `lib/services/ble_sensor_service.dart`:

```dart
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/sensor_data.dart';

class BleSensorService {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  StreamController<SensorData>? _streamController;

  // Replace with your sensor's service and characteristic UUIDs
  static const String serviceUuid = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String characteristicUuid = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';

  Future<bool> scan() async {
    final completer = Completer<bool>();
    
    FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.name == 'LabSensor') {
          _device = result.device;
          FlutterBluePlus.stopScan();
          completer.complete(true);
          return;
        }
      }
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    
    await Future.delayed(const Duration(seconds: 10));
    if (!completer.isCompleted) {
      completer.complete(false);
    }
    
    return completer.future;
  }

  Future<bool> connect() async {
    if (_device == null) return false;

    try {
      await _device!.connect();
      final services = await _device!.discoverServices();

      for (var service in services) {
        if (service.uuid.toString() == serviceUuid) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString() == characteristicUuid) {
              _characteristic = characteristic;
              await _characteristic!.setNotifyValue(true);
              return true;
            }
          }
        }
      }
    } catch (e) {
      print('Connection error: $e');
    }

    return false;
  }

  Stream<SensorData> startSensorStream() {
    _streamController?.close();
    _streamController = StreamController<SensorData>.broadcast();

    if (_characteristic == null) return _streamController!.stream;

    _characteristic!.value.listen((bytes) {
      if (bytes.length >= 13) {
        // Parse bytes according to your sensor's data format
        // Example: 4 bytes temp + 4 bytes gas + 1 byte fire + 4 bytes distance
        final temperature = _bytesToFloat(bytes.sublist(0, 4));
        final gasLevel = _bytesToFloat(bytes.sublist(4, 8));
        final fireDetected = bytes[8] == 1;
        final distance = _bytesToFloat(bytes.sublist(9, 13));

        _streamController?.add(SensorData(
          temperature: temperature,
          gasLevel: gasLevel,
          fireDetected: fireDetected,
          distance: distance,
          timestamp: DateTime.now(),
        ));
      }
    });

    return _streamController!.stream;
  }

  double _bytesToFloat(List<int> bytes) {
    // Convert 4 bytes to float (little-endian)
    int bits = (bytes[3] << 24) | (bytes[2] << 16) | (bytes[1] << 8) | bytes[0];
    return _intBitsToFloat(bits);
  }

  double _intBitsToFloat(int bits) {
    // IEEE 754 conversion
    final sign = (bits >> 31) == 0 ? 1 : -1;
    final exponent = ((bits >> 23) & 0xff) - 127;
    final mantissa = (bits & 0x7fffff) | 0x800000;
    return sign * mantissa * pow(2, exponent - 23).toDouble();
  }

  void dispose() {
    _streamController?.close();
    _device?.disconnect();
  }
}
```

---

## WebSocket

### Server Example (Node.js)

```javascript
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  setInterval(() => {
    const data = JSON.stringify({
      temperature: readTemperatureSensor(),
      gasLevel: readGasSensor(),
      fireDetected: readFireSensor(),
      distance: readDistanceSensor()
    });
    ws.send(data);
  }, 1000);
});
```

### Flutter Integration

Add dependency to `pubspec.yaml`:
```yaml
dependencies:
  web_socket_channel: ^2.4.0
```

Create `lib/services/websocket_sensor_service.dart`:

```dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/sensor_data.dart';

class WebSocketSensorService {
  final String url;
  WebSocketChannel? _channel;
  StreamController<SensorData>? _streamController;

  WebSocketSensorService({required this.url});

  Future<bool> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      return true;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  Stream<SensorData> startSensorStream() {
    _streamController?.close();
    _streamController = StreamController<SensorData>.broadcast();

    _channel!.stream.listen((message) {
      try {
        final json = jsonDecode(message);
        final data = SensorData(
          temperature: (json['temperature'] as num).toDouble(),
          gasLevel: (json['gasLevel'] as num).toDouble(),
          fireDetected: json['fireDetected'] as bool,
          distance: (json['distance'] as num).toDouble(),
          timestamp: DateTime.now(),
        );
        _streamController?.add(data);
      } catch (e) {
        print('Error parsing sensor data: $e');
      }
    });

    return _streamController!.stream;
  }

  void dispose() {
    _streamController?.close();
    _channel?.sink.close();
  }
}
```

---

## Updating the Provider

After creating your custom sensor service, update `lib/providers/sensor_providers.dart`:

```dart
// Replace the default SensorService provider with your custom one
final sensorServiceProvider = Provider<YourCustomSensorService>((ref) {
  final service = YourCustomSensorService(
    // Add your configuration parameters
    apiUrl: 'http://your-sensor-api.com/data',
  );
  ref.onDispose(() => service.dispose());
  return service;
});

// Update the stream provider if needed
final sensorDataStreamProvider = StreamProvider<SensorData>((ref) {
  final service = ref.watch(sensorServiceProvider);
  // Add connection logic if required
  service.connect();
  return service.startSensorStream(interval: 1000);
});
```

---

## Testing Your Integration

1. **Test connection:** Verify your sensor device is reachable
2. **Verify data format:** Ensure data matches the SensorData model
3. **Test error handling:** Disconnect the sensor and verify error handling
4. **Monitor performance:** Check if data updates are smooth and responsive
5. **Validate thresholds:** Trigger alerts and verify they work correctly

## Tips

- Always handle connection errors gracefully
- Implement reconnection logic for network-based sensors
- Add appropriate permissions in AndroidManifest.xml and Info.plist
- Test with real sensors before deploying
- Consider adding a calibration feature for sensor accuracy
