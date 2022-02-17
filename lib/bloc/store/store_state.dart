part of 'store_bloc.dart';

@immutable
abstract class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreSucceed extends StoreState {
  final List<ProductModel> products;
  final List<List<BrandModel>> brands;

  StoreSucceed(this.products, this.brands);
}

class StoreFailed extends StoreState {
  final Exception error;

  StoreFailed(this.error);
}
