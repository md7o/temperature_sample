import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:temperature_sample/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color.fromARGB(255, 200, 200, 200)),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Weather currentWeather;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
                    "${currentWeather.city}, ${currentWeather.country}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
            Text(
              "${currentWeather.temp.toString()}°",
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(currentWeather.getIcon(), height: 40),
                Text(
                  "${currentWeather.main}: ${currentWeather.desc}",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )

            // Column(
            //   children: [
            //     if (status == Status.ERROR)
            //       HighlightedMsg(
            //         msg: "Error",
            //         color: Colors.red[100],
            //       ),
            //   ],
            // ),
          ],
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
