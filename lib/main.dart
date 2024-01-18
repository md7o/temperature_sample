import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:temperature_sample/weather_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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
      home: const WeatherPage(),
    );
  }
}
