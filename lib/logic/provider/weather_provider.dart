import 'package:flutter/material.dart';
import 'package:weather_test/logic/services/call_to_api.dart';
import '../models/city_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  final List<City> _cities = [
    City(name: 'Lagos', isSelected: true),
    City(name: 'Kano', isSelected: false),
    City(name: 'Abuja', isSelected: true),
    City(name: 'Ibadan', isSelected: false),
    City(name: 'Port Harcourt', isSelected: true),
    City(name: 'Aba', isSelected: false),
    City(name: 'Onitsha', isSelected: false),
    City(name: 'Maiduguri', isSelected: false),
    City(name: 'Benin City', isSelected: false),
    City(name: 'Ikare', isSelected: false),
    City(name: 'Shagamu', isSelected: false),
    City(name: 'Ogbomoso', isSelected: false),
    City(name: 'Owerri', isSelected: false),
    City(name: 'Ikeja', isSelected: false),
    City(name: 'Osogbo', isSelected: false),
  ];

  final Map<String, dynamic> _weatherData = {};
  List<City> get selectedCities => _cities.where((city) => city.isSelected).toList();
  List<City> get cities => _cities;
  Map<String, dynamic> get weatherData => _weatherData;

  Future<void> fetchWeather(String city) async {
    final data = await CallToApi().callWeatherAPi(true, city);
    _weatherData[city] = data;
    notifyListeners();
  }

  Future<void> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> selectedCities = prefs.getStringList('selectedCities') ?? [];
    for (var city in _cities) {
      city.isSelected = selectedCities.contains(city.name);
    }
    notifyListeners();
  }
}
