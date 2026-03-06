# Plant Shop App (Mobile)

Ứng dụng **quản lý & kinh doanh cây cảnh** được xây dựng bằng **Flutter (Mobile)** và **Backend API (Docker)**.

---

# 1. Yêu cầu hệ thống

Trước khi chạy project, đảm bảo đã cài đặt:

- Flutter SDK
- Android Studio / Android Emulator
- Docker & Docker Compose
- Git

Kiểm tra Flutter:

```bash
flutter doctor
```

Tất cả mục nên có dấu `✓`.

---

# 2. Clone dự án

Clone source code Mobile App:

```bash
git clone https://github.com/your-organization/PRM393-plant-shop-app.git
cd PRM393-plant-shop-app
```

Clone Backend API:

```bash
git clone https://github.com/TranMinh0903/TreeShop
cd TreeShop
```

---

# 3. Chạy Backend API

Backend chạy bằng **Docker Compose**.

```bash
docker compose up -d --build
```

Sau khi chạy thành công, truy cập Swagger:

```
http://localhost:9090/swagger/index.html
```

Các bước test nhanh API:

1. Register account
2. Login
3. Tạo product để test mobile app

---

# 4. Cấu hình API Endpoint (Flutter)

File cấu hình:

```
lib/services/api_config.dart
```

### Android Emulator

```dart
static const String baseUrl = 'http://10.0.2.2:9090/api/v1';
```

`10.0.2.2` là **alias của localhost từ Android Emulator**.

---

### Android Device thật

Tìm IP máy tính.

Windows:

```bash
ipconfig
```

Cấu hình:

```dart
static const String baseUrl = 'http://192.168.1.5:9090/api/v1';
```

---

# 5. Cài đặt Flutter Dependencies

Trong thư mục project Flutter:

```bash
flutter pub get
```

Nếu gặp lỗi dependency:

```bash
flutter clean
flutter pub get
```

---

# 6. Cấu hình Cloudinary (Upload ảnh)

File cấu hình:

```
lib/services/api_config.dart
```

```dart
class CloudinaryConfig {
  static const String cloudName = 'your-cloud-name';
  static const String uploadPreset = 'your-upload-preset';
}
```

---

# 7. Chạy ứng dụng

## Chạy bằng Android Emulator

Liệt kê emulator:

```bash
flutter emulators
```

Start emulator:

```bash
flutter emulators --launch emulator_name
```

Run app:

```bash
flutter run
```

---

## Chạy trên thiết bị thật

Kết nối thiết bị Android qua USB.

Sau đó chạy:

```bash
flutter run
```

# JWT Authentication

Token được lưu tại:

```
lib/services/auth_storage.dart
```

Sau khi login:

```dart
AuthStorage.token = 'jwt-token';
```

`ApiClient` (trong `lib/services/api_client.dart`) sẽ tự động attach header:

```
Authorization: Bearer <token>
```

---

# 11. Cấu trúc thư mục

```
lib/
├── main.dart                    # Entry point của ứng dụng
├── app.dart                     # App configuration
├── firebase_options.dart
│
├── models/                      # Data models
│   ├── api_response.dart
│   ├── product.dart
│   ├── product_create.dart
│   ├── category.dart
│   └── category_create.dart
│
├── services/                    # API & services
│   ├── api_client.dart          # HTTP client for API calls
│   ├── api_config.dart          # API configuration
│   ├── app_constants.dart       # App constants
│   ├── app_routes.dart          # Navigation routes
│   ├── auth_service.dart        # Authentication service
│   ├── auth_storage.dart        # Token storage
│   ├── category_service.dart    # Category API service
│   ├── cloudinary_service.dart  # Image upload service
│   └── db_helper.dart           # Local database helper
│
├── repositories/                # Data repositories (BLoC pattern)
│
├── viewmodels/                  # ViewModel layer (Business logic)
│
├── views/                       # UI Screens
│   ├── admin_manage_screen.dart
│   ├── cart_screen.dart
│   ├── create_product_screen.dart
│   ├── login_screen.dart
│   ├── product_details_screen.dart
│   ├── product_screen.dart
│   └── shipper_deliveries_screen.dart
│
└── widgets/                     # Reusable UI components
```

---

# 12. Troubleshooting

## Không gọi được API

Kiểm tra:

- Backend đang chạy
- URL đúng trong `lib/services/api_config.dart` (`10.0.2.2` cho emulator)
- Port `9090` mở

Test nhanh:

```
http://10.0.2.2:9090/swagger/index.html
```

## Flutter không build

Thử:

```bash
flutter clean
flutter pub get
flutter run
```
