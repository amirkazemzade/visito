part of 'store_bloc.dart';

@immutable
abstract class StoreEvent {}

class StoreLoadEvent extends StoreEvent {
  final int storeId;

  StoreLoadEvent(this.storeId);
}

class StoreUpdateEvent extends StoreEvent {
  final List<Product> products;
  final List<List<BrandAndStates>> brands;

  StoreUpdateEvent(this.products, this.brands);
}

class StoreSendVisitationEvent extends StoreEvent {
  final int storeId;
  final List<List<BrandAndStates>> brands;
  final List<Product> products;

  StoreSendVisitationEvent(this.brands, this.products, this.storeId);
}
