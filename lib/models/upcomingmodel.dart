class UpcomimgModel {


  String? id;
  String? name;
  String? image;
  String? link;
  String? description;
  String? dept;

  UpcomimgModel({
    this.id,
    this.name,
    this.image,
    this.link,
    this.description,
    this.dept,
  });
  UpcomimgModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    image = json['image']?.toString();
    link = json['link']?.toString();
    description = json['description']?.toString();
    dept = json['dept']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['link'] = link;
    data['description'] = description;
    data['dept'] = dept;
    return data;
  }
}