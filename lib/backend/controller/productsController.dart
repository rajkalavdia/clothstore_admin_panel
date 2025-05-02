import 'package:clothstore_admin_pannel/backend/provider/productProvider.dart';
import 'package:clothstore_admin_pannel/model/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final int _limit = 5;

  Future<void> uploadProductFirebase(ProductModel productModel) async {
    print("product model in controller : ${productModel.toString()}");
    try {
      await _firebase.collection('products').doc(productModel.productId).set(productModel.toMap());
    } catch (e) {
      return print(" Error of product model Upload In firebase :$e ");
    }
  }

  Future<void> getProductFromFirebase(ProductProvider provider) async {
    print("productsController().getProductFromFirebase() called with provider: $provider");
    if (provider.isLoading || !provider.hashMore) return;
    provider.startLoading();
    try {
      List<ProductModel> productList = <ProductModel>[];

      print("productProvider.startLoading() : ${provider.isLoading}");

      Query<Map<String, dynamic>> query = _firebase.collection('products').limit(_limit);
      print("query : $query");
      if (provider.lastDocument != null) {
        query = query.startAfterDocument(provider.lastDocument!);
        print("query : $query");
      }

      QuerySnapshot<Map<String, dynamic>> productDoc = await query.get();
      print(" productDoc : $productDoc");
      if (productDoc.docs.isNotEmpty) {
        provider.updateLastDocument(productDoc.docs.last);
        print(" productDoc.docs.last : ${productDoc.docs.last}");
        for (var model in productDoc.docs) {
          List<String> productImagesUrlList = <String>[];
          final data = model.data();
          print("data : $data");
          if (data['productImages'] != null) {
            if (data['productImages'] is List) {
              // Explicitly cast each element to String
              productImagesUrlList = List<String>.from((data['productImages'] as List).map((item) => item?.toString() ?? ''));
            } else if (data['productImages'] is String) {
              // If it's a single string for some reason
              productImagesUrlList = [data['productImages']];
            }
          }
          final product = ProductModel.fromMap(data);
          product.productImages = productImagesUrlList;
          productList.add(product);
        }
        print("productList controller : $productList");
        provider.setProductList(productList: productList);
        productList.clear();
        print('product provider list length : ${provider.productModelList.length}');
      } else {
        provider.setHasMore(false);
        print("No documents found");
      }
    } catch (e, s) {
      return print("Error of product model get In firebase: $e, $s");
    }
    provider.stopLoading();
  }
}
