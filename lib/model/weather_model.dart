class Weather {
  final String cityNaame;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityNaame,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityNaame: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
