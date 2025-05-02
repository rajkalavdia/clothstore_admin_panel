class ProductModel {
  String productId;
  List<String> productImages = [];
  String brandName;
  String productDescription;
  List<String> productSize = [];
  List<String> productColor = [];
  String productCategory;
  double productPrice;
  bool productEnabled;

  ProductModel({
    this.productId = "",
    this.brandName = "",
    this.productDescription = "",
    this.productCategory = "",
    this.productPrice = 0,
    this.productEnabled = true,
    List<String>? productSize,
    List<String>? productImages,
    List<String>? productColor,
  }) {
    this.productSize = productSize ?? [];
    this.productColor = productColor ?? [];
    this.productImages = productImages ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productImages': productImages,
      'brandName': brandName,
      'productDescription': productDescription,
      'productSize': productSize,
      'productColor': productColor,
      'productCategory': productCategory,
      'productPrice': productPrice,
      'productEnabled': productEnabled,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] ?? '',
      productImages: map['productImages'] != null ? List<String>.from(map['productImages']) : [],
      brandName: map['brandName'] ?? '',
      productDescription: map['productDescription'] ?? '',
      productSize: map['productSize'] != null ? List<String>.from(map['productSize']) : [],
      productColor: map['productColor'] != null ? List<String>.from(map['productColor']) : [],
      productCategory: map['productCategory'] ?? '',
      productPrice: (map['productPrice'] ?? 0).toDouble(),
      productEnabled: map['productEnabled'],
    );
  }

  @override
  String toString() {
    return 'ProductModel('
        'productId: $productId, '
        'productImages: $productImages, '
        'brandName: $brandName, '
        'productDescription: $productDescription, '
        'productSize: $productSize, '
        'productColor: $productColor, '
        'productCategory: $productCategory, '
        'productPrice: $productPrice, '
        'productEnabled: $productEnabled'
        ')';
  }
}
