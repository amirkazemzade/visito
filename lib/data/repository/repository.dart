import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:visito_new/data/models/brand.dart';
import 'package:visito_new/data/models/create_visitation_response.dart';
import 'package:visito_new/data/models/login.dart';
import 'package:visito_new/data/models/product.dart';
import 'package:visito_new/data/models/store.dart';
import 'package:visito_new/data/models/visitation.dart';
import 'package:visito_new/data/providers/store_data_provider.dart';
import 'package:visito_new/data/providers/brand_data_provider.dart';
import 'package:visito_new/data/providers/login_data_provider.dart';
import 'package:visito_new/data/providers/product_data_provider.dart';
import 'package:visito_new/data/providers/visitation_data_provider.dart';

class Repository {
  static Repository? _instance;

  Repository._privateConstructor();

  String _accessKey = '';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory Repository() {
    _instance ??= Repository._privateConstructor();
    return _instance ?? Repository._privateConstructor();
  }

  Future<Login> login(String username, String password) async {
    try {
      Login login = await LoginDataProvider().login(username, password);
      _storage.write(key: 'refresh token', value: login.refresh);
      _storage.write(key: 'user id', value: login.userId.toString());
      _accessKey = login.access!;
      return login;
    } catch(e){
      rethrow;
    }
  }

  Future<List<Store>> getStores() {
    return StoreDataProvider().getAllStores(_accessKey);
  }

  Future<List<Product>> getProducts(int storeId){
    return ProductDataProvider().getProducts(storeId, _accessKey);
  }

  Future<List<Brand>> getBrands(int productId){
    return BrandDataProvider().getAllBrands(productId, _accessKey);
  }

  Future<CreateVisitationResponse> sendVisitation(int brandId, int storeId, double face, double sku,) async{
    String userIdString = await _storage.read(key: 'user id')?? '';
    int userId = int.tryParse(userIdString)?? -1;
    String date = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    return VisitationDataProvider().sendVisitation(_accessKey, userId, brandId, storeId, date, face, sku);
  }

  Future<List<Visitation>> getVisitations() {
    return VisitationDataProvider().getVisitations(_accessKey);
  }

  Future<Store> getStore(int storeId) {
    return StoreDataProvider().getStore(storeId, _accessKey);
  }

  Future<Brand> getBrand(int brandId) {
    return BrandDataProvider().getBrand(brandId, _accessKey);
  }
}
