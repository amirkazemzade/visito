part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSucceed extends LoginState {
  final LoginModel login;

  LoginSucceed(this.login);
}

class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}
