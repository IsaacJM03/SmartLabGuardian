# Contributing to Smart Lab Guardian

Thank you for your interest in contributing to Smart Lab Guardian! This document provides guidelines and instructions for contributing to the project.

## Development Setup

### Prerequisites

1. **Flutter SDK**: Install Flutter 3.0.0 or higher
   - Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install)
   - Verify installation: `flutter doctor`

2. **IDE**: Recommended options
   - Visual Studio Code with Flutter extension
   - Android Studio with Flutter plugin
   - IntelliJ IDEA with Flutter plugin

3. **Git**: For version control

### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/SmartLabGuardian.git
   cd SmartLabGuardian
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
├── services/                    # Business logic services
├── providers/                   # Riverpod state management
├── screens/                     # UI screens
└── widgets/                     # Reusable UI components

test/
├── models/                      # Model tests
├── services/                    # Service tests
└── widgets/                     # Widget tests
```

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to check for issues
- Format code with `dart format .`
- Run linter: `flutter analyze`

### Code Formatting

```bash
# Format all Dart files
dart format .

# Check formatting without modifying files
dart format --output=none --set-exit-if-changed .
```

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/sensor_reading_test.dart

# Run tests with coverage
flutter test --coverage
```

### Writing Tests

- Place tests in the `test/` directory, mirroring the `lib/` structure
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern
- Mock external dependencies

Example:
```dart
test('sensor reading converts to JSON correctly', () {
  // Arrange
  final reading = SensorReading(...);
  
  // Act
  final json = reading.toJson();
  
  // Assert
  expect(json['sensorType'], 'temperature');
});
```

## Adding New Features

### 1. Sensor Types

To add a new sensor type:

1. Update `SensorService._generateReadings()` to include the new sensor
2. Add threshold fields to `SensorThresholds` model
3. Update `SettingsScreen` to add threshold controls
4. Add appropriate icon and unit in `DashboardScreen`

### 2. Storage Options

Current implementation uses SharedPreferences. To switch to Hive:

1. Create Hive type adapters for models
2. Update `StorageService` methods
3. Initialize Hive in `main.dart`
4. Run build_runner: `flutter pub run build_runner build`

### 3. Notifications

To add push notifications:

1. Add Firebase dependencies to `pubspec.yaml`
2. Configure Firebase for your project
3. Update `AlertsNotifier` to send notifications
4. Add permission handling in `main.dart`

## Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, documented code
   - Add tests for new functionality
   - Update README if needed

3. **Test thoroughly**
   ```bash
   flutter analyze
   flutter test
   flutter run
   ```

4. **Commit with clear messages**
   ```bash
   git commit -m "feat: add new sensor type for humidity"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Provide clear description of changes
   - Reference any related issues
   - Include screenshots for UI changes

## Commit Message Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```
feat: add humidity sensor support
fix: correct temperature threshold calculation
docs: update installation instructions
test: add tests for alert provider
```

## Code Review Checklist

Before submitting a PR, ensure:

- [ ] Code follows Dart/Flutter style guidelines
- [ ] All tests pass
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] No linting errors (`flutter analyze`)
- [ ] Code is formatted (`dart format .`)
- [ ] UI changes are responsive and accessible
- [ ] Comments explain complex logic

## Hardware Integration

If you're contributing hardware sensor integration:

1. Document the hardware requirements
2. Provide connection diagrams
3. Include calibration procedures
4. Add error handling for connection issues
5. Test with actual hardware
6. Update README with setup instructions

## Questions or Issues?

- Open an issue for bugs or feature requests
- Use Discussions for questions
- Check existing issues before creating new ones

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be acknowledged in the project README. Thank you for helping improve Smart Lab Guardian!
