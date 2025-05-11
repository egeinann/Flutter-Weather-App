import 'dart:ui';

import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/utils/lottie_strings.dart';

class WeatherModel {
  final String cityName;
  final String country;
  final int temperature;
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

  String get iconAsset {
    if (_has('thunderstorm') ||
        _has('stormy') ||
        _has('blizzard') ||
        _has('freezing rain')) {
      return IconImages.thunderIcon;
    }
    if (_has('snowy') ||
        _has('snow') ||
        _has('sleet') ||
        _has('hail') ||
        _has('blizzard')) {
      return IconImages.snowyIcon;
    }
    if (_has('rainy') ||
        _has('rain') ||
        _has('drizzle') ||
        _has('freezing rain')) {
      return IconImages.rainyIcon;
    }
    if (_has('partly cloudy') || _has('broken clouds') || _has('few clouds')) {
      return IconImages.sunnyCloudyIcon;
    }
    if (_has('cloudy') || _has('overcast') || _has('clouds')) {
      return IconImages.cloudyIcon;
    }
    if (_has('clear sky') || _has('clear') || _has('sunny')) {
      return IconImages.sunnyIcon;
    }
    if (_has('sandstorm') || _has('tornado') || _has('windy')) {
      return IconImages.windIcon;
    }
    return IconImages.windIcon;
  }

  String get backgroundImage {
    if (_has('thunderstorm') ||
        _has('stormy') ||
        _has('blizzard') ||
        _has('freezing rain')) {
      return BackgroundImages.thunderBackground;
    }
    if (_has('snowy') ||
        _has('snow') ||
        _has('sleet') ||
        _has('hail') ||
        _has('blizzard')) {
      return BackgroundImages.snowyBackground;
    }
    if (_has('rainy') ||
        _has('rain') ||
        _has('drizzle') ||
        _has('freezing rain')) {
      return BackgroundImages.rainyBackground;
    }
    if (_has('sandstorm')) return BackgroundImages.sandstormBackground;
    if (_has('tornado')) return BackgroundImages.tornadoBackground;
    if (_has('broken clouds') || _has('few clouds'))
      return BackgroundImages.brokencloudsBackground;
    if (_has('clear sky') ||
        _has('clear') ||
        _has('sunny') ||
        _has('partly cloudy')) {
      return BackgroundImages.sunnyBackground;
    }
    if (_has('cloudy') || _has('overcast') || _has('clouds')) {
      return BackgroundImages.cloudyBackground;
    }
    return BackgroundImages.sunnyBackground;
  }

  String get lottieAsset {
    if (_has('thunderstorm') ||
        _has('stormy') ||
        _has('blizzard') ||
        _has('freezing rain')) {
      return LottieFiles.thunder;
    }
    if (_has('snowy') ||
        _has('snow') ||
        _has('sleet') ||
        _has('hail') ||
        _has('blizzard')) {
      return LottieFiles.snowy;
    }
    if (_has('rainy') ||
        _has('rain') ||
        _has('drizzle') ||
        _has('freezing rain')) {
      return LottieFiles.foggy;
    }
    if (_has('partly cloudy') || _has('broken clouds') || _has('few clouds')) {
      return LottieFiles.partlycloudy;
    }
    if (_has('cloudy') || _has('overcast') || _has('clouds')) {
      return LottieFiles.cloudy;
    }
    if (_has('clear sky') || _has('clear') || _has('sunny')) {
      return LottieFiles.sunny;
    }
    if (_has('foggy') || _has('haze')) {
      return LottieFiles.cloudy;
    }
    return LottieFiles.daynight;
  }

  Color get backgroundColor {
    if (_has('thunderstorm') ||
        _has('stormy') ||
        _has('blizzard') ||
        _has('freezing rain')) {
      return WeatherColors.stormy;
    }
    if (_has('snowy') ||
        _has('snow') ||
        _has('sleet') ||
        _has('hail') ||
        _has('blizzard')) {
      return WeatherColors.snowy;
    }
    if (_has('rainy') ||
        _has('rain') ||
        _has('drizzle') ||
        _has('freezing rain')) {
      return WeatherColors.rainy;
    }
    if (_has('sandstorm')) return WeatherColors.sandstorm;
    if (_has('tornado') || _has('windy')) return WeatherColors.windy;
    if (_has('broken clouds') ||
        _has('few clouds') ||
        _has('cloudy') ||
        _has('overcast') ||
        _has('clouds')) {
      return WeatherColors.cloudy;
    }
    if (_has('clear sky') ||
        _has('clear') ||
        _has('sunny') ||
        _has('partly cloudy')) {
      return WeatherColors.sunny;
    }
    return WeatherColors.sunny;
  }
  
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'] ?? 'Unknown',
      country: json['country'] ?? '--',
      temperature: (json['temperature'] as num?)?.round() ?? 0, // yuvarlama
      humidity: (json['humidity'] as int?) ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? 'undefined',
    );
  }
}
