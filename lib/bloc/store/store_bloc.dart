import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:visito_new/data/models/brand_model.dart';
import 'package:visito_new/data/models/product_model.dart';
import 'package:visito_new/data/repository/repository.dart';

part 'store_event.dart';

part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitial()) {
    on<StoreLoadEvent>(_mapStoreLoadEventToState);
  }

  Future<void> _mapStoreLoadEventToState(event, emit) async {
    emit(StoreLoading());
    try {
      List<ProductModel> products =
          await Repository().getProducts(event.storeId);
      List<Future<List<BrandModel>>> brandsFutures = List.empty(growable: true);
      for (var product in products) {
        brandsFutures.add(Repository().getBrands(product.id!));
      }
      var brands = await Future.wait(brandsFutures);
      emit(StoreSucceed(products, brands));
    } on Exception catch (e) {
      emit(StoreFailed(e));
    }
  }
}
