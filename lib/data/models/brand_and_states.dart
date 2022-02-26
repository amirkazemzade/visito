import 'package:visito_new/data/models/brand_model.dart';

class BrandAndStates {
  BrandModel brand;
  String state;
  bool faceError;
  bool skuError;

  BrandAndStates({
    required this.brand,
    this.state = 'normal',
    this.faceError = false,
    this.skuError = false,
  });
}
