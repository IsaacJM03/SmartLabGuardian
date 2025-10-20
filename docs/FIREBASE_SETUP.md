# Firebase Setup Guide

This guide explains how to integrate Firebase with Smart Lab Guardian for cloud sync and push notifications.

## Prerequisites

- Firebase account
- Firebase CLI installed
- FlutterFire CLI installed

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "Smart Lab Guardian"
4. Follow the setup wizard

## Step 2: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

## Step 3: Configure Firebase

```bash
# Login to Firebase
firebase login

# Configure Flutter app
flutterfire configure
```

## Step 4: Update pubspec.yaml

Add Firebase dependencies:

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.6
  cloud_firestore: ^4.13.6
```

## Step 5: Initialize Firebase

Update `main.dart` to initialize Firebase before running the app.

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

For complete setup instructions, see the full guide in this file.
