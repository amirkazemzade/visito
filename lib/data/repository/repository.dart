import 'package:visito_new/data/models/brand_model.dart';
import 'package:visito_new/data/models/login_model.dart';
import 'package:visito_new/data/models/product_model.dart';
import 'package:visito_new/data/models/store_model.dart';
import 'package:visito_new/data/providers/all_shops_data_provider.dart';
import 'package:visito_new/data/providers/brand_data_provider.dart';
import 'package:visito_new/data/providers/login_data_provider.dart';
import 'package:visito_new/data/providers/product_data_provider.dart';

class Repository {
  static Repository? _instance;

  String _accessKey = '';

  Repository._privateConstructor();

  factory Repository() {
    _instance ??= Repository._privateConstructor();
    return _instance ?? Repository._privateConstructor();
  }

  Future<LoginModel> login(String username, String password) async {
    LoginModel login = await LoginDataProvider().login(username, password);
    _accessKey = login.access!;
    return login;
  }

  Future<List<StoreModel>> getShops() {
    return AllShopsDataProvider().getAllShops(_accessKey);
  }

  Future<List<ProductModel>> getProducts(int storeId){
    return ProductDataProvider().getProducts(storeId, _accessKey);
  }

  Future<List<BrandModel>> getBrands(int productId){
    return BrandDataProvider().getBrands(productId, _accessKey);
  }
}
