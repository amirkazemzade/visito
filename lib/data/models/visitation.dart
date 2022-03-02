class Visitation {
  int? id;
  String? date;
  double? face;
  double? sku;
  int? userId;
  int? brandId;
  int? storeId;

  Visitation({
    this.id,
    this.date,
    this.face,
    this.sku,
    this.userId,
    this.brandId,
    this.storeId,
  });

  Visitation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    face = json['face'];
    sku = json['sku'];
    userId = json['user'];
    brandId = json['brand'];
    storeId = json['store'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['face'] = face;
    data['sku'] = sku;
    data['user'] = userId;
    data['brand'] = brandId;
    data['store'] = storeId;
    return data;
  }
}
