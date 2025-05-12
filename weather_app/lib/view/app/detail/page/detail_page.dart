import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/moreDetails_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/view/app/detail/methods/detail_appbar.dart';
import 'package:weather_app/view/app/detail/methods/detail_bottomsheet.dart';
import 'package:weather_app/view/app/detail/methods/detail_build_icon.dart';
import 'package:weather_app/view/app/detail/methods/detail_build_weather.dart';
import 'package:weather_app/widgetsGlobal/shimmer.dart';

class DetailPage extends StatelessWidget {
  final WeatherModel weather;

  const DetailPage({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MoredetailsModel> moreDetails = [
      MoredetailsModel(
          backgroundColor: Colors.pink,
          title: "humidity",
          value: "${weather.humidity}%",
          image: IconImages.rainIcon),
      MoredetailsModel(
          backgroundColor: Colors.blue,
          title: "windSpeed",
          value: "${weather.windSpeed}m/s",
          image: IconImages.tornadoIcon),
      MoredetailsModel(
          backgroundColor: Colors.green,
          title: "tempMin",
          value: "${weather.tempMin}°",
          image: IconImages.minTemp),
      MoredetailsModel(
        backgroundColor: Colors.orange,
        title: "tempMax",
        value: "${weather.tempMax}°",
        image: IconImages.maxTemp,
      ),
    ];
    return Scaffold(
      body: GestureDetector(
        child: Container(
          decoration: const BoxDecoration(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: weather.backgroundImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => customShimmer(
                    Container(color: Colors.grey[300]),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    detailAppBar(context, weather),
                    detailBuildWeather(weather, context),
                    detailBuildIcon(weather),
                  ],
                ),
              ),
              detailBottomSheet(moreDetails),
            ],
          ),
        ),
      ),
    );
  }
}
