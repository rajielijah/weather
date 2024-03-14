import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:weather_test/constant/string_manager.dart';
import 'package:weather_test/constant/values_managers.dart';
import 'package:weather_test/view/weather_carousel.dart';
import '../constant/constant.dart';
import '../logic/models/city_model.dart';
import '../logic/models/weather_model.dart';
import '../logic/provider/weather_provider.dart';
import '../logic/services/call_to_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String? _selectedCity;
  List<Map<String, dynamic>> weatherData = [];
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }
  TextEditingController textController = TextEditingController(text: "");
  Future<WeatherModel>? _myData;
  @override
  void initState() {
    setState(() {
      _myData = getData(true, "");
    });
    Provider.of<WeatherProvider>(context, listen: false).loadCities();
    CallToApi().fetchWeatherData(cities).then((data) {
      setState(() {
        weatherData = data;
      });
    });
    super.initState();
  }
  void updatedWeatherData() {
       CallToApi().fetchWeatherForSelectedCities().then((value) {
        if(mounted) {
        setState((){
          weatherData = value;
        });
      }}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If error occured
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: const TextStyle(fontSize: AppSize.s18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as WeatherModel;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s15, vertical: AppSize.s10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromARGB(255, 65, 89, 224),
                      Color.fromARGB(255, 83, 92, 215),
                      Color.fromARGB(255, 86, 88, 177),
                      Color(0xfff39060),
                      Color(0xffffb56b),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      AnimSearchBar(
                        onSubmitted: (p0) {  },
                        rtl: true,
                        width: double.infinity,
                        color: const Color(0xffffb56b),
                        textController: textController,
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: AppSize.s26,
                        ),
                        onSuffixTap: () async {
                          textController.text == ""
                              ? log(AppStrings.noCity)
                              : setState(() {
                                  _myData = getData(false, textController.text);
                                });

                          FocusScope.of(context).unfocus();
                          textController.clear();
                        },
                        style: f14RblackLetterSpacing2,
                      ),
                      Text(AppStrings.listOfCity, style: f24Rwhitebold,),
                      const SizedBox(height: AppSize.s20,),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: AppSize.s4),
                        decoration: BoxDecoration(
                          color: const Color(0xffffb56b), 
                          borderRadius: BorderRadius.circular(AppSize.s10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26, // Shadow color
                              blurRadius: 8, // Blur radius
                              offset: Offset(AppSize.s0, AppSize.s2), // Shadow position
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text(AppStrings.selectCity),
                            value: _selectedCity,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            iconSize: AppSize.s24, 
                            elevation: AppSize.i16, // Elevation for the dropdown menu
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                            dropdownColor: Colors.blueGrey, 
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCity = newValue!;
                                _myData = getData(false, _selectedCity!);
                              });
                              },
                            items: allCities.map<DropdownMenuItem<String>>((City city) {
                              return DropdownMenuItem<String>(
                                value: city.name,
                                child: Text(city.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.city,
                              style: f24Rwhitebold,
                            ),
                            height25,
                            Text(
                              data.desc,
                              style: f16PW,
                            ),
                            height25,
                            Text(
                              "${data.temp}°C",
                              style: f42Rwhitebold,
                            ),
                          ],
                        ),
                      ),
                weatherData.isNotEmpty
            ? WeatherCarousel(weatherData: weatherData)
            : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                _showEditCitiesDialog();
              },
              child: Text(AppStrings.addCity, style: f20Rblackbold,),
            )
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return const Center(
            child: Text(AppStrings.serverTimedOut),
          );
        },
        future: _myData!,
      ),
    );
  }
  void _showEditCitiesDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Temporary list to manage changes before confirming.
      List<City> tempSelectedCities = List.from(allCities.where((city) => city.isSelected));

      return StatefulBuilder( // Use StatefulBuilder to update dialog content dynamically.
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(AppStrings.select3City),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: allCities.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isCurrentlySelected = tempSelectedCities.contains(allCities[index]);
                  return CheckboxListTile(
                    title: Text(allCities[index].name),
                    value: isCurrentlySelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        if (tempSelectedCities.length < 3) {
                          setState(() {
                            tempSelectedCities.add(allCities[index]);
                            allCities[index].isSelected = true;
                          });
                        } else {
                          // Show a SnackBar or another form of alert to inform the user.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.snackBarMessage),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      } else {
                        setState(() {
                          tempSelectedCities.remove(allCities[index]);
                          allCities[index].isSelected = false;
                        });
                      }
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(AppStrings.done),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    // Update the main list with the temporary selections.
                    updatedCities = List.from(tempSelectedCities);
                    log(updatedCities[2].name);
                    updatedWeatherData();
                   });
                },
              ),
            ],
          );
        },
      );
    },
  );
}
}
