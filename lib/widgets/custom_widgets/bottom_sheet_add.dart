// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:homestock/database/db_helper.dart'; // Database Helper
import 'package:homestock/utils/helpers/validation_utils.dart'; // Validation Utility
import 'package:homestock/utils/helpers/date_picker_helper.dart'; // Date Picker Utility
import '../../utils/themes/app_colors.dart';
import '../../models/item_model.dart';
import 'package:homestock/utils/constants/categories.dart';

class BottomSheetView extends StatefulWidget {
  final Item? item;
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
  List<String> category = CategoryConstants.categories;
  List<String> quantity = CategoryConstants.units;

  String? selectedCategory = 'Vegetables & Fruits';
  String? selectedUnit = 'Kg';
  bool isUpdate = false;
  bool isLoading = false; // Add loading state

  // Date Picker: Opens a date picker dialog for selecting expiry date
  Future<void> _selectDate() async {
    DateTime? picked = await DatePickerHelper.selectDate(context);
    if (picked != null) {
      setState(() {
        expiryDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers when widget is destroyed
    itemNameController.dispose();
    quantityController.dispose();
    expiryDateController.dispose();
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

  @override
  void initState() {
    super.initState();

    // Check if editing an item (if item is passed)
    if (widget.item != null) {
      isUpdate = true;
      itemNameController.text = widget.item!.name;
      selectedCategory = widget.item!.category;
      expiryDateController.text = widget.item!.expiryDate;
      quantityController.text = widget.item!.quantity.toString();
      selectedUnit = widget.item!.unit;
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

          // Category, Quantity, and Unit Fields
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: DropdownMenu(
                    menuStyle: MenuStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    width: 150,
                    initialSelection: selectedCategory,
                    dropdownMenuEntries:
                        category
                            .map(
                              (category) => DropdownMenuEntry(
                                value: category,
                                label: category,
                              ),
                            )
                            .toList(),
                    onSelected: (String? value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
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
                width: 90,
                initialSelection: selectedUnit,
                dropdownMenuEntries:
                    quantity
                        .map(
                          (unit) => DropdownMenuEntry<String>(
                            value: unit,
                            label: unit,
                          ),
                        )
                        .toList(),
                onSelected: (String? value) {
                  setState(() {
                    selectedUnit = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Expiry Date Field
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
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              setState(() {
                                isLoading = true; // Show loading state
                              });

                              debugPrint(
                                "Button Pressed: ${isUpdate ? 'Update' : 'Add'}",
                              );

                              if (_isFormValid()) {
                                try {
                                  final itemToSave = Item(
                                    serialNumber:
                                        isUpdate
                                            ? widget.item!.serialNumber
                                            : null,
                                    name: itemNameController.text.trim(),
                                    category: selectedCategory!,
                                    expiryDate: expiryDateController.text,
                                    quantity: int.parse(
                                      quantityController.text,
                                    ),
                                    unit: selectedUnit!,
                                    isInCart:
                                        isUpdate
                                            ? widget.item!.isInCart
                                            : false,
                                  );

                                  bool result;
                                  if (isUpdate) {
                                    result = await DBHelper.instance.updateItem(
                                      itemToSave,
                                    );
                                  } else {
                                    result = await DBHelper.instance.addItem(
                                      itemToSave,
                                    );
                                  }

                                  debugPrint(
                                    "${isUpdate ? 'Update' : 'Insert'} result: $result",
                                  );

                                  if (result) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isUpdate
                                                ? 'Item updated successfully'
                                                : 'Item added successfully',
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    }
                                  } else {
                                    throw Exception(
                                      'Database operation failed',
                                    );
                                  }
                                } catch (e) {
                                  debugPrint("Error occurred: $e");
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Failed to save item. Please try again.',
                                        ),
                                        backgroundColor: AppColors.errorColor,
                                      ),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              } else {
                                debugPrint("Form validation failed");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill all the required fields',
                                    ),
                                    backgroundColor: AppColors.errorColor,
                                  ),
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              isUpdate ? 'Update' : 'Add',
                              style: const TextStyle(color: Colors.white),
                            ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.neutralVariantColor),
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
