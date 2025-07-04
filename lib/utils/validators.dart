/// A class containing static methods for form field validation.
/// This allows validation logic to be reused across different forms in the app.
class Validators {
  /// Validator for generic non-empty text fields (like note title or content).
  static String? notEmpty(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty.';
    }
    return null;
  }

  /// Validator for display names.
  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required.';
    }
    if (value.length < 3) {
      return 'Display name must be at least 3 characters long.';
    }
    return null;
  }

  /// Validator for email fields.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    // Regular expression for basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Validator for password fields.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }
}
