import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

class DetailPage extends StatelessWidget {
  final WeatherModel weather;

  const DetailPage({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${weather.cityName}, ${weather.country}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sıcaklık: ${weather.temperature}°C',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Hissedilen: ${weather.temperature}°C'),
            Text('Açıklama: ${weather.description}'),
            Text('Nem: ${weather.humidity}%'),
            Text('Rüzgar: ${weather.windSpeed} m/s'),
            weather.backgroundImage.isNotEmpty
                ? Image.network(weather.backgroundImage)
                : Container(),
          ],
        ),
      ),
    );
  }
}
