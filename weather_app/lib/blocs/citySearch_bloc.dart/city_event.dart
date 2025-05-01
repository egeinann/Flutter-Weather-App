abstract class CityEvent {}

class CityTextChanged extends CityEvent {
  final String query;

  CityTextChanged(this.query);
}
