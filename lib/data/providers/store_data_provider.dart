import 'package:dio/dio.dart';
import 'package:visito_new/data/models/store.dart';

import 'providers_local_variables.dart';

class StoreDataProvider {
  ///* Singleton Code *///
  static StoreDataProvider? _instance;
  final Dio _dio = Dio();

  StoreDataProvider._privateConstructor();

  factory StoreDataProvider() {
    _instance ??= StoreDataProvider._privateConstructor();
    return _instance ?? StoreDataProvider._privateConstructor();
  }

  Future<List<Store>> getAllStores(String token) async {
    late List<Store> stores;
    try {
      Response response = await _dio.get(
        baseUrl + '/api/v1/store/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        stores = (response.data as List).map((s) => Store.fromJson(s)).toList();
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
    return stores;
  }

  Future<Store> getStore(int storeId, String token) async {
    late Store store;
    try {
      Response response = await _dio.get(
        baseUrl + '/api/v1/store/$storeId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        store = Store.fromJson(response.data);
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
          _message = e.error.toString();
          break;
      }
      throw Exception(_message);
    }
    return store;
  }
}
