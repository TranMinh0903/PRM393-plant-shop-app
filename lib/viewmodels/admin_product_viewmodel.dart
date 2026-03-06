import 'package:flutter/foundation.dart' hide Category;
import '../models/product.dart';
import '../models/product_create.dart';
import '../models/category.dart';
import '../models/category_create.dart';
import '../repositories/product_repo.dart';
import '../services/category_service.dart';

/// ViewModel quản lý toàn bộ CRUD Product & Category cho Admin
class AdminProductViewModel extends ChangeNotifier {
  // State for Products
  List<Product> _products = [];
  bool _isLoadingProducts = false;
  String? _productError;

  // State for Categories
  List<Category> _categories = [];
  bool _isLoadingCategories = false;

  // State for dialogs
  String? _editingProductName;
  double? _editingPrice;
  int? _editingStockQuantity;
  int? _editingCategoryId;
  String? _editingImageUrl;
  int? _editingProductId;

  // Getters
  List<Product> get products => _products;
  bool get isLoadingProducts => _isLoadingProducts;
  String? get productError => _productError;
  List<Category> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;

  // Dialog state getters
  String? get editingProductName => _editingProductName;
  double? get editingPrice => _editingPrice;
  int? get editingStockQuantity => _editingStockQuantity;
  int? get editingCategoryId => _editingCategoryId;
  String? get editingImageUrl => _editingImageUrl;
  int? get editingProductId => _editingProductId;

  /// Khởi tạo - load categories và products
  Future<void> initialize() async {
    await loadCategories();
    await loadProducts();
  }

  /// Load danh sách categories
  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      _categories = await CategoryService.getCategories();
    } catch (_) {
      // Error is handled by UI or ignored for now
    }
    _isLoadingCategories = false;
    notifyListeners();
  }

  /// Load danh sách products
  Future<void> loadProducts({
    int pageIndex = 1,
    String? productName,
    String? categoryName,
  }) async {
    _isLoadingProducts = true;
    _productError = null;
    notifyListeners();

    try {
      _products = await ProductRepo.getProducts(
        pageIndex: pageIndex,
        pageSize: 10,
        productName: productName,
        categoryName: categoryName,
      );
    } catch (e) {
      _productError = 'Lỗi tải sản phẩm: $e';
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  /// Tạo product mới
  Future<bool> createProduct({
    required String productName,
    required double price,
    required int categoryId,
    int? stockQuantity,
    String? imageUrl,
  }) async {
    try {
      final success = await ProductRepo.createProduct(
        ProductCreate(
          productName: productName,
          price: price,
          stockQuantity: stockQuantity,
          categoryId: categoryId,
          imageUrl: imageUrl,
        ),
      );

      if (success) {
        await loadProducts(); // Reload products list
      } else {
        _productError = 'Tạo sản phẩm thất bại';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _productError = 'Lỗi: $e';
      notifyListeners();
      return false;
    }
  }

  /// Cập nhật product
  Future<bool> updateProduct({
    required int id,
    required String productName,
    required double price,
    required int categoryId,
    int? stockQuantity,
    String? imageUrl,
  }) async {
    try {
      final data = {
        'productName': productName,
        'price': price,
        'stockQuantity': stockQuantity,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
      };

      final success = await ProductRepo.updateProduct(id, data);

      if (success) {
        await loadProducts(); // Reload products list
      } else {
        _productError = 'Cập nhật sản phẩm thất bại';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _productError = 'Lỗi: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xóa product
  Future<bool> deleteProduct(int id) async {
    _productError = null;
    notifyListeners();
    try {
      final success = await ProductRepo.deleteProduct(id);

      if (success) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
        // Optionale full reload in the background
        loadProducts();
      } else {
        _productError = 'Xóa sản phẩm thất bại';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _productError = 'Lỗi: $e';
      notifyListeners();
      return false;
    }
  }

  /// Set dialog editing state for create
  void setCreateMode() {
    _editingProductId = null;
    _editingProductName = null;
    _editingPrice = null;
    _editingStockQuantity = null;
    _editingCategoryId = null;
    _editingImageUrl = null;
    notifyListeners();
  }

  /// Set dialog editing state for update
  void setEditMode(Product product) {
    _editingProductId = product.id;
    _editingProductName = product.productName;
    _editingPrice = product.price;
    _editingStockQuantity = product.stockQuantity;
    _editingCategoryId = product.categoryId;
    _editingImageUrl = product.imageUrl;
    notifyListeners();
  }

  // Variables for Dialog
  String? _editingCategoryName;
  String? _editingCategoryDescription;

  // Additional Getters
  String? get editingCategoryName => _editingCategoryName;
  String? get editingCategoryDescription => _editingCategoryDescription;

  /// Set dialog state cho Category (Create)
  void setCategoryCreateMode() {
    _editingCategoryId = null;
    _editingCategoryName = null;
    _editingCategoryDescription = null;
    notifyListeners();
  }

  /// Set dialog state cho Category (Update)
  void setCategoryEditMode(Category category) {
    _editingCategoryId = category.id;
    _editingCategoryName = category.categoryName;
    _editingCategoryDescription = category.description;
    notifyListeners();
  }

  void setCategoryNameInput(String value) {
    _editingCategoryName = value;
    notifyListeners();
  }

  void setCategoryDescriptionInput(String value) {
    _editingCategoryDescription = value;
    notifyListeners();
  }

  /// Tạo danh mục mới
  Future<bool> createCategory({
    required String categoryName,
    String? description,
  }) async {
    try {
      final success = await CategoryService.createCategory(
        CategoryCreate(categoryName: categoryName, description: description),
      );

      if (success) {
        await loadCategories();
      } else {
        _productError = 'Thêm danh mục thất bại';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _productError = 'Lỗi: $e';
      notifyListeners();
      return false;
    }
  }

  /// Cập nhật danh mục
  Future<bool> updateCategory({
    required int id,
    required String categoryName,
    String? description,
  }) async {
    try {
      Map<String, dynamic> data = {
        'categoryName': categoryName,
        'description': description,
      };

      final success = await CategoryService.updateCategory(id, data);
      if (success) {
        await loadCategories();
      } else {
        _productError = 'Cập nhật danh mục thất bại';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _productError = 'Lỗi: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xóa danh mục
  Future<bool> deleteCategory(int id) async {
    _productError = null;
    notifyListeners();
    try {
      final success = await CategoryService.deleteCategory(id);
      if (success) {
        _categories.removeWhere((c) => c.id == id);
        notifyListeners();
        // Optionale full reload in the background
        loadCategories();
      } else {
        _productError = 'Xóa danh mục thất bại';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _productError = 'Lỗi: $e';
      notifyListeners();
      return false;
    }
  }

  void setProductName(String value) {
    _editingProductName = value;
    notifyListeners();
  }

  void setPrice(double value) {
    _editingPrice = value;
    notifyListeners();
  }

  void setStockQuantity(int value) {
    _editingStockQuantity = value;
    notifyListeners();
  }

  void setCategoryId(int value) {
    _editingCategoryId = value;
    notifyListeners();
  }

  void setImageUrl(String value) {
    _editingImageUrl = value;
    notifyListeners();
  }

  void clearError() {
    _productError = null;
    notifyListeners();
  }
}
