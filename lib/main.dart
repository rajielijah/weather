import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_test/view/weather_page.dart';

import 'logic/provider/weather_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}
