part of 'history_bloc.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySucceed extends HistoryState {
  final List<VisitationAndModels> visitationList;

  HistorySucceed(this.visitationList);
}

class HistoryFailed extends HistoryState {
  final Exception error;

  HistoryFailed(this.error);
}
