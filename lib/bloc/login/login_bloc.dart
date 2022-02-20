import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:visito_new/data/models/login_model.dart';
import 'package:visito_new/data/repository/repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>(_mapOnLoginEventToState);
  }

  void _mapOnLoginEventToState(
      LoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginInProgress());
    try {
      final login = await Repository().login(event.username, event.password);
      _storage.write(key: 'refresh token', value: login.refresh);
      emit(LoginSucceed(login));
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      emit(LoginFailed(exception.toString()));
    }
  }
}
