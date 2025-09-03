import 'package:homestock/database/db_helper.dart';

class Item {
  final int? serialNumber;
  final String name;
  final String category;
  final String expiryDate;
  final int quantity;
  final String unit;

  // ✅ New field to track if item is added to cart
  final bool isInCart;

  Item({
    this.serialNumber,
    required this.name,
    required this.category,
    required this.expiryDate,
    required this.quantity,
    required this.unit,
    this.isInCart = false,
  });

  /// Convert a map from the database into an Item object
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      serialNumber: map[DBHelper.COLUMN_ITEM_SNO],
      name: map[DBHelper.COLUMN_ITEM_NAME],
      category: map[DBHelper.COLUMN_ITEM_CATEGORY],
      expiryDate: map[DBHelper.COLUMN_ITEM_EXPIRY],
      quantity: map[DBHelper.COLUMN_ITEM_QUANTITY],
      unit: map[DBHelper.COLUMN_ITEM_UNIT],
      isInCart: map[DBHelper.COLUMN_ITEM_IN_CART] == 1,
    );
  }

  /// Convert an Item object to a map for database insertion/update
  Map<String, dynamic> toMap() {
    final map = {
      DBHelper.COLUMN_ITEM_NAME: name,
      DBHelper.COLUMN_ITEM_CATEGORY: category,
      DBHelper.COLUMN_ITEM_EXPIRY: expiryDate,
      DBHelper.COLUMN_ITEM_QUANTITY: quantity,
      DBHelper.COLUMN_ITEM_UNIT: unit,
      DBHelper.COLUMN_ITEM_IN_CART: isInCart ? 1 : 0, // SQLite stores booleans as ints
    };

    if (serialNumber != null) {
      map[DBHelper.COLUMN_ITEM_SNO] = serialNumber!;
    }

    return map;
  }

  /// ✅ Add copyWith for immutability and easy updates
  Item copyWith({
    int? serialNumber,
    String? name,
    String? category,
    String? expiryDate,
    int? quantity,
    String? unit,
    bool? isInCart,
  }) {
    return Item(
      serialNumber: serialNumber ?? this.serialNumber,
      name: name ?? this.name,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isInCart: isInCart ?? this.isInCart,
    );
  }
}