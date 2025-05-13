import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/view/app/detail/page/detail_page.dart';
import 'package:weather_app/widgetsGlobal/blur_container.dart';
import 'package:weather_app/widgetsGlobal/button.dart';
import 'package:weather_app/widgetsGlobal/shimmer.dart';
import 'package:weather_app/widgetsGlobal/textField.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String? _selectedCity;
  WeatherModel? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  List<WeatherModel> recentWeatherData = [];
  final FocusNode _focusNode = FocusNode();
  late AnimationController _controllerAnim;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controllerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controllerAnim,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controllerAnim.dispose();
    _controller.dispose();
    super.dispose();
  }

  // *** GİRİLEN ŞEHİR İÇİN HAVA DURUMUNU ÇEK ***
  void _fetchWeather(String city) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await WeatherService().fetchWeather(city);
      setState(() {
        _weatherData = weather;
        _isLoading = false;

        // Şehri listeye ekle
        if (!recentWeatherData.any((w) => w.cityName == city)) {
          recentWeatherData.insert(0, weather);
          if (recentWeatherData.length > 10) {
            recentWeatherData = recentWeatherData.sublist(0, 10);
          }
        }
      });
      _controllerAnim.reset();
      _controllerAnim.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _weatherData = null;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $_errorMessage')),
      );
    }
  }

  void _clearWeatherCard() {
    setState(() {
      _weatherData = null;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(OnboardingImages.welcome),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.background,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: textField(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? SizedBox()
                    : _errorMessage != null
                        ? Text(
                            "Hata: $_errorMessage",
                            style: const TextStyle(color: Colors.red),
                          )
                        : _weatherData == null
                            ? Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.withOpacity(0.5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      AppIcons.cloud,
                                      size: 20.sp,
                                      color: AppColors.background,
                                    ),
                                    Text(
                                      "Enter city",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ],
                                ),
                              )
                            : SlideTransition(
                                position: _slideAnimation,
                                child: buildWeatherCard(),
                              ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                    label: Text(
                      "Last searched",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    heroTag: "hometosearch",
                    backgroundColor: AppColors.container,
                    splashColor: AppColors.background,
                    foregroundColor: AppColors.background,
                    elevation: 20,
                    shape: ContinuousRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: AppColors.shadow,
                      ),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _focusNode.unfocus();
                      _controller.clear();
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => buildRecentCitiesSheet(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // *** TEXTFIELD ***
  CustomTextField textField() {
    return CustomTextField(
      focusnode: _focusNode,
      controller: _controller,
      onCitySelected: (selectedCity) {
        setState(() {
          _selectedCity = selectedCity;
          _controller.text = selectedCity;
        });
        _fetchWeather(selectedCity);
      },
      onCitySelectedCallback: () {
        if (_controller.text.isNotEmpty) {
          _fetchWeather(_controller.text);
        }
      },
    );
  }

  // *** ARATILAN ŞEHİR ANLIK ***
  Widget buildWeatherCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 200),
            type: PageTransitionType.rightToLeft,
            child: DetailPage(weather: _weatherData!),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: 41.h,
            width: 90.w,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: customIconButton(
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                onPressed: _clearWeatherCard,
                icon: AppIcons.close,
              ),
            ),
          ),
          Container(
            height: 35.h,
            width: 90.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background image with shimmer
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: _weatherData!.backgroundImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => customShimmer(
                        Container(color: Colors.grey.shade300),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey,
                        child: const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customShimmer(
                                Text(
                                  "${_weatherData!.country} - ${_weatherData!.cityName}",
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ),
                              customShimmer(
                                Text(
                                  "${_weatherData!.temperature}°C",
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(20),
                              bottomStart: Radius.circular(20),
                              topEnd: Radius.circular(100),
                              topStart: Radius.circular(100),
                            ),
                            color:
                                _weatherData!.backgroundColor.withOpacity(0.6),
                          ),
                          child: Center(
                            child: customShimmer(
                              Text(
                                _weatherData!.description,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Icon için Cached + shimmer
                  CachedNetworkImage(
                    imageUrl: _weatherData!.iconAsset,
                    height: 10.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // *** GEÇMİŞ ARATILAN ŞEHİRLER ***
  Widget buildRecentCitiesSheet() {
    return customBlurContainer(
      borderRadius: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Divider(
              endIndent: 30.w,
              indent: 30.w,
              color: AppColors.shadow,
              thickness: 2,
            ),
          ),
          recentWeatherData.isEmpty
              ? SizedBox(
                  height: 20.h,
                  child: Center(
                    child: Text(
                      "Empty",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                )
              : SizedBox(
                  height: 40.h, // ihtiyaca göre ayarlanabilir
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recentWeatherData.length,
                    itemBuilder: (context, index) {
                      final weather = recentWeatherData[index];
                      return ListTile(
                        title: Text(
                          weather.cityName,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        subtitle: Text(
                          weather.description,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Colors.grey.shade700,
                              ),
                        ),
                        trailing: Text(
                          "${weather.temperature}°C",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                          _focusNode.unfocus();
                          _controller.clear();
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: const Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: DetailPage(
                                weather: weather,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
