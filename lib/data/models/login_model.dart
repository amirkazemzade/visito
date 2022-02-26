class LoginModel {
  String? refresh;
  String? access;
  int? userId;

  LoginModel({this.refresh, this.access});

  LoginModel.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
    userId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refresh'] = refresh;
    data['access'] = access;
    data['id'] = userId;
    return data;
  }
}
