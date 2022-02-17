class AccessToken {
  String? access;

  AccessToken({this.access});

  AccessToken.fromJson(Map<String, dynamic> json) {
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access'] = access;
    return data;
  }
}
