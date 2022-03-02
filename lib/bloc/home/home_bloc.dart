import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:visito_new/data/models/store.dart';
import 'package:visito_new/data/repository/repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadStores>(_mapHomeLoadStoresToState);
    on<HomeOnNavigateToStore>(_mapHomeOnNavigateToStoreToState);
  }

  void _mapHomeLoadStoresToState(
      HomeLoadStores event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      List<Store> stores = await Repository().getStores();
      emit(HomeSucceed(stores));
    } on Exception catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      emit(HomeFailed(exception));
    }
  }

  void _mapHomeOnNavigateToStoreToState(
      HomeOnNavigateToStore event, Emitter<HomeState> emit) {
    emit(HomeNavigateToStore(event.store));
  }
}
