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
      cityName: json['cityName'] ?? 'Bilinmiyor',
      country: json['country'] ?? '??',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as int?) ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? 'Tanımsız',
    );
  }
}