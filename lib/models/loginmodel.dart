class LoginModel {
/*
{
  "id": "2",
  "Status": true,
  "roll": "0"
}
*/

String? email;
bool? Status;
String? roll;

LoginModel({
  this.email,
  this.Status,
  this.roll,
});
LoginModel.fromJson(Map<String, dynamic> json) {
  email = json['email']?.toString();
Status = json['Status'];
roll = json['roll']?.toString();
}
Map<String, dynamic> toJson() {
  final data = <String, dynamic>{};
  data['email'] = email;
  data['Status'] = Status;
  data['roll'] = roll;
  return data;
}
}