import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_event.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_state.dart';
import 'package:weather_app/services/city_service.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityService _cityService;
  List<String> _allCities = [];

  CityBloc(this._cityService) : super(CityInitial()) {
    on<CityTextChanged>(_onCityTextChanged);
    _loadAllCities();
  }

  void _loadAllCities() async {
    try {
      _allCities = await _cityService.fetchCityList();
    } catch (e) {
      // hata durumunda logla ama state değiştirme (ilk yüklenirken hata vermesin)
      print("Şehirler yüklenirken hata: $e");
    }
  }

  void _onCityTextChanged(
    CityTextChanged event,
    Emitter<CityState> emit,
  ) async {
    emit(CityLoading());

    try {
      final filtered = _allCities
          .where((city) => city.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(CityLoaded(filtered));
    } catch (_) {
      emit(CityError('Filtreleme sırasında hata oluştu'));
    }
  }
}