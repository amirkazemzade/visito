part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeLoadStores extends HomeEvent {}

class HomeOnNavigateToStore extends HomeEvent {
  final StoreModel store;

  HomeOnNavigateToStore(this.store);
}
