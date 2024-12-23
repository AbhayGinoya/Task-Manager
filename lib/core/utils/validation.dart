
import 'package:task_manager/data/models/pair.dart';

abstract final class Validation {

  /// For Password Validation
 static Pair<bool, String?> passwordValidation(String? value) {
    String regString = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$';

    if (value == null || value.isEmpty) {
      return Pair<bool, String>(true, "Please enter password.");
    } else if (!RegExp(regString).hasMatch(value)) {
      return Pair<bool, String>(true, "Password must have \n• One capital letter \n• One lowercase letter\n• One symbol\n• One number\n• 8 characters long");
    } else {
      return Pair(false, null);
    }
  }

  /// For Email Validation
 static Pair<bool, String?> emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return Pair<bool, String>(true, "Please enter email.");
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return Pair<bool, String>(true, "Enter valid email.");
    } else {
      return Pair(false, null);
    }
  }

  /// For Title Validation
 static Pair<bool, String?> titleValidation(String? value) {
    if (value == null || value.isEmpty) {
      return Pair<bool, String>(true, "Please enter title.");
    } else {
      return Pair(false, null);
    }
  }

  /// For Status Validation
 static Pair<bool, String?> descriptionValidation(String? value) {
    if (value == null || value.isEmpty) {
      return Pair<bool, String>(true, "Please enter description.");
    } else {
      return Pair(false, null);
    }
  }



}