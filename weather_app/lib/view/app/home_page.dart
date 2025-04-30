import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/utils/lottie_files.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Kaydırılabilir yapı
        child: Column(
          children: [
            _buildLottieItem('Bulutlu', LottieFiles.cloudy),
            _buildLottieItem('Gece/Gündüz', LottieFiles.daynight),
            _buildLottieItem('Şehir', LottieFiles.downtown),
            _buildLottieItem('Sisli', LottieFiles.foggy),
            _buildLottieItem('Yükleniyor', LottieFiles.loading),
            _buildLottieItem('Parçalı Bulutlu', LottieFiles.partlycloudy),
            _buildLottieItem('Karlı', LottieFiles.snowy),
            _buildLottieItem('Güneşli', LottieFiles.sunny),
            _buildLottieItem('Gök Gürültülü', LottieFiles.thunder),
          ],
        ),
      ),
    );
  }

  Widget _buildLottieItem(String title, String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          SizedBox(
            height: 200, // Sabit yükseklik
            child: Lottie.asset(path),
          ),
          const Divider(), // Ayırıcı çizgi
        ],
      ),
    );
  }
}
