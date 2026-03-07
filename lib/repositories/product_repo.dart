import 'dart:convert';
import '../services/api_client.dart';
import '../models/product.dart';
import '../models/product_create.dart';

/// Repository xử lý CRUD products với BE Tree API
class ProductRepo {
  ProductRepo._();

  /// Lấy danh sách sản phẩm - GET /products
  static Future<List<Product>> getProducts({
    int pageIndex = 1,
    int pageSize = 10,
    String? productName,
    String? categoryName,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, String>{
        'pageIndex': pageIndex.toString(),
        'pageSize': pageSize.toString(),
      };
      if (productName != null) queryParams['productName'] = productName;
      if (categoryName != null) queryParams['categoryName'] = categoryName;
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();

      final response = await ApiClient.get(
        '/products',
        queryParams: queryParams,
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['isSuccess'] == true) {
        final data = body['data'];
        // API trả về paginated list với field 'items'
        final items = data['items'] as List? ?? [];
        return items.map((item) => Product.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Lấy chi tiết sản phẩm - GET /products/{id}
  static Future<Product?> getProductById(int id) async {
    try {
      final response = await ApiClient.get('/products/$id');
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['isSuccess'] == true) {
        return Product.fromJson(body['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Tạo sản phẩm mới - POST /products
  static Future<bool> createProduct(ProductCreate product) async {
    try {
      final response = await ApiClient.post('/products', product.toJson());
      final body = jsonDecode(response.body);
      return response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Cập nhật sản phẩm - PUT /products/{id}
  static Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.put('/products/$id', data);
      final body = jsonDecode(response.body);
      return response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Xóa sản phẩm - DELETE /products/{id}
  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await ApiClient.delete('/products/$id');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return true;
        try {
          final body = jsonDecode(response.body);
          return body['isSuccess'] == true;
        } catch (_) {
          return true; // Status code is success, ignore body decode error
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
