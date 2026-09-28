# Gemini Chat

A clean Flutter chat application powered by Google's Gemini API.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Gemini](https://img.shields.io/badge/Google-Gemini-4285F4?logo=google)

## Overview

Gemini Chat is a lightweight AI chat client built with Flutter and the Gemini `generateContent` API. It focuses on a simple conversation UI, responsive message bubbles, loading feedback, and runtime API-key configuration.

## Features

- Chat with Gemini from a clean Material 3 interface
- Async API requests with loading feedback
- Selectable AI and user messages
- Flutter UI targeting mobile, web, and desktop
- API keys provided at runtime instead of committed to source

## Tech Stack

- Flutter
- Dart
- Material 3
- `http`
- Google Gemini API

## Getting Started

### 1. Prerequisites

Install Flutter and make sure `flutter doctor` completes successfully.

### 2. Configure your Gemini API key

Create a Gemini API key through Google AI Studio, then run the app with a Dart environment variable:

```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_API_KEY
```

For an Android release build:

```bash
flutter build apk --dart-define=GEMINI_API_KEY=YOUR_API_KEY
```

Do not commit API keys to Git.

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Analyze and test

```bash
flutter analyze
flutter test
```

## Project Structure

```text
lib/
└── main.dart
```

The project intentionally keeps the implementation small so the core Gemini integration stays easy to follow.

## Security Note

The app currently calls Gemini directly from the Flutter client. For production deployments, move API calls behind a secure backend so the API key is not exposed to end users.

## License

This project is available under the MIT License. See `LICENSE`.
