import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:visito_new/data/models/store_model.dart';
import 'package:visito_new/data/repository/repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadStores>(_mapHomeLoadStoresToState);
    on<HomeOnNavigateToStore>(_mapHomeOnNavigateToStoreToState);
  }

  void _mapHomeLoadStoresToState(HomeLoadStores event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      List<StoreModel> stores = await Repository().getShops();
      emit(HomeSucceed(stores));
    } on Exception catch (e){
      emit(HomeFailed(e));
    }
  }

  void _mapHomeOnNavigateToStoreToState(HomeOnNavigateToStore event, Emitter<HomeState> emit) {
    emit(HomeNavigateToStore(event.store));
  }
}
