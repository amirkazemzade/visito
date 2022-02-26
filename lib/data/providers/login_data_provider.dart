import 'package:dio/dio.dart';
import 'package:visito_new/data/models/access_token.dart';
import 'package:visito_new/data/models/login_model.dart';

import 'providers_local_variables.dart';

class LoginDataProvider {
  ///* Singleton Code *///
  static LoginDataProvider? _instance;

  LoginDataProvider._privateConstructor();

  factory LoginDataProvider() {
    _instance ??= LoginDataProvider._privateConstructor();
    return _instance ?? LoginDataProvider._privateConstructor();
  }

  final _dio = Dio();

  Future<LoginModel> login(String username, String password) async {
    late LoginModel _login;
    try {
      Response _response = await _dio.post(
        baseUrl + '/api-auth/login/',
        data: {
          'username': username,
          'password': password,
        },
      );
      if (_response.statusCode == 200) {
        _login = LoginModel.fromJson(_response.data);
      }
    } on DioError catch (e) {
      var _message = '';
      switch (e.type) {
        case DioErrorType.connectTimeout:
          _message = 'connection timeout}';
          break;
        case DioErrorType.receiveTimeout:
          _message = 'message timeout';
          break;
        case DioErrorType.sendTimeout:
          _message = 'send timeout';
          break;
        case DioErrorType.cancel:
          _message = 'request has been canceled';
          break;
        case DioErrorType.response:
          {
            if (e.response?.statusCode == 404) {
              _message = 'not found: ${e.response?.data}';
            } else if (e.response?.statusCode == 403) {
              _message = 'forbidden: ${e.response?.data}';
            } else if (e.response?.statusCode == 401) {
              _message = 'unauthorized : ${e.response?.data}';
            } else {
              _message = '${e.response?.data}';
            }
          }
          break;
        case DioErrorType.other:
          _message = e.error;
          break;
      }
      throw Exception(_message);
    }
    return _login;
  }

  Future<AccessToken> refreshToken(String refresh) async {
    late AccessToken accessToken;
    try {
      Response response = await Dio().post(
        baseUrl + '/api-auth/login/refresh/',
        data: {'refresh': refresh},
      );
      if (response.statusCode == 200) {
        accessToken = AccessToken.fromJson(response.data);
      }
    } on DioError catch (e) {
      var _message = '';
      switch (e.type) {
        case DioErrorType.connectTimeout:
          _message = 'connection timeout}';
          break;
        case DioErrorType.receiveTimeout:
          _message = 'message timeout';
          break;
        case DioErrorType.sendTimeout:
          _message = 'send timeout';
          break;
        case DioErrorType.cancel:
          _message = 'request has been canceled';
          break;
        case DioErrorType.response:
          {
            if (e.response?.statusCode == 404) {
              _message = 'not found: ${e.response?.data}';
            } else if (e.response?.statusCode == 403) {
              _message = 'forbidden: ${e.response?.data}';
            } else if (e.response?.statusCode == 401) {
              _message = 'unauthorized : ${e.response?.data}';
            } else {
              _message = '${e.response?.data}';
            }
          }
          break;
        case DioErrorType.other:
          _message = e.error;
          break;
      }
      throw Exception(_message);
    }
    return accessToken;
  }
}
