import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:temperature_sample/api.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF070717),
        fontFamily: GoogleFonts.josefinSans().fontFamily,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
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
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: getWeather,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Today\'s Report',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AvatarGlow(
                  glowColor: Theme.of(context).primaryColorDark,
                  curve: Curves.ease,
                  startDelay: Duration(microseconds: 5100),
                  glowCount: 1,
                  glowRadiusFactor: 0.2,

                  // duration: const Duration(milliseconds: 200),
                  child: Lottie.asset(
                    weatherAnimation(currentWeather?.main),
                    height: 200,
                  ),
                ),
                const SizedBox(width: 20),
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
                if (status == Status.PENDING)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                const SizedBox(
                  height: 30,
                ),
                if (status == Status.ACTIVE)
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
                              "Country:  ${currentWeather!.country} | City: ${currentWeather!.city}",
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
              ],
            ),
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
