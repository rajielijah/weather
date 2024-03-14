import 'package:flutter/material.dart';

import '../logic/models/city_model.dart';


Color textColor = const Color(0xFF222939);

const height25 = SizedBox(
  height: 25,
);

TextStyle f14RblackLetterSpacing2 = TextStyle(
    fontSize: 14, fontFamily: 'Poppins', color: textColor, letterSpacing: 2);

TextStyle f14RwhiteLetterSpacing2 = const TextStyle(
    fontSize: 14, fontFamily: 'Poppins', color: Colors.white, letterSpacing: 2);

TextStyle f16PW =
    const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16);

TextStyle f24Rwhitebold = const TextStyle(
    fontSize: 24,
    fontFamily: 'Poppins',
    color: Colors.white,
    fontWeight: FontWeight.bold);

TextStyle f24Rblackbold = const TextStyle(
    fontSize: 24,
    fontFamily: 'Poppins',
    color: Colors.black,
    fontWeight: FontWeight.bold);

TextStyle f20Rblackbold = const TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    color: Colors.black,
    fontWeight: FontWeight.bold);

TextStyle f42Rwhitebold = const TextStyle(
    fontSize: 42,
    fontFamily: 'Poppins',
    color: Colors.white,
    fontWeight: FontWeight.bold);

List<String> cities = ['Lagos', 'Abuja', 'Port Harcourt'];

  List<City> allCities = [
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

List<City> updatedCities = [];
  List<City> get selectedCities => allCities.where((city) => city.isSelected).toList();

 List<String> getSelectedCityNames() {
    return updatedCities
        .where((city) => city.isSelected) // Filter cities that are selected
        .map((city) => city.name) // Extract the name of each selected city
        .toList(); // Collect names into a List<String>
  }