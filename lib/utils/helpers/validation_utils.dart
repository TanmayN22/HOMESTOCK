class ValidationUtils {
  // This function validates all necessary fields to ensure the form is filled correctly.
  static bool isFormValid(String itemName, String? selectedCategory, String quantity, String? selectedUnit, String expiryDate) {
    return itemName.isNotEmpty &&
        selectedCategory != null &&
        quantity.isNotEmpty &&
        selectedUnit != null &&
        expiryDate.isNotEmpty;
  }
}