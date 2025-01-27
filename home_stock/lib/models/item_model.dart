import 'package:home_stock/database/db_helper.dart';

class Item {
  /// Unique serial number for the item in the database
  final int? serialNumber;

  /// Name of the item
  final String name;

  /// Category of the item (e.g., Vegetables, Fruits)
  final String category;

  /// Expiry date of the item
  final String expiryDate;

  /// Quantity of the item
  final int quantity;

  /// Unit of measurement for the item (e.g., Kg, g, L, ml)
  final String unit;

  /// Constructor for creating an Item instance
  Item({
    this.serialNumber,
    required this.name,
    required this.category,
    required this.expiryDate,
    required this.quantity,
    required this.unit,
  });

  /// Convert a database map to an Item object
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      serialNumber: map[DBHelper.COLUMN_ITEM_SNO],
      name: map[DBHelper.COLUMN_ITEM_NAME],
      category: map[DBHelper.COLUMN_ITEM_CATEGORY],
      expiryDate: map[DBHelper.COLUMN_ITEM_EXPIRY],
      quantity: map[DBHelper.COLUMN_ITEM_QUANTITY],
      unit: map[DBHelper.COLUMN_ITEM_UNIT],
    );
  }

  /// Convert an Item object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_ITEM_NAME: name,
      DBHelper.COLUMN_ITEM_CATEGORY: category,
      DBHelper.COLUMN_ITEM_EXPIRY: expiryDate,
      DBHelper.COLUMN_ITEM_QUANTITY: quantity,
      DBHelper.COLUMN_ITEM_UNIT: unit,
    };
  }
}