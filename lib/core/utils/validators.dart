import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';

class AppValidators {
  AppValidators._();

  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    
    if (value.length < AppConstants.passwordMinLength) {
      return AppStrings.minPasswordLength;
    }
    
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount < AppConstants.minTransactionAmount) {
      return AppStrings.invalidAmount;
    }
    
    return null;
  }
}
