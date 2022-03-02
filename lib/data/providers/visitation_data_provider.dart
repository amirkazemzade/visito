import 'package:dio/dio.dart';
import 'package:visito_new/data/models/create_visitation_response.dart';
import 'package:visito_new/data/models/visitation.dart';
import 'package:visito_new/data/providers/providers_local_variables.dart';

class VisitationDataProvider {
  ///* Singleton Code *///
  static VisitationDataProvider? _instance;

  VisitationDataProvider._privateConstructor();

  factory VisitationDataProvider() {
    _instance ??= VisitationDataProvider._privateConstructor();
    return _instance ?? VisitationDataProvider._privateConstructor();
  }

  final _dio = Dio();

  Future<CreateVisitationResponse> sendVisitation(
    String token,
    int userId,
    int brandId,
    int storeId,
    String date,
    double face,
    double sku,
  ) async {
    late CreateVisitationResponse createVisitation;
    try {
      Response response = await _dio.post(baseUrl + '/api/v1/visitation/',
          data: {
            'user': userId,
            'brand': brandId,
            'store': storeId,
            'date': date,
            'face': face,
            'sku': sku,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 201) {
        createVisitation = CreateVisitationResponse.fromJson(response.data);
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
    return createVisitation;
  }

  Future<List<Visitation>> getVisitations(String token) async {
    late List<Visitation> visitationsList;
    try {
      Response response = await _dio.get(
        baseUrl + '/api/v1/visitation/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        visitationsList = (response.data as List)
            .map((data) => Visitation.fromJson(data))
            .toList();
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
    return visitationsList;
  }
}
