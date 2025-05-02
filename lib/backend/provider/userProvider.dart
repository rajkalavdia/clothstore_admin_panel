import 'package:clothstore_admin_pannel/model/productModel.dart';
import 'package:clothstore_admin_pannel/model/user/ordersModel.dart';
import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;

  bool _isLoading = false;
  bool _hashMore = true;
  DocumentSnapshot? _lastDocument;

  bool get isLoading => _isLoading;

  bool get hashMore => _hashMore;

  DocumentSnapshot? get lastDocument => _lastDocument;

  List<UserModel> usersList = [];

  List<ProductModel> userFavouritesProducts = [];

  List<OrdersModel> userOrderList = [];

  void setUserOrderList({required List<OrdersModel> orders}) {
    userOrderList = orders;
    notifyListeners();
  }

  void setUserFavouritesProducts({required List<ProductModel> product}) {
    userFavouritesProducts = product;
    notifyListeners();
  }

  void setUsersList({required List<UserModel> userList}) {
    usersList.addAll(userList);
    notifyListeners();
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void updateLastDocument(DocumentSnapshot? doc) {
    _lastDocument = doc;
    notifyListeners();
  }

  void setHasMore(bool value) {
    _hashMore = value;
    notifyListeners();
  }
}
