import 'package:dio/dio.dart';
import 'package:visito_new/data/models/store_model.dart';

import 'providers_local_variables.dart';

class AllShopsDataProvider {
  ///* Singleton Code *///
  static AllShopsDataProvider? _instance;
  final Dio _dio = Dio();

  AllShopsDataProvider._privateConstructor();

  factory AllShopsDataProvider() {
    _instance ??= AllShopsDataProvider._privateConstructor();
    return _instance ?? AllShopsDataProvider._privateConstructor();
  }

  Future<List<StoreModel>> getAllShops(String token) async {
    late List<StoreModel> stores;
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
        stores =
            (response.data as List).map((s) => StoreModel.fromJson(s)).toList();
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
}
