import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

import '../widget/airQuality.dart';
import '../widget/constant.dart';
import '../widget/weatherToday.dart';
import 'landing screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;
  bool isforcasr = true;
  bool isday = true;

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    getWeatherData();
    print(
        "my latitude is ${position!.latitude}  longitute is ${position!.longitude}");
  }

  getWeatherData() async {
    var weather = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position!.longitude}&appid=8e76b9a11a31a0bfd57e527e1ebf379a&units=metric"));
    // print("${weather.body}");
    var forecast = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${position!.latitude}&lon=${position!.longitude}&appid=8e76b9a11a31a0bfd57e527e1ebf379a&units=metric"));
    // print("${forecast.body}");
    var airQuality = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/air_pollution?lat=${position!.latitude}&lon=${position!.longitude}&appid=8e76b9a11a31a0bfd57e527e1ebf379a&units=metric"));
    print("${airQuality.body}");

    var weatherData = jsonDecode(weather.body);
    var forecastData = jsonDecode(forecast.body);
    var airQualitydata = jsonDecode(airQuality.body);

    setState(() {
      weatherMap = Map<String, dynamic>.from(weatherData);
      forecastMap = Map<String, dynamic>.from(forecastData);
      airQualityMap = Map<String, dynamic>.from(airQualitydata);
    });
  }

  @override
  void initState() {
    determinePosition();
    // TODO: implement initState
    if (DateTime.now().hour > 5 && DateTime.now().hour < 18) {
      isday = true;
    } else
      isday = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _mediaHeight = MediaQuery.of(context).size.height;
    double _mediaWeight = MediaQuery.of(context).size.width;
    String backgroundImage =
        isday == true ? "assets/daybc.jpg" : "assets/nightbc.jpg";

    return airQualityMap?.length == null?
    LoadingScreen()
        : SafeArea(
            child: Scaffold(
              //floatingActionButton: IconButton(onPressed: (){}, icon: null,),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    backgroundImage,
                    height: _mediaHeight,
                    width: _mediaWeight,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${weatherMap!["name"]}, ${weatherMap!["sys"]["country"]}",
                            style: TextStyle(
                                color: lightColor,
                                fontSize: 40,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.transparent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: isforcasr == true
                                          ? Color(0xff1B6DDA)
                                          : Colors.transparent,
                                    ),
                                    child: const Text(
                                      "Forcast",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isforcasr = true;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: isforcasr == false
                                          ? const Color(0xff1B6DDA)
                                          : Colors.transparent,
                                    ),
                                    child: const Text(
                                      "Air Quality",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isforcasr = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "${Jiffy.parse("${DateTime.now()}").format(pattern: 'MMM do yyyy')}, ${Jiffy.parse("${DateTime.now()}").format(pattern: 'hh:mm a')}",
                              style:
                                  TextStyle(color: lightColor, fontSize: 18)),
                          const SizedBox(height: 15),
                          SizedBox(
                              child: isforcasr == true
                                  ? WeatherToday()
                                  : AirQuality()),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "  Hourly Forecast",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: lightColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              alignment: Alignment.center,
                                height: 160,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.transparent.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,shrinkWrap: true,
                                    itemCount: forecastMap!.length,
                                    itemBuilder: (context, index) => Container(
                                      alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              " ${Jiffy.parse("${forecastMap!["list"][index]["dt_txt"]}").format(pattern: 'hh:mm a')}",
                                              style: forcasttext,
                                              textAlign: TextAlign.center,
                                            ),
                                            Image.network(
                                              "https://openweathermap.org/img/wn/${forecastMap!["list"][index]["weather"][0]["icon"]}@2x.png",
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(
                                              "${forecastMap!["list"][index]["main"]["temp"]}°C",
                                              style: forcasttext,
                                            ),
                                            Text(
                                              "${forecastMap!["list"][index]["weather"][0]["main"]}",
                                              style: forcasttext,
                                            ),
                                          ],
                                        )))),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  TextStyle forcasttext =
      TextStyle(fontSize: 16, color: lightColor, fontWeight: FontWeight.w300);
}
