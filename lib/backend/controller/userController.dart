import 'package:clothstore_admin_pannel/model/productModel.dart';
import 'package:clothstore_admin_pannel/model/user/ordersModel.dart';
import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../provider/userProvider.dart';

class UserController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  List<UserModel> usersList = [];
  List<ProductModel> favouritesProducts = [];
  List<OrdersModel> ordersList = [];
  final int _limit = 5;

  Future<void> getUserFromFirebase({required UserProvider userProvider}) async {
    QuerySnapshot<Map<String, dynamic>> userDoc = await _firebase.collection("users").get();

    for (var models in userDoc.docs) {
      final data = models.data();
      final user = UserModel.fromMap(data);
      usersList.add(user);
    }
    userProvider.setUsersList(userList: usersList);
  }

  Future<void> getFavouritesProducts({required UserProvider userProvider, required int index}) async {
    try {
      for (var products in userProvider.usersList[index].favouriteProductIDs) {
        QuerySnapshot<Map<String, dynamic>> query = await _firebase.collection('products').where('productId', isEqualTo: products).get();
        if (query.docs.isNotEmpty) {
          for (var model in query.docs) {
            Map<String, dynamic> data = model.data();
            ProductModel productModel = ProductModel.fromMap(data);
            favouritesProducts.add(productModel);
          }
        }
        userProvider.setUserFavouritesProducts(product: favouritesProducts);

        print('controller ma favourites products ni list : ${favouritesProducts}');
        print('controller ma favourites products ni list aa provider mate : ${userProvider.userFavouritesProducts}');
      }
    } catch (e) {
      return print("Error in get Favourites Products method in controller : $e");
    }
  }

  Future<void> getOrdersList({required UserProvider userProvider, required int index}) async {
    for (var orders in userProvider.usersList[index].ordersList) {
      QuerySnapshot<Map<String, dynamic>> query = await _firebase.collection('orders').where('orderId', isEqualTo: orders).get();

      if (query.docs.isNotEmpty) {
        for (var model in query.docs) {
          Map<String, dynamic> data = model.data();
          OrdersModel ordersModel = OrdersModel.fromMap(data);
          ordersList.add(ordersModel);
        }
      }
      userProvider.setUserOrderList(orders: ordersList);
    }
  }
}
