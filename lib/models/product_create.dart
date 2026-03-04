/// DTO tạo sản phẩm mới - gửi lên BE Tree API
class ProductCreate {
  final String productName;
  final double price;
  final int? stockQuantity;
  final int categoryId;
  final String? imageUrl;

  ProductCreate({
    required this.productName,
    required this.price,
    this.stockQuantity,
    required this.categoryId,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'price': price,
      'stockQuantity': stockQuantity,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
    };
  }
}
