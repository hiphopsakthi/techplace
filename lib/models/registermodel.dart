class RegisterModel {
  bool? status;
  String? message;

  RegisterModel({
    this.status,
    this.message,
  });
  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}