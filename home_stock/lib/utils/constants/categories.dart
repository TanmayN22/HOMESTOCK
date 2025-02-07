import 'package:flutter/material.dart';

class CategoryConstants {
  static const List<String> categories = [
    'Vegetables',
    'Fruits',
    'Grains & Pulses',
    'Rice & Wheat',
    'Dairy & Eggs',
    'Dry Fruits & Nuts',
    'Spices & Masalas',
    'Oils & Ghee',
    'Flours & Atta',
    'Lentils (Dal)',
    'Snacks & Namkeen',
    'Instant Foods',
    'Beverages & Tea/Coffee',
    'Biscuits & Sweets',
    'Frozen Foods',
    'Pickles & Chutneys',
    'Sauces & Condiments',
    'Canned & Ready-to-Eat',
    'Bakery & Breads',
    'Meat & Seafood',
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
