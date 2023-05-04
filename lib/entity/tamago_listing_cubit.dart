import 'package:keranamu/entity/tamago_listing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keranamu/repository/card_repository.dart';

class TamagoListingCubit extends Cubit<TamagoListingState> {
  final TamagoRepository _repository;
  TamagoListingCubit(this._repository) : super(InitTamagoListingState());

  Future<void> fetchTamagoListing() async {
    try {
      emit(LoadingTamagoListingState());
      final response = await _repository.getTamagoPage();
      emit(ResponseTamagoListingState(response.tamagoListing));
    } catch (e) {
      emit(ErrorTamagoListingState(e.toString()));
    }
  }
}
