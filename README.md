# 🌿 Plant Shop App - PRM393

Ứng dụng di động Flutter phục vụ mô hình kinh doanh cây cảnh (E-commerce).

## 📋 Mô tả

Ứng dụng giải quyết hai vấn đề chính:
1. **Khách hàng:** Tìm kiếm, xem thông tin, đặt mua cây cảnh online và được giao hàng tận nơi
2. **Cửa hàng (Admin):** Quản lý kho hàng, đơn hàng và chăm sóc khách hàng
3. **Shipper:** Nhận đơn, giao hàng với Google Maps và xác nhận bằng ảnh

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Backend | Firebase (Auth, Firestore, Storage, FCM) |
| Architecture | Clean Architecture |
| State Management | BLoC |
| Navigation | go_router |
| DI | get_it + injectable |
| Maps | Google Maps Flutter |

## 📁 Project Structure

```
lib/
├── main.dart                  # Entry point
├── app.dart                   # Root widget
├── core/                      # Shared utilities
│   ├── constants/             # Colors, strings, dimensions
│   ├── theme/                 # App theme
│   ├── routes/                # Route configuration
│   └── utils/                 # Helper functions
├── features/                  # Feature modules
│   ├── auth/                  # Authentication
│   ├── product/               # Products
│   ├── cart/                  # Shopping cart
│   ├── order/                 # Orders & checkout
│   ├── map/                   # Google Maps
│   ├── chat/                  # Real-time chat
│   ├── notification/          # Push notifications
│   ├── admin/                 # Admin management
│   └── shipper/               # Shipper delivery
└── shared/                    # Shared widgets & models
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.10.7
- Android Studio / VS Code
- Firebase project configured

### Installation
```bash
git clone https://github.com/TranMinh0903/PRM393-plant-shop-app.git
cd PRM393-plant-shop-app
flutter pub get
flutter run
```

### Firebase Setup
1. Tạo project trên [Firebase Console](https://console.firebase.google.com/)
2. Thêm Android app với package name: `com.prm393.plant_shop_app`
3. Download `google-services.json` → đặt vào `android/app/`
4. Enable Authentication, Firestore, Storage, Cloud Messaging

## 👥 Team Members

| Name | Role |
|---|---|
| TranMinh0903 | Developer |

## 📄 License

This project is for educational purposes - PRM393 at FPT University.
