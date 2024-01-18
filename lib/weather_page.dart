import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:temperature_sample/api2.dart';
import "package:temperature_sample/model/weather_model.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('');
  Weather? _weather;

  _fechWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _fechWeather();
  }

  String weatherAnimation(String? main) {
    if (main == null) return 'assets/A.json';

    switch (main.toLowerCase()) {
      case 'clouds':
      case 'dust':
      case 'fog':
        return 'assets/B.json';
      case 'clear':
        return 'assets/C.json';
      default:
        return 'assets/C.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 13, 23, 60),
              Color.fromARGB(255, 0, 7, 20),
            ],
          ),
        ),
        child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   actions: [
            //     IconButton(
            //       onPressed: () {
            //         Geolocator.openAppSettings();
            //       },
            //       icon: const Icon(
            //         Icons.pin_drop,
            //         color: Colors.white,
            //         size: 30,
            //       ),
            //     )
            //   ],
            // ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Today\'s Report',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AvatarGlow(
                      glowColor: Theme.of(context).primaryColorDark,
                      curve: Curves.ease,
                      startDelay: const Duration(microseconds: 5100),
                      glowCount: 1,
                      glowRadiusFactor: 0.2,

                      // duration: const Duration(milliseconds: 200),
                      child: Lottie.asset(
                        weatherAnimation(_weather?.mainCondition),
                        height: 200,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Its ${_weather?.cityName ?? 'loading city...'}",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_weather?.temperature.round()}°C',
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const Text(
                        //   '°',
                        //   style: TextStyle(
                        //       fontSize: 80,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.blue),
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColorDark,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.location_pin,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "City: ${_weather?.cityName}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
