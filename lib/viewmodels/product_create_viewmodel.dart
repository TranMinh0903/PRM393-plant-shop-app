import 'package:flutter/foundation.dart';
import 'product_create_state.dart';
import '../models/product_create.dart';
import '../repositories/product_repo.dart';

/// ViewModel quản lý tạo sản phẩm mới
class ProductCreateViewModel extends ChangeNotifier {
  ProductCreateState _state = const ProductCreateState();

  ProductCreateState get state => _state;

  /// Cập nhật tên sản phẩm
  void setProductName(String name) {
    _state = _state.copyWith(productName: name);
  }

  /// Cập nhật giá
  void setPrice(double price) {
    _state = _state.copyWith(price: price);
  }

  /// Cập nhật số lượng tồn kho
  void setStockQuantity(int quantity) {
    _state = _state.copyWith(stockQuantity: quantity);
  }

  /// Cập nhật category
  void setCategoryId(int id) {
    _state = _state.copyWith(categoryId: id);
  }

  /// Cập nhật image URL
  void setImageUrl(String url) {
    _state = _state.copyWith(imageUrl: url);
  }

  /// Tạo sản phẩm mới
  Future<void> createProduct() async {
    if (_state.productName == null || _state.price == null || _state.categoryId == null) {
      _state = _state.copyWith(error: 'Vui lòng điền đầy đủ thông tin');
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final product = ProductCreate(
        productName: _state.productName!,
        price: _state.price!,
        stockQuantity: _state.stockQuantity,
        categoryId: _state.categoryId!,
        imageUrl: _state.imageUrl,
      );

      final success = await ProductRepo.createProduct(product);

      _state = _state.copyWith(
        isLoading: false,
        isSuccess: success,
        error: success ? null : 'Tạo sản phẩm thất bại',
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Lỗi: $e',
      );
    }
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _state = const ProductCreateState();
    notifyListeners();
  }
}
