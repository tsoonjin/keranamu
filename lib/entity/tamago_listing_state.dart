import 'package:keranamu/repository/card_repository.dart';

abstract class TamagoListingState {}

class InitTamagoListingState extends TamagoListingState {}

class LoadingTamagoListingState extends TamagoListingState {}

class ErrorTamagoListingState extends TamagoListingState {
  final String message;
  ErrorTamagoListingState(this.message);
}

class ResponseTamagoListingState extends TamagoListingState {
  final List<Tamago> tamagos;
  ResponseTamagoListingState(this.tamagos);
}
