abstract class CityState {}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final List<String> cities;

  CityLoaded(this.cities);
}

class CityError extends CityState {
  final String message;

  CityError(this.message);
}
