class CreateVisitationResponse {
  String? type;
  String? detail;

  CreateVisitationResponse({this.type, this.detail});

  CreateVisitationResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['detail'] = detail;
    return data;
  }
}
