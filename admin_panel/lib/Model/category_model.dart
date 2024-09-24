class CategoryModel {
  String? id;
  String name;
  String description;
  String imageURL;
  bool isactive;
  int createdAt;

  CategoryModel(
      {this.id,
      required this.name,
      required this.description,
      required this.imageURL,
      required this.isactive,
      required this.createdAt});

  Map<String, dynamic> tojson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "imageUrl": imageURL,
      "createdAt": createdAt,
      "isactive": isactive
    };
  }

  factory CategoryModel.fromjson(dynamic json) {
    return CategoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imageURL: json["imageURL"],
        isactive: json["isactive"],
        createdAt: json["createdAt"]);
  }
}
