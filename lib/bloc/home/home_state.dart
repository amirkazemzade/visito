part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSucceed extends HomeState {
  final List<Store> stores;

  HomeSucceed(this.stores);
}

class HomeFailed extends HomeState {
  final Exception error;

  HomeFailed(this.error);
}

class HomeNavigateToStore extends HomeState{
  final Store store;

  HomeNavigateToStore(this.store);
}
