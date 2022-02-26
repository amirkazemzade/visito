part of 'store_bloc.dart';

@immutable
abstract class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreSucceed extends StoreState {
  final List<ProductModel> products;
  final List<List<BrandAndStates>> brands;

  StoreSucceed(this.products, this.brands);
}

class StoreSendDataSucceed extends StoreState {
  final List<ProductModel> products;
  final List<List<BrandAndStates>> brands;

  StoreSendDataSucceed(this.products, this.brands);
}

class StoreFailed extends StoreState {
  final Exception error;

  StoreFailed(this.error);
}
