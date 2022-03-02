import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:visito_new/data/models/brand.dart';
import 'package:visito_new/data/models/store.dart';
import 'package:visito_new/data/models/visitation.dart';
import 'package:visito_new/data/models/visitation_and_models.dart';
import 'package:visito_new/data/repository/repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<HistoryLoadEvent>(_mapHistoryLoadEventToState);
  }

  Future<void> _mapHistoryLoadEventToState(
    HistoryLoadEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      List<Visitation> visitationList = await Repository().getVisitations();
      List<Future<VisitationAndModels>> visitationAndModelsList = List.empty(growable: true);
      for (var visitation in visitationList){
        visitationAndModelsList.add(getVisitationModels(visitation));
      }
      emit(HistorySucceed(await Future.wait(visitationAndModelsList)));
    } on Exception catch (error, stackTrace){
      Sentry.captureException(error, stackTrace: stackTrace);
      log('$error \n $stackTrace');
      emit(HistoryFailed(error));
    }
  }

  Future<VisitationAndModels> getVisitationModels(Visitation visitation) async {
    Future<Store> storeFuture = Repository().getStore(visitation.storeId!);
    Future<Brand> brandFuture = Repository().getBrand(visitation.brandId!);
    return VisitationAndModels(visitation, await storeFuture, await brandFuture);
  }
}
