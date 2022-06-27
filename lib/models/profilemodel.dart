class ProfileModel {

  bool? Status;
  String? name;
  String? email;
  String? dept;
  String? phone;
  String? hsc;
  String? sslc;
  String? cgpa;
  String? image;
  String? roll;

  ProfileModel({
    this.Status,
    this.name,
    this.email,
    this.dept,
    this.phone,
    this.hsc,
    this.sslc,
    this.cgpa,
    this.image,
    this.roll,
  });
  ProfileModel.fromJson(Map<String, dynamic> json) {
    Status = json['Status'];
    name = json['name']?.toString();
    email = json['email']?.toString();
    dept = json['dept']?.toString();
    phone = json['phone']?.toString();
    hsc = json['hsc']?.toString();
    sslc = json['sslc']?.toString();
    cgpa = json['cgpa']?.toString();
    image = json['image']?.toString();
    roll = json['roll']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Status'] = Status;
    data['name'] = name;
    data['email'] = email;
    data['dept'] = dept;
    data['phone'] = phone;
    data['hsc'] = hsc;
    data['sslc'] = sslc;
    data['cgpa'] = cgpa;
    data['image'] = image;
    data['roll'] = roll;
    return data;
  }
}