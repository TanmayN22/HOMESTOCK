// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:home_stock/database/db_helper.dart'; // Database Helper
import 'package:home_stock/utils/validation_utils.dart'; // Validation Utility
import 'package:home_stock/utils/date_picker_helper.dart'; // Date Picker Utility
import '../utils/app_colors.dart'; //

class BottomSheetView extends StatefulWidget {
  final Map<String, dynamic>? item;
  const BottomSheetView({super.key, this.item});

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  // Controllers for Text Fields
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  // Category and Unit options
  List<String> category = ['Vegetables', 'Fruits', 'Grains', 'Rice', 'Dairy'];
  List<String> quantity = ['Kg', 'g', 'L', 'ml'];
  String? selectedCategory = 'Vegetables';
  String? selectedUnit = 'Kg';
  bool isUpdate = false;

  // Date Picker: Opens a date picker dialog for selecting expiry date
  Future<void> _selectDate() async {
    DateTime? picked = await DatePickerHelper.selectDate(context); // Reusable method
    if (picked != null) {
      setState(() {
        expiryDateController.text = picked.toLocal().toString().split(' ')[0]; // Format date
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers when widget is destroyed
    itemNameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  // Form Validation
  bool _isFormValid() {
    return ValidationUtils.isFormValid(
      itemNameController.text,
      selectedCategory,
      quantityController.text,
      selectedUnit,
      expiryDateController.text,
    );
  }

  // Check if editing
  @override
  void initState() {
    super.initState();

    // Check if editing an item (if item is passed)
    if (widget.item != null) {
      isUpdate = true;

      // Initialize fields with item data
      itemNameController.text = widget.item!['name'] ?? '';
      selectedCategory = widget.item!['category'] ?? '';
      expiryDateController.text = widget.item!['expiryDate'] ?? '';
      quantityController.text = widget.item!['quantity'].toString();
      selectedUnit = widget.item!['unit'] ?? 'Kg'; // Set the unit
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 145),
            child: Text(
              isUpdate ? 'Update Item' : 'Add Item',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 21),

          // Item Name Input Field
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text('Item'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: itemNameController,
            decoration: InputDecoration(
              hintText: 'Enter an item name',
              hintStyle: const TextStyle(fontWeight: FontWeight.normal),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Category, Quantity and Unit Fields
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 98),
                child: Text('Category '),
              ),
              Text('Quantity'),
              SizedBox(width: 90),
              Text('Unit'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Category Dropdown
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: DropdownMenu(
                  menuStyle: MenuStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  width: 150,
                  hintText: 'Select category',
                  dropdownMenuEntries: category.map((category) => DropdownMenuEntry(value: category, label: category)).toList(),
                  onSelected: (String? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
              // Quantity Input Field
              SizedBox(
                width: 110,
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Unit Dropdown
              DropdownMenu<String>(
                menuStyle: MenuStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                width: 90,
                initialSelection: selectedUnit,
                dropdownMenuEntries: quantity.map((unit) => DropdownMenuEntry<String>(value: unit, label: unit)).toList(),
                onSelected: (String? value) {
                  setState(() {
                    selectedUnit = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Expiry Date Field (with calendar icon)
          TextField(
            controller: expiryDateController,
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              filled: true,
              fillColor: Colors.white12,
              prefixIcon: const Icon(Icons.calendar_month),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.neutralColor),
                borderRadius: BorderRadius.circular(11),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.neutralColor),
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            readOnly: true,
            onTap: _selectDate,
          ),
          const SizedBox(height: 30),
          // Buttons (Add and Cancel)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      side: const BorderSide(width: 1),
                    ),
                    onPressed: () async {
                      debugPrint("Button Pressed: ${isUpdate ? 'Update' : 'Add'}");
                      if (_isFormValid()) {
                        try {
                          if (isUpdate) {
                            debugPrint("Attempting to update item...");
                            bool check = await DBHelper.instance.updateItem(
                              sno: widget.item!['s_no'],
                              name: itemNameController.text,
                              category: selectedCategory!,
                              expiryDate: expiryDateController.text,
                              quantity: int.parse(quantityController.text),
                              unit: selectedUnit!,
                            );
                            debugPrint("Update result: $check");
                            if (check) {
                              Navigator.pop(context, true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Item updated successfully')),
                              );
                            }
                          } else {
                            debugPrint("Attempting to add new item...");
                            bool insert = await DBHelper.instance.addItem(
                              name: itemNameController.text,
                              category: selectedCategory!,
                              expiryDate: expiryDateController.text,
                              quantity: int.parse(quantityController.text),
                              unit: selectedUnit!,
                            );
                            debugPrint("Insert result: $insert");
                            if (insert) {
                              Navigator.pop(context, true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Item added successfully')),
                              );
                            }
                          }
                        } catch (e) {
                          debugPrint("Error occurred: $e");
                        }
                      } else {
                        debugPrint("Form validation failed");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all the required fields'),
                            backgroundColor: AppColors.errorColor,
                          ),
                        );
                      }
                    },
                    child: Text(
                      isUpdate ? 'Update' : 'Add',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.neutralVariantColor, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
