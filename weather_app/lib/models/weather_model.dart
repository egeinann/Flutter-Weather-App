import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/utils/lottie_strings.dart';

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

  String get _lowerDesc => description.toLowerCase();

  bool _has(String keyword) => _lowerDesc.contains(keyword);

  /// 🌤 Icon asset
  String get iconAsset {
    if (_has('thunder') || _has('storm')) return IconImages.thunderIcon;
    if (_has('snow')) return IconImages.snowyIcon;
    if (_has('rain') || _has('drizzle')) return IconImages.rainyIcon;
    if (_has('clear')) return IconImages.sunnyIcon;
    if (_has('clouds') || _has('cloud')) {
      if (_has('broken') || _has('scattered') || _has('few')) {
        return IconImages.sunnyCloudyIcon;
      }
      return IconImages.cloudyIcon;
    }
    return IconImages.windIcon;
  }

  /// 🌄 Background image
  String get backgroundImage {
    if (_has('thunder') || _has('storm')) return BackgroundImages.thunderBackground;
    if (_has('snow')) return BackgroundImages.snowyBackground;
    if (_has('rain') || _has('drizzle')) return BackgroundImages.rainyBackground;
    if (_has('clear')) return BackgroundImages.sunnyBackground;
    if (_has('clouds') || _has('cloud')) {
      if (_has('broken') || _has('scattered') || _has('few')) {
        return BackgroundImages.sunnyBackground;
      }
      return BackgroundImages.cloudyBackground;
    }
    return BackgroundImages.sunnyBackground;
  }

  /// 🔁 Lottie animation
  String get lottieAsset {
    if (_has('thunder') || _has('storm')) return LottieFiles.thunder;
    if (_has('snow')) return LottieFiles.snowy;
    if (_has('rain') || _has('drizzle')) return LottieFiles.foggy;
    if (_has('clear')) return LottieFiles.sunny;
    if (_has('clouds') || _has('cloud')) {
      if (_has('broken') || _has('scattered') || _has('few')) {
        return LottieFiles.partlycloudy;
      }
      return LottieFiles.cloudy;
    }
    return LottieFiles.daynight;
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'] ?? 'Unknown',
      country: json['country'] ?? '--',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as int?) ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? 'undefined',
    );
  }
}
