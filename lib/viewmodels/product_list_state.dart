import '../models/product.dart';
import '../models/category.dart' as cat;

/// State cho product list screen
class ProductListState {
  final bool isLoading;
  final List<Product> products;
  final List<cat.Category> categories;
  final List<String> categoryNames;
  final int selectedCategoryIndex;
  final String? error;

  const ProductListState({
    this.isLoading = true,
    this.products = const [],
    this.categories = const [],
    this.categoryNames = const ['All'],
    this.selectedCategoryIndex = 0,
    this.error,
  });

  /// Lọc sản phẩm theo category đã chọn
  List<Product> get filteredProducts {
    if (selectedCategoryIndex == 0) return products; // "All"
    final selectedCategoryName = categoryNames[selectedCategoryIndex];
    return products
        .where((p) => p.categoryName == selectedCategoryName)
        .toList();
  }

  ProductListState copyWith({
    bool? isLoading,
    List<Product>? products,
    List<cat.Category>? categories,
    List<String>? categoryNames,
    int? selectedCategoryIndex,
    String? error,
  }) {
    return ProductListState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      categoryNames: categoryNames ?? this.categoryNames,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      error: error ?? this.error,
    );
  }
}
