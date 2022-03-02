class Login {
  String? refresh;
  String? access;
  int? userId;

  Login({this.refresh, this.access});

  Login.fromJson(Map<String, dynamic> json) {
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
