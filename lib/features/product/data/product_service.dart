import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../shared/models/product_model.dart';

/// Service xử lý products với BE Tree API
class ProductService {
  ProductService._();

  /// Lấy danh sách sản phẩm - GET /products
  static Future<List<ProductModel>> getProducts({
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

      final response = await ApiClient.get('/products', queryParams: queryParams);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['isSuccess'] == true) {
        final data = body['data'];
        // API trả về paginated list với field 'items'
        final items = data['items'] as List? ?? [];
        return items.map((item) => ProductModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Lấy chi tiết sản phẩm - GET /products/{id}
  static Future<ProductModel?> getProductById(int id) async {
    try {
      final response = await ApiClient.get('/products/$id');
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['isSuccess'] == true) {
        return ProductModel.fromJson(body['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
