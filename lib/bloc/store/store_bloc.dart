import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:visito_new/data/models/brand_and_states.dart';
import 'package:visito_new/data/models/brand_model.dart';
import 'package:visito_new/data/models/product_model.dart';
import 'package:visito_new/data/repository/repository.dart';

part 'store_event.dart';

part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitial()) {
    on<StoreLoadEvent>(_mapStoreLoadEventToState);
    on<StoreUpdateEvent>(_mapStoreUpdateEventToState);
    on<StoreSendVisitationEvent>(_mapStoreSendVisitationEventToState);
  }

  Future<void> _mapStoreLoadEventToState(
    StoreLoadEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      List<ProductModel> products =
          await Repository().getProducts(event.storeId);
      List<Future<List<BrandAndStates>>> brandsFutures =
          List.empty(growable: true);
      for (var product in products) {
        brandsFutures.add(getBrands(product.id!));
      }
      var brands = await Future.wait(brandsFutures);
      emit(StoreSucceed(products, brands));
    } on Exception catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      emit(StoreFailed(exception));
    }
  }

  Future<List<BrandAndStates>> getBrands(int productId) async {
    var brands = await Repository().getBrands(productId);
    List<BrandAndStates> brandsWithState = List.empty(growable: true);
    for (var brand in brands) {
      brandsWithState.add(BrandAndStates(brand: brand));
    }
    return brandsWithState;
  }

  Future<void> _mapStoreUpdateEventToState(
    StoreUpdateEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreSucceed(event.products, event.brands));
  }

  Future<void> _mapStoreSendVisitationEventToState(
    StoreSendVisitationEvent event,
    Emitter<StoreState> emit,
  ) async {
    List<List<Future<BrandAndStates>>> newAllBrands =
        List.empty(growable: true);
    for (var brandList in event.brands) {
      List<Future<BrandAndStates>> newBrands = List.empty(
        growable: true,
      );
      for (var brandAndState in brandList) {
        newBrands.add(
          sendVisitation(
            brandAndState.brand,
            event.storeId,
          ),
        );
      }
      newAllBrands.add(newBrands);
    }
    List<List<BrandAndStates>> brands = List.empty(growable: true);
    for (var brandList in newAllBrands) {
      brands.add(await Future.wait(brandList));
    }
    emit(StoreSucceed(event.products, brands));
  }

  Future<BrandAndStates> sendVisitation(BrandModel brand, int storeId) async {
    if (brand.face == null && brand.sku == null) {
      return BrandAndStates(brand: brand, state: 'warning');
    } else if (brand.face == null) {
      return BrandAndStates(brand: brand, state: 'error', faceError: true);
    } else if (brand.sku == null) {
      return BrandAndStates(brand: brand, state: 'error', skuError: true);
    }
    try {
      await Repository().sendVisitation(
        brand.id!,
        storeId,
        brand.face!,
        brand.sku!,
      );
      return BrandAndStates(brand: brand, state: 'succeed');
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      log(e.toString(), stackTrace: stackTrace);
      return BrandAndStates(brand: brand, state: 'error');
    }
  }
}
