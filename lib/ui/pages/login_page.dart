import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visito_new/bloc/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _usernameValid = true;
  bool _passwordValid = true;
  LoginBloc loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.person,
                    size: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _usernameTextController,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        setState(() {
                          _usernameValid = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      border: const OutlineInputBorder(),
                      errorText: _usernameValid ? null : 'required',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordTextController,
                    onFieldSubmitted: (text) => _onLogin(),
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        setState(() {
                          _passwordValid = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      errorText: _passwordValid ? null : 'required',
                    ),
                    obscureText: _isPasswordHidden,
                  ),
                ),
                BlocConsumer(
                  bloc: loginBloc,
                  builder: (context, state) {
                    if (state is LoginInitial) {
                      return Container();
                    } else if (state is LoginInProgress) {
                      return const LinearProgressIndicator();
                    } else if (state is LoginFailed) {
                      String error = state.error;
                      if (error.contains('unauthorized')) {
                        log(error);
                        return const Text(
                          'The username or password is incorrect',
                          style: TextStyle(color: Colors.red),
                        );
                      } else {
                        log(error);
                        return const Text(
                          'Something went wrong!',
                          style: TextStyle(color: Colors.red),
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                  listener: (context, state) {
                    if (state is LoginSucceed) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/navigationBarWrapper', (route) => false);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _onLogin(),
                    child: const Text('Login'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    setState(() {
      if (_usernameTextController.text.isEmpty ||
          _passwordTextController.text.isEmpty) {
        if (_usernameTextController.text.isEmpty) {
          _usernameValid = false;
        }
        if (_passwordTextController.text.isEmpty) {
          _passwordValid = false;
        }
        return;
      }
      loginBloc.add(
        OnLogin(
          _usernameTextController.text,
          _passwordTextController.text,
        ),
      );
    });
  }
}
