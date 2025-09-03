import 'package:flutter/material.dart';

class CategoryConstants {
  static const List<String> categories = [
    'Vegetables & Fruits',
    'Grains & Pulses',
    'Dairy & Eggs',
    'Dry Fruits',
    'Spices',
    'Oils',
    'Flours',
    'Snacks',
    'Beverages',
    'Frozen Foods',
    'Sauces & Condiments',
    'Bakery',
    'Non.Veg',
  ];

  // Common units used in Indian households
  static const List<String> units = [
    'Kg',
    'g',
    'L',
    'ml',
    'no.', // For individual items like eggs, bread packets, etc.
    'Tsp', // Teaspoon (for spices, masala)
    'Tbsp', // Tablespoon
    'Cup', // Often used for rice, flour, sugar, etc.
    'Packet', // For packaged food
    'Bottle', // For oils, sauces, beverages
    'Box', // For sweets, dry fruits
    'Piece', // For bakery items, vegetables like cauliflower
  ];

  // Category Colors Adjusted to Match App Theme
  static const Color categoryColors = Colors.white;
}