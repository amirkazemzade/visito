import 'package:dio/dio.dart';
import 'package:visito_new/data/models/brand_model.dart';
import 'package:visito_new/data/providers/providers_local_variables.dart';

class BrandDataProvider {
  ///* Singleton Code *///
  static BrandDataProvider? _instance;

  BrandDataProvider._privateConstructor();

  factory BrandDataProvider() {
    _instance ??= BrandDataProvider._privateConstructor();
    return _instance ?? BrandDataProvider._privateConstructor();
  }

  final Dio _dio = Dio();

  Future<List<BrandModel>> getBrands(int productId, String token) async {
    late List<BrandModel> brands;
    try {
      Response response = await _dio.get(
        baseUrl + '/api/v1/brand/',
        queryParameters: {
          'product_id': productId
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      brands =
          (response.data as List).map((d) => BrandModel.fromJson(d)).toList();
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
    return brands;
  }
}
