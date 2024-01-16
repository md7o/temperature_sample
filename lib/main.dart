import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:temperature_sample/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: const Color(0xFFC8C8C8),
          fontFamily: GoogleFonts.josefinSans().fontFamily),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Weather? currentWeather;
  late Status status;
  String error = "";

  Future<void> getWeather() async {
    String _error = "";

    try {
      final _currentWeather = await API.instance.getCurrentWeather();

      setState(() {
        currentWeather = _currentWeather;
        status = Status.ACTIVE;
      });
    } catch (e) {
      _error = e.toString();
      setState(() {
        error = _error;
        status = Status.ERROR;
      });
      return;
    }
  }

  String weatherAnimation(String? main) {
    if (main == null) return 'assets/A.json';

    switch (main.toLowerCase()) {
      case 'clouds':
      case 'dust':
      case 'fog':
        return 'assets/A.json';
      case 'rain':
      case 'dizzle':
        return 'assets/B.json';
      case 'clear':
        return 'assets/C.json';
      default:
        return 'assets/C.json';
    }
  }

  @override
  void initState() {
    status = Status.PENDING;
    getWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: RefreshIndicator(
        onRefresh: getWeather,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Today\'s Report',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(weatherAnimation(currentWeather?.main)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Its ${currentWeather?.main}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${currentWeather?.temp.toString()}",
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '°',
                        style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      )
                    ],
                  ),
                ],
              ),
              if (status == Status.PENDING)
                const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              if (status == Status.ACTIVE)
                Column(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 30,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${currentWeather!.city}, ${currentWeather!.country}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HighlightedMsg extends StatelessWidget {
  const HighlightedMsg({
    Key? key,
    required this.msg,
    required this.color,
  }) : super(key: key);
  final String msg;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(color: color ?? Theme.of(context).highlightColor),
        padding: const EdgeInsets.all(20),
        child: Text(
          msg,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
