import 'package:cloud_firestore/cloud_firestore.dart';

import 'cartProductModel.dart';

class OrdersModel {
  String orderId;
  String shippingAddress;
  String paymentMethod;
  String purchasedBY;
  List<CartProductModel> productList = [];
  double orderAmount;
  int itemsCount;
  Timestamp placedOrderAt = Timestamp.now();

  OrdersModel({
    this.itemsCount = 0,
    this.orderId = "",
    this.shippingAddress = "",
    this.paymentMethod = "",
    this.purchasedBY = "",
    this.orderAmount = 0,
    List<CartProductModel>? productList,
    Timestamp? placedOrderAt,
  }) {
    this.placedOrderAt = placedOrderAt ?? Timestamp.now();
    this.productList = productList ?? [];
  }

  Map<String, dynamic> toMap({required List<CartProductModel> cartProductModelList}) {
    List<Map<String, dynamic>> productsListMap = [];
    for (var model in cartProductModelList) {
      final data = model.toMap();
      productsListMap.add(data);
    }
    return {
      'orderId': orderId,
      'itemsCount': itemsCount,
      'orderAmount': orderAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'productList': productsListMap,
      'purchasedBY': purchasedBY,
      'placedOrderAt': placedOrderAt
    };
  }

  factory OrdersModel.fromMap(Map<String, dynamic> map) {
    return OrdersModel(
      orderId: map['orderId'],
      itemsCount: map['itemsCount'],
      orderAmount: map['orderAmount'].toDouble(),
      shippingAddress: map['shippingAddress'],
      paymentMethod: map['paymentMethod'],
      productList: map['productList'] != null ? (map['productList'] as List).map((e) => CartProductModel.fromMap(e as Map<String, dynamic>)).toList() : [],
      purchasedBY: map['purchasedBY'],
      placedOrderAt: map['placedOrderAt'],
    );
  }

  @override
  String toString() {
    return 'OrdersModel('
        'orderId: $orderId, '
        'itemsCount: $itemsCount, '
        'orderAmount : $orderAmount'
        'shippingAddress: "$shippingAddress, '
        ' paymentMethod: "$paymentMethod, '
        'productList: $productList, '
        'placedOrderAt: $placedOrderAt, '
        ')';
  }
}
