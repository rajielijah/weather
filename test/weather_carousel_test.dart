import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_test/view/weather_carousel.dart';

void main() {
  group('WeatherCarousel Tests', () {
    testWidgets('displays weather data correctly', (WidgetTester tester) async {
      // Sample weather data to pass to the WeatherCarousel
      final List<Map<String, dynamic>> sampleWeatherData = [
        {
          'cityName': 'Lagos',
          'temperature': '25',
          'weather': 'Sunny',
        },
       ];

      // Build the WeatherCarousel widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WeatherCarousel(weatherData: sampleWeatherData),
        ),
      ));

      // Verify that the carousel displays the correct information
      expect(find.text('Lagos'), findsNWidgets(3));
      expect(find.text('Temperature: 25°C'), findsNWidgets(3));
      expect(find.text('Weather: Sunny'), findsNWidgets(3));
    });
  });
}
