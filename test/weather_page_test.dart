import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:weather_test/logic/provider/weather_provider.dart';
import 'package:weather_test/logic/services/call_to_api.dart';
import 'package:weather_test/view/weather_page.dart';

class MockWeatherProvider extends Mock implements WeatherProvider {}
class MockCallToApi extends Mock implements CallToApi {}


void main() {
  // Initialize the mock instances
  final mockWeatherProvider = MockWeatherProvider();

  group('WeatherPage Tests', () {
    testWidgets('displays loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<WeatherProvider>(
          create: (_) => mockWeatherProvider,
          child: const WeatherPage(),
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Selecting cities updates weather data', (WidgetTester tester) async {
   
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<WeatherProvider>(
          create: (_) => mockWeatherProvider,
          child: const WeatherPage(),
        ),
      ));

     });
  });
}
