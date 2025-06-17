# WeatherApp

A simple Flutter weather application that fetches and displays the current weather and hourly forecast for the user's current location using the [OpenWeatherMap 5 Day / 3 Hour Forecast API](https://openweathermap.org/forecast5).

## Features

- Get weather data based on the user's current location (using device GPS)
- Displays:
  - Current temperature, sky condition, and weather icon
  - Hourly forecast (next 8 time slots)
  - Additional info: humidity, wind speed, and pressure
- Pull-to-refresh support

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An [OpenWeatherMap API key](https://openweathermap.org/appid)

### Setup

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd weatherapp
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Add your OpenWeatherMap API key:**
   - Open `lib/weather_screen.dart`
   - Replace the value of `apiKey` with your own API key:
     ```dart
     String apiKey = 'YOUR_API_KEY';
     ```

### Running the App

```sh
flutter run
```

## Project Structure

```
lib/
  main.dart             // App entry point
  weather_screen.dart   // Main UI and logic
test/
  widget_test.dart      // Basic widget test
```

## Dependencies

- [http](https://pub.dev/packages/http)
- [geolocator](https://pub.dev/packages/geolocator)
- [flutter/material.dart](https://api.flutter.dev/flutter/material/material-library.html)

## Notes

- The app fetches weather data for the user's current location. Make sure location services are enabled on your device/emulator.
- The free OpenWeatherMap API has usage limits. See their [pricing page](https://openweathermap.org/price) for details.

## Screenshots

![Screenshot 2025-06-17 134058](https://github.com/user-attachments/assets/2879eadb-797d-47f8-9faf-892f5baa6932)


## License

MIT License

---

**Happy Coding!**
