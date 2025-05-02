import 'package:clothstore_admin_pannel/model/categoryModel.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryModel? categoryModel;

  bool _editCategory = false;

  bool get editCategory => _editCategory;

  List<CategoryModel> categoryList = [];

  void setCategoriesList({required List<CategoryModel> categoryList}) {
    this.categoryList = categoryList;
    print("Category list set with ${categoryList.length} items");
    notifyListeners();
  }

  void startEdit() {
    _editCategory = true;
    notifyListeners();
  }

  void stopEdit() {
    _editCategory = false;
    notifyListeners();
  }
}
