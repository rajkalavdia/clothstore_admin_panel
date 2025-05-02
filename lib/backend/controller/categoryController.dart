import 'package:clothstore_admin_pannel/model/categoryModel.dart';
import 'package:clothstore_admin_pannel/model/propertyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../provider/categoryProvider.dart';

class CategoryController {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> setCategoryFirebase(CategoryModel categoryModel) async {
    try {
      await _firebase.collection('admin').doc("property").update({'categories.${categoryModel.categoryUid}': categoryModel.toMap()});
    } catch (e, s) {
      return print(" Error of category model Upload In firebase :$e , $s ");
    }
  }

  Future<void> categoryFirebase(PropertyModel propertyModel) async {
    try {
      await _firebase.collection('admin').doc("property").set(propertyModel.toMap(), SetOptions(merge: true));
    } catch (e, s) {
      return print(" Error of category model Upload In firebase :$e , $s ");
    }
  }

  Future<void> getCategoryFirebase(CategoryProvider categoryProvider) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> query = await _firebase.collection('admin').doc('property').get();
      List<CategoryModel> categoriesList = [];
      // PropertyModel property = PropertyModel.fromMap(query.data()?["categories"] as Map<String,dynamic>);

      final rawCategories = Map<String, dynamic>.from(query.data()?['categories']);

      Map<String, CategoryModel> categoriesMap = rawCategories.map(
        (key, value) => MapEntry(
          key,
          CategoryModel.fromMap(Map<String, dynamic>.from(value)),
        ),
      );
      PropertyModel property = PropertyModel(categories: categoriesMap);

      categoriesList = property.categories.values.toList();

      print("categoriesList : $categoriesList");

      categoryProvider.setCategoriesList(categoryList: categoriesList);

      print("code aaya sudhi pochi gyo.");
    } catch (e) {
      return print("Error in get Categories Form firebase : $e");
    }
  }
}
