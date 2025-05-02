

class CartProductModel {
  String? cartProductId;
  String cartProductImage = "";
  String cartProductName = "";
  String cartProductSize = "";
  String cartProductColor = "";
  int cartProductQuantity = 0;
  double cartProductPrice = 0;

  CartProductModel({
    this.cartProductId,
    this.cartProductImage = "",
    this.cartProductName = "",
    this.cartProductSize = "",
    this.cartProductColor = "",
    this.cartProductQuantity = 0,
    this.cartProductPrice = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'cartProductId': cartProductId,
      'cartProductImage': cartProductImage,
      'cartProductName': cartProductName,
      'cartProductSize': cartProductSize,
      'cartProductColor': cartProductColor,
      'cartProductQuantity': cartProductQuantity,
      'cartProductPrice': cartProductPrice,
    };
  }

  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      cartProductId: map['cartProductId'],
      cartProductImage: map['cartProductImage'],
      cartProductName: map['cartProductName'],
      cartProductSize: map['cartProductSize'],
      cartProductColor: map['cartProductColor'],
      cartProductQuantity: map['cartProductQuantity'],
      cartProductPrice: map['cartProductPrice'],
    );
  }

  @override
  String toString() {
    return 'CartProductModel(cartProductId: $cartProductId, '
        'cartProductImage: "$cartProductImage", '
        'cartProductName: "$cartProductName", '
        'cartProductSize: "$cartProductSize", '
        'cartProductColor: $cartProductColor, '
        'cartProductQuantity: $cartProductQuantity, '
        'cartProductPrice: $cartProductPrice,'
        ')';
  }
}
