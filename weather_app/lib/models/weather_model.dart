class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String description;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
  });
  
  // json verisini doğrudan bu modele çevirebiliriz
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'],
    );
  }
}