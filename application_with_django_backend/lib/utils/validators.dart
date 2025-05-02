/// Utility class for form field validations in the marketplace app.
class Validators {
  /// Validates that a field is not empty.
  /// Returns a function that checks if the input is null or empty after trimming.
  static String? Function(String?) required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $fieldName';
      }
      return null;
    };
  }

  /// Validates an email address.
  /// Returns a function that checks for non-empty input and valid email format.
  static String? Function(String?) email() {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your email';
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Please enter a valid email';
      }
      return null;
    };
  }

  /// Validates a password.
  /// Returns a function that ensures the password is non-empty and at least 8 characters.
  static String? Function(String?) password() {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your password';
      }
      if (value.trim().length < 8) {
        return 'Password must be at least 8 characters';
      }
      return null;
    };
  }

  /// Validates a username.
  /// Returns a function that ensures the username is alphanumeric and at least 3 characters.
  static String? Function(String?) username() {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your username';
      }
      final usernameRegex = RegExp(r'^[a-zA-Z0-9]+$');
      if (!usernameRegex.hasMatch(value.trim())) {
        return 'Username must contain only letters and numbers';
      }
      if (value.trim().length < 3) {
        return 'Username must be at least 3 characters';
      }
      return null;
    };
  }

  /// Validates a numeric field (e.g., price, quantity).
  /// Returns a function that ensures the input is a valid positive number.
  static String? Function(String?) number(String fieldName, {bool allowZero = false}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $fieldName';
      }
      final parsed = double.tryParse(value.trim());
      if (parsed == null) {
        return '$fieldName must be a valid number';
      }
      if (!allowZero && parsed <= 0) {
        return '$fieldName must be greater than zero';
      }
      if (allowZero && parsed < 0) {
        return '$fieldName cannot be negative';
      }
      return null;
    };
  }

  /// Validates a quantity field.
  /// Returns a function that ensures the input is a positive integer.
  static String? Function(String?) quantity() {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter quantity';
      }
      final parsed = int.tryParse(value.trim());
      if (parsed == null) {
        return 'Quantity must be a valid number';
      }
      if (parsed <= 0) {
        return 'Quantity must be greater than zero';
      }
      return null;
    };
  }

  /// Validates a text field with a maximum length.
  /// Returns a function that checks if the input exceeds the max length.
  static String? Function(String?) maxLength(String fieldName, int maxLength) {
    return (String? value) {
      if (value != null && value.trim().length > maxLength) {
        return '$fieldName cannot exceed $maxLength characters';
      }
      return null;
    };
  }

  /// Combines multiple validators for a single field.
  /// Returns a function that applies each validator in sequence, returning the first error.
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (var validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}