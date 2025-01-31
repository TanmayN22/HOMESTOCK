// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item_model.dart';

class DBHelper {
  // Private constructor for Singleton pattern
  DBHelper._();

  // Singleton instance
  static final DBHelper instance = DBHelper._();

  // Table and column names
  static const String TABLE_ITEM = "item";
  static const String COLUMN_ITEM_SNO = "s_no";
  static const String COLUMN_ITEM_NAME = "name";
  static const String COLUMN_ITEM_CATEGORY = "category";
  static const String COLUMN_ITEM_EXPIRY = "expiry_date";
  static const String COLUMN_ITEM_QUANTITY = "quantity";
  static const String COLUMN_ITEM_UNIT = "unit";

  Database? _database;

  // Get database instance (Lazy Initialization)
  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "pantryDB.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Create database tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_ITEM (
        $COLUMN_ITEM_SNO INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_ITEM_NAME TEXT NOT NULL,
        $COLUMN_ITEM_CATEGORY TEXT NOT NULL,
        $COLUMN_ITEM_EXPIRY TEXT NOT NULL,
        $COLUMN_ITEM_QUANTITY INTEGER NOT NULL,
        $COLUMN_ITEM_UNIT TEXT NOT NULL
      )
    ''');
  }

  // Handle database upgrades (if schema changes)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $TABLE_ITEM ADD COLUMN $COLUMN_ITEM_UNIT TEXT NOT NULL DEFAULT ""');
    }
  }

  // Add item using the Item model
  Future<bool> addItem(Item item) async {
    try {
      final db = await database;
      int rowsAffected = await db.insert(
        TABLE_ITEM,
        item.toMap(),
      );
      return rowsAffected > 0;
    } catch (e) {
      debugPrint("Error inserting item: $e");
      return false;
    }
  }

  // Get all items, now returning List<Item>
  Future<List<Item>> getAllItems() async {
    try {
      final db = await database;
      final maps = await db.query(TABLE_ITEM);
      return maps.map((map) => Item.fromMap(map)).toList();
    } catch (e) {
      debugPrint("Error fetching items: $e");
      return [];
    }
  }

  // Update an item using the Item model
  Future<bool> updateItem(Item item) async {
    try {
      final db = await database;
      int rowsUpdated = await db.update(
        TABLE_ITEM,
        item.toMap(),
        where: "$COLUMN_ITEM_SNO = ?",
        whereArgs: [item.serialNumber],
      );
      return rowsUpdated > 0;
    } catch (e) {
      debugPrint('Error updating item: $e');
      return false;
    }
  }

  // Delete an item
  Future<bool> deleteItem({required int sno}) async {
    try {
      var db = await database;
      int rowsDeleted = await db.delete(
        TABLE_ITEM, 
        where: "$COLUMN_ITEM_SNO = ?", 
        whereArgs: [sno]
      );
      return rowsDeleted > 0;
    } catch (e) {
      debugPrint('Error deleting an item: $e');
      return false;
    }
  }
}