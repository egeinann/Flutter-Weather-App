import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_event.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_state.dart';
import 'package:weather_app/services/city_service.dart';

class CityCubit extends Bloc<CityEvent, CityState> {
  final CityService _cityService;
  List<String> _allCities = [];
  List<String> get allCities => _allCities;
  bool _hasLoaded = false;

  CityCubit(this._cityService) : super(CityInitial()) {
    on<CityTextChanged>(_onCityTextChanged);
    _loadAllCities();
  }

  // *** TÜM ŞEHİRLERİN LİSTESİNİ YÜKLE HAZIRLA ***
  Future<void> _loadAllCities() async {
    if (_hasLoaded) return;

    try {
      final cities = await _cityService.fetchCityList();
      _allCities = cities.toSet().toList(); // tekrar edenleri kaldır
      _hasLoaded = true;
      emit(CityLoaded([])); // boş liste emit et (hazır olduğunu belirtmek için)
    } catch (e) {
      print("Şehirler yüklenirken hata: $e");
      emit(CityError("Şehir listesi yüklenemedi."));
    }
  }

  // *** TYPEAHEADFIELD DEĞİŞİMİ İÇİN CANLI OLARAK TEXTCHANGED ***
  Future<void> _onCityTextChanged(
    CityTextChanged event,
    Emitter<CityState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(CityLoaded([]));
      return;
    }

    if (_allCities.isEmpty) {
      emit(CityError("Şehir listesi henüz yüklenmedi."));
      return;
    }

    try {
      final filtered = _allCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .take(10) // ✅ sadece ilk 10 eşleşeni döndür
          .toList();

      emit(CityLoaded(filtered));
    } catch (e) {
      emit(CityError('Filtreleme sırasında hata oluştu'));
    }
  }
}
