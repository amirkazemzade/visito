part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  final String username;
  final String password;

  const LoginEvent(this.username, this.password);
}

class OnLogin extends LoginEvent {
  const OnLogin(username, password) : super(username, password);
}
