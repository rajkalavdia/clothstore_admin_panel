import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../model/productModel.dart';

class ProductProvider extends ChangeNotifier {
  ProductModel? _productModel;

  bool _isLoading = false;
  bool _hashMore = true;
  bool _isEdit = false;
  DocumentSnapshot? _lastDocument;

  ProductModel? get productModel => _productModel;

  bool get isLoading => _isLoading;

  bool get hashMore => _hashMore;

  bool get isEdit => _isEdit;

  DocumentSnapshot? get lastDocument => _lastDocument;

  List<ProductModel> productModelList = [];

  void setProductModel(ProductModel productDetail) {
    if (_productModel != productDetail) {
      _productModel = productDetail;
      notifyListeners();
    }
  }

  void setProductList({required List<ProductModel> productList}) {
    productModelList.addAll(productList);
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

  void startEdit() {
    _isEdit = true;
    notifyListeners();
  }

  void stopEdit() {
    _isEdit = false;
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

  void resetPagination() {
    _lastDocument = null;
    _hashMore = true;
    _isLoading = false;
    productModelList.clear(); // optional if you do it elsewhere
  }
}
