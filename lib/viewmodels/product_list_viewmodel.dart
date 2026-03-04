import 'package:flutter/foundation.dart';
import 'product_list_state.dart';
import '../repositories/product_repo.dart';
import '../services/category_service.dart';

/// ViewModel quản lý danh sách sản phẩm
class ProductListViewModel extends ChangeNotifier {
  ProductListState _state = const ProductListState();

  ProductListState get state => _state;

  /// Load products và categories từ API
  Future<void> loadData() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      // Load đồng thời products và categories
      final results = await Future.wait([
        ProductRepo.getProducts(pageSize: 20),
        CategoryService.getCategories(),
      ]);

      final products = results[0] as dynamic;
      final categories = results[1] as dynamic;

      _state = _state.copyWith(
        isLoading: false,
        products: products,
        categories: categories,
        categoryNames: [
          'All',
          ...categories.map((c) => c.categoryName),
        ],
        error: null,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Failed to load data: $e',
      );
    }
    notifyListeners();
  }

  /// Chọn category để filter
  void selectCategory(int index) {
    _state = _state.copyWith(selectedCategoryIndex: index);
    notifyListeners();
  }
}
