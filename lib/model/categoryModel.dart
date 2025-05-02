class CategoryModel {
  String categoryUid;
  String categoryName;
  String categoryImageUrl;

  CategoryModel({
    this.categoryUid = "",
    this.categoryName = "",
    this.categoryImageUrl = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryUid': categoryUid,
      'categoryName': categoryName,
      'categoryUrl': categoryImageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryUid: map['categoryUid'] ?? "",
      categoryName: map['categoryName'] ?? "",
      categoryImageUrl: map['categoryUrl'] ?? "",
    );
  }

  @override
  String toString() {
    return 'ProductModel('
        'categoryUid: $categoryUid, '
        'categoryImageUrl: $categoryImageUrl, '
        'categoryName: $categoryName, '
        ')';
  }
}
