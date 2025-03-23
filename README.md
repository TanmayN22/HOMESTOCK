# HomeStock - Pantry Management App

## 📱 About

HomeStock is a Flutter-based mobile application that helps you manage your home pantry efficiently. Track food items, monitor expiration dates, and streamline your grocery shopping process - all in one place.

## ✨ Features

- **🍎 Inventory Tracking**: Maintain a detailed database of all food items in your pantry
- **⏱️ Expiration Monitoring**: Get alerts on items nearing expiration to reduce food waste
- **🛒 Shopping Cart Integration**: Easily add depleted items to your shopping list
- **🔍 Category Filtering**: Browse your pantry by food categories (Vegetables, Grains, Dairy, etc.)
- **🗑️ Bin Management**: Archive expired or consumed items for future reference
- **📊 Quantity Control**: Track and update quantities as you use items

## 📸 Screenshots

<div style="display: flex; flex-wrap: nowrap; gap: 10px;">
  <img src="https://github.com/user-attachments/assets/11c212b6-8bdf-49b5-a8ae-0a4b2c7897e1" alt="Screenshot 1" width="200"/>
  <img src="https://github.com/user-attachments/assets/ca72e6fa-af16-4ec0-91a2-bea30a04553b" alt="Screenshot 2" width="200"/>
  <img src="https://github.com/user-attachments/assets/7fa19d2a-d1f8-4e8b-9701-f9505a75cc3d" alt="Screenshot 3" width="200"/>
  <img src="https://github.com/user-attachments/assets/abee16bd-281d-40b0-9b05-1e10db08257f" alt="Screenshot 4" width="200"/>
</div>

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Getx
- **Database**: SQLite
- **CI/CD**: GitHub Actions

## 🔧 Project Structure

```
lib/
├── main.dart
├── database/
├── models/
├── utils/
│   └── constants/
│   └── device/
│   └── helpers/
│   └── themes/
├── views/
└── widgets/
    └── custom_shapes/
    └── custom_widgets/
```

## 📋 Usage Guide

1. **Adding Items**: Tap the "+" button to add new items to your inventory
2. **Managing Quantities**: Use the +/- buttons to adjust quantities
3. **Shopping**: Items with 0 quantity are added to shopping suggestions
4. **Expiration Tracking**: Items are color-coded based on expiration status and notifications
5. **Bin Management**: Access the Bin to see expired or finished items

## 🚀 Installation

### Prerequisites
- Flutter (version 3.0.0 or higher)
- Dart (version 2.17.0 or higher)
- Android Studio / Xcode for emulators

```bash
# Clone the repository
git clone https://github.com/your-username/homestock.git

# Navigate to the project directory
cd homestock

# Get Flutter dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## 🧪 Running Tests

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Check code coverage
flutter test --coverage
```

## 📱 Supported Platforms

- Android
- iOS
- Web (future support)

## 🔄 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows the project's style guidelines and passes all tests.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

