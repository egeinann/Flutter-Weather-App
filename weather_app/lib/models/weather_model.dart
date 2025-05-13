import 'dart:ui';

import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/image_strings.dart';

class WeatherModel {
  final String cityName;
  final String country;
  final int temperature;
  final int humidity;
  final double windSpeed;
  final String description;
  final bool isDay;
  final int tempMin; // yeni eklendi
  final int tempMax; // yeni eklendi

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.isDay,
    required this.tempMin,
    required this.tempMax,
  });

  // JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'country': country,
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'description': description,
      'isDay': isDay,
      'tempMin': tempMin,
      'tempMax': tempMax,
    };
  }

  // JSON'dan nesneye çevir
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'] ?? 'Unknown',
      country: json['country'] ?? '--',
      temperature: (json['temperature'] as num?)?.round() ?? 0,
      humidity: (json['humidity'] as int?) ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? 'undefined',
      isDay: json['isDay'] ?? true,
      tempMin: (json['tempMin'] as num?)?.round() ?? 0,
      tempMax: (json['tempMax'] as num?)?.round() ?? 0,
    );
  }

  String get _lowerDesc => description.toLowerCase();
  String get timeOfDay => isDay ? 'Day' : 'Night';
  bool _has(String keyword) => _lowerDesc.contains(keyword);

  // *** API'DEN GELEN VERİLERE GÖRE DÖNEN ICON GETTER'İ ***
  String get iconAsset {
    if (_has('thunderstorm') ||
        _has('stormy') ||
        _has('blizzard') ||
        _has('freezing rain')) {
      return isDay ? IconImages.dayThunderIcon : IconImages.nightThunderIcon;
    }
    if (_has('snowy') ||
        _has('snow') ||
        _has('sleet') ||
        _has('hail') ||
        _has('blizzard')) {
      return isDay ? IconImages.daySnowyIcon : IconImages.nightSnowyIcon;
    }
    if (_has('rainy') ||
        _has('rain') ||
        _has('drizzle') ||
        _has('freezing rain')) {
      return isDay ? IconImages.dayRainyIcon : IconImages.nightRainyIcon;
    }
    if (_has('partly cloudy') || _has('broken clouds') || _has('few clouds')) {
      return isDay
          ? IconImages.dayPartlyCloudyIcon
          : IconImages.nightPartlyCloudyIcon;
    }
    if (_has('cloudy') || _has('overcast') || _has('clouds')) {
      return IconImages.cloudyIcon; // Same for day and night
    }
    if (_has('clear sky') || _has('clear') || _has('sunny')) {
      return isDay ? IconImages.dayClearIcon : IconImages.nightClearIcon;
    }
    if (_has('foggy') || _has('haze')) {
      return isDay ? IconImages.dayFoggyIcon : IconImages.nightFoggyIcon;
    }
    if (_has('sandstorm') || _has('tornado')) {
      return IconImages.tornadoIcon;
    }
    if (_has('windy')) {
      return IconImages.windIcon;
    }
    return isDay ? IconImages.dayClearIcon : IconImages.nightClearIcon;
  }

  // *** API'DEN GELEN VERİLERE GÖRE DÖNEN BACKGROUND GETTER'İ ***
  String get backgroundImage {
    if (_has('thunderstorm') ||
        _has('stormy') ||
        _has('blizzard') ||
        _has('freezing rain')) {
      return isDay
          ? BackgroundImages.dayThunder
          : BackgroundImages.nightThunder;
    }
    if (_has('snowy') ||
        _has('snow') ||
        _has('sleet') ||
        _has('hail') ||
        _has('blizzard')) {
      return isDay ? BackgroundImages.daySnowy : BackgroundImages.nightSnowy;
    }
    if (_has('rainy') ||
        _has('rain') ||
        _has('drizzle') ||
        _has('freezing rain')) {
      return isDay ? BackgroundImages.dayRainy : BackgroundImages.nightRainy;
    }
    if (_has('sandstorm')) return BackgroundImages.sandstorm;
    if (_has('tornado')) return BackgroundImages.tornado;
    if (_has('broken clouds') || _has('few clouds')) {
      return isDay
          ? BackgroundImages.dayBrokenClouds
          : BackgroundImages.nightBrokenClouds;
    }
    if (_has('clear sky') || _has('clear') || _has('sunny')) {
      return isDay ? BackgroundImages.dayClear : BackgroundImages.nightClear;
    }
    if (_has('partly cloudy')) {
      return isDay
          ? BackgroundImages.dayBrokenClouds
          : BackgroundImages.nightBrokenClouds;
    }
    if (_has('cloudy') || _has('overcast') || _has('clouds')) {
      return isDay ? BackgroundImages.dayCloudy : BackgroundImages.nightCloudy;
    }
    return isDay ? BackgroundImages.dayClear : BackgroundImages.nightClear;
  }

  // *** API'DEN GELEN VERİLERE GÖRE DÖNEN RENK GETTER'İ ***
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
}
