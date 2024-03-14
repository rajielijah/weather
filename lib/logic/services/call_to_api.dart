import 'dart:convert';
import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:http/http.dart" as http;
import 'package:weather_test/constant/base_api.dart';
import 'package:weather_test/constant/string_manager.dart';
import '../../constant/api_key.dart';
import '../../constant/constant.dart';
import '../models/weather_model.dart';

class CallToApi {
  Future<WeatherModel> callWeatherAPi(bool current, String cityName) async {
    try {
      Position currentPosition = await getCurrentPosition();
  
      if (current) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude);

        Placemark place = placemarks[0];
        cityName = place.locality!;
      }

      var url = Uri.https('api.openweathermap.org', '/data/2.5/weather',
          {'q': cityName, "units": "metric", "appid": apiKey});
      final http.Response response = await http.get(url);
      log(response.body.toString());
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        return WeatherModel.fromMap(decodedJson);
      } else {
        throw Exception(AppStrings.failed);
      }
    } catch (e) {
      throw Exception(AppStrings.failed);
    }
  }

  Future<List<Map<String, dynamic>>> fetchWeatherData(List<String> cities) async {
  List<Map<String, dynamic>> weatherData = [];
  for (String city in cities) {
    var url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      weatherData.add({
        'cityName': city,
        'temperature': data['main']['temp'],
        'weather': data['weather'][0]['main'], 
      });
    } else {
     throw Exception(AppStrings.failed);
    }
  }

  return weatherData;
}

Future<List<Map<String, dynamic>>> fetchWeatherForSelectedCities() async {
  List<String> selectedCityNames = getSelectedCityNames();
  List<Map<String, dynamic>> weatherData = [];

  for (String cityName in selectedCityNames) {
       var url = Uri.parse('$baseUrl=$cityName&appid=$apiKey&units=metric');
    try {
      var response = await http.get(url);
     if (response.statusCode == 200) {
      var data = json.decode(response.body);
      weatherData.add({
        'cityName': cityName,
        'temperature': data['main']['temp'],
        'weather': data['weather'][0]['main'], 
      });
      log(weatherData.toString());
    } else {
           throw Exception(AppStrings.failed);
    }
    } catch (e) {
      // Handle any exceptions
          throw Exception(AppStrings.failed);

    }
  }
  return weatherData;
}


  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(AppStrings.locationDisable);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error(AppStrings.locationDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          AppStrings.noLocation);
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}