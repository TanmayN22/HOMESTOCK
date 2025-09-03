// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item_model.dart';
import '../utils/helpers/noti_service.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper instance = DBHelper._();

  // Table and column names
  static const String TABLE_ITEM = "item";
  static const String COLUMN_ITEM_SNO = "s_no";
  static const String COLUMN_ITEM_NAME = "name";
  static const String COLUMN_ITEM_CATEGORY = "category";
  static const String COLUMN_ITEM_EXPIRY = "expiry_date";
  static const String COLUMN_ITEM_QUANTITY = "quantity";
  static const String COLUMN_ITEM_UNIT = "unit";
  static const String COLUMN_ITEM_IN_CART = "is_in_cart";

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "pantryDB.db");

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_ITEM (
        $COLUMN_ITEM_SNO INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_ITEM_NAME TEXT NOT NULL,
        $COLUMN_ITEM_CATEGORY TEXT NOT NULL,
        $COLUMN_ITEM_EXPIRY TEXT NOT NULL,
        $COLUMN_ITEM_QUANTITY INTEGER NOT NULL,
        $COLUMN_ITEM_UNIT TEXT NOT NULL,
        $COLUMN_ITEM_IN_CART INTEGER NOT NULL DEFAULT 0
      )
    ''');
    debugPrint('✅ Database created with table $TABLE_ITEM');
  }

  Future<bool> _columnExists(
      Database db, String tableName, String columnName) async {
    final result = await db.rawQuery('PRAGMA table_info($tableName)');
    for (var column in result) {
      if (column['name'] == columnName) {
        return true;
      }
    }
    return false;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from version $oldVersion to $newVersion');

    if (oldVersion < 2) {
      bool exists = await _columnExists(db, TABLE_ITEM, COLUMN_ITEM_IN_CART);

      if (!exists) {
        await db.execute(
            'ALTER TABLE $TABLE_ITEM ADD COLUMN $COLUMN_ITEM_IN_CART INTEGER NOT NULL DEFAULT 0');
        debugPrint('✅ Column $COLUMN_ITEM_IN_CART added!');
      } else {
        debugPrint('ℹ️ Column $COLUMN_ITEM_IN_CART already exists.');
      }
    }
  }

  Future<bool> addItem(Item item) async {
    try {
      final db = await database;
      int itemId = await db.insert(
        TABLE_ITEM,
        item.toMap(),
      );
      debugPrint('✅ Item inserted successfully with ID: $itemId');

      if (itemId > 0) {
        try {
          await NotiService().scheduleExpiryNotifications(
            itemId: itemId,
            itemName: item.name,
            expiryDate: DateTime.parse(item.expiryDate),
          );
        } catch (e) {
          debugPrint("⚠️ Could not schedule notifications: $e");
        }
      }

      return itemId > 0;
    } catch (e) {
      debugPrint("❌ Error inserting item: $e");
      return false;
    }
  }

  Future<List<Item>> getAllItems() async {
    try {
      final db = await database;
      final maps = await db.query(TABLE_ITEM, orderBy: '$COLUMN_ITEM_SNO DESC');
      debugPrint('✅ Fetched ${maps.length} items');
      return maps.map((map) => Item.fromMap(map)).toList();
    } catch (e) {
      debugPrint("❌ Error fetching items: $e");
      return [];
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      final db = await database;
      int rowsUpdated = await db.update(
        TABLE_ITEM,
        item.toMap(),
        where: "$COLUMN_ITEM_SNO = ?",
        whereArgs: [item.serialNumber],
      );
      debugPrint('✅ Item updated successfully ($rowsUpdated rows affected)');

      if (rowsUpdated > 0 && item.serialNumber != null) {
        try {
          await NotiService().cancelExpiryNotifications(item.serialNumber!);
          await NotiService().scheduleExpiryNotifications(
            itemId: item.serialNumber!,
            itemName: item.name,
            expiryDate: DateTime.parse(item.expiryDate),
          );
        } catch (e) {
          debugPrint("⚠️ Could not reschedule notifications: $e");
        }
      }
      return rowsUpdated > 0;
    } catch (e) {
      debugPrint('❌ Error updating item: $e');
      return false;
    }
  }

  Future<bool> deleteItem({required int sno}) async {
    try {
      var db = await database;
      int rowsDeleted = await db.delete(
        TABLE_ITEM,
        where: "$COLUMN_ITEM_SNO = ?",
        whereArgs: [sno],
      );
      debugPrint('✅ Item deleted successfully');

      if (rowsDeleted > 0) {
        try {
          await NotiService().cancelExpiryNotifications(sno);
        } catch (e) {
          debugPrint("⚠️ Could not cancel notifications: $e");
        }
      }

      return rowsDeleted > 0;
    } catch (e) {
      debugPrint('❌ Error deleting item: $e');
      return false;
    }
  }

  Future<void> deleteDatabaseFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "pantryDB.db");
    await deleteDatabase(dbPath);
    debugPrint('🗑️ Database deleted at $dbPath');
  }

  Future<List<Item>> getCartItems() async {
    try {
      final db = await database;
      final maps = await db.query(
        TABLE_ITEM,
        where: "$COLUMN_ITEM_IN_CART = ?",
        whereArgs: [1],
      );
      debugPrint('✅ Fetched ${maps.length} items in cart');
      return maps.map((map) => Item.fromMap(map)).toList();
    } catch (e) {
      debugPrint("❌ Error fetching cart items: $e");
      return [];
    }
  }
}