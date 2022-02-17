part of 'store_bloc.dart';

@immutable
abstract class StoreEvent {}

class StoreLoadEvent extends StoreEvent {
  final int storeId;

  StoreLoadEvent(this.storeId);
}
