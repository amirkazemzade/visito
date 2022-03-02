class Brand {
  int? id;
  String? name;
  double? face;
  double? sku;

  Brand({this.id, this.name, this.face, this.sku});

  Brand.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
