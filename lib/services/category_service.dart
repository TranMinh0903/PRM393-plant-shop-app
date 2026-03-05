import 'dart:convert';
import 'api_client.dart';
import '../models/category.dart';
import '../models/category_create.dart';

/// Service xử lý categories với BE Tree API
class CategoryService {
  CategoryService._();

  /// Lấy danh sách danh mục - GET /categories
  static Future<List<Category>> getCategories({
    int pageIndex = 1,
    int pageSize = 50,
  }) async {
    try {
      final queryParams = <String, String>{
        'pageIndex': pageIndex.toString(),
        'pageSize': pageSize.toString(),
      };

      final response = await ApiClient.get(
        '/categories',
        queryParams: queryParams,
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['isSuccess'] == true) {
        final data = body['data'];
        final items = data['items'] as List? ?? [];
        return items.map((item) => Category.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Tạo danh mục mới - POST /categories
  static Future<bool> createCategory(CategoryCreate category) async {
    try {
      final response = await ApiClient.post('/categories', category.toJson());
      final body = jsonDecode(response.body);
      return response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Cập nhật danh mục - PUT /categories/{id}
  static Future<bool> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.put('/categories/$id', data);
      final body = jsonDecode(response.body);
      return response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Xóa danh mục - DELETE /categories/{id}
  static Future<bool> deleteCategory(int id) async {
    try {
      final response = await ApiClient.delete('/categories/$id');
      final body = jsonDecode(response.body);
      return response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }
}
