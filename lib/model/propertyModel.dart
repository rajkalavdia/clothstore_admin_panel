import 'package:clothstore_admin_pannel/model/categoryModel.dart';

class PropertyModel {
  Map<String, CategoryModel> categories = <String, CategoryModel>{};

  PropertyModel({Map<String, CategoryModel>? categories}) {
    this.categories = categories ?? this.categories;
  }

  Map<String, dynamic> toMap() {
    return {"categories": categories.map((key, value) => MapEntry(key, value.toMap()))};
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(categories: map['categories']);
  }
}
