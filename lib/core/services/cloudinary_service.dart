import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Service upload ảnh lên Cloudinary (unsigned upload)
class CloudinaryService {
  CloudinaryService._();

  /// Upload ảnh từ bytes (web hoặc mobile) lên Cloudinary
  /// Trả về URL ảnh nếu thành công, null nếu thất bại
  static Future<String?> uploadImage(List<int> imageBytes, String fileName) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(CloudinaryConfig.uploadUrl));

      request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
      request.fields['folder'] = CloudinaryConfig.folder;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName,
        ),
      );

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['secure_url'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
