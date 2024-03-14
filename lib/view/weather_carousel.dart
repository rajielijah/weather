import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:weather_test/constant/constant.dart';

class WeatherCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> weatherData;

  const WeatherCarousel({super.key, required this.weatherData});

  @override
Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 16/9,
        viewportFraction: 0.8,
      ),
      items: weatherData.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Card(
              color: const Color.fromARGB(255, 86, 88, 177),
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      item['cityName'],
                      style: f24Rwhitebold),
                    Text("Temperature: ${item['temperature']}°C", style: f14RwhiteLetterSpacing2,),
                    Text("Weather: ${item['weather']}", style: f14RwhiteLetterSpacing2,),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
