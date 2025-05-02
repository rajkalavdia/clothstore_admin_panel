class SearchProductsModel {
  final String searchProductImage;
  final String searchProductName;
  final String searchProductPrice;
  late bool isSearchProductFavorite;

  SearchProductsModel({
    required this.searchProductImage,
    required this.searchProductName,
    required this.searchProductPrice,
    required this.isSearchProductFavorite,
  });
}
