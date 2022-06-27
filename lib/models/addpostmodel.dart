class AddpostModel {

  bool? status;

  AddpostModel({
    this.status,
  });
  AddpostModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}