/// State cho tạo sản phẩm mới
class ProductCreateState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? productName;
  final double? price;
  final int? stockQuantity;
  final int? categoryId;
  final String? imageUrl;

  const ProductCreateState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.productName,
    this.price,
    this.stockQuantity,
    this.categoryId,
    this.imageUrl,
  });

  ProductCreateState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? productName,
    double? price,
    int? stockQuantity,
    int? categoryId,
    String? imageUrl,
  }) {
    return ProductCreateState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
