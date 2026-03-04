/// Model sản phẩm - khớp với ProductDetailResponse của BE Tree API
class Product {
  final int id;
  final String productName;
  final double price;
  final int? stockQuantity;
  final DateTime? createdAt;
  final int categoryId;
  final String categoryName;
  final String? imageUrl;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    this.stockQuantity,
    this.createdAt,
    required this.categoryId,
    required this.categoryName,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stockQuantity'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

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
